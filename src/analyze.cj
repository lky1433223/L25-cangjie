//这里实现AST遍历分析，并且生成代码
package L25

import L25.vm.*
import L25.table.*
import L25.L25Exception.*
import std.collection.ArrayList

//TODO:留一个未解释的问题，没有传引用的方式吗，全局变量还是有点太抽象了
var global_code: Code = Code() // 虚拟机代码
var global_table: Table = Table() // 符号表
var lev = 0 //层级记录
var scop = 0 //作用域记录
var cnt_var = 0 //数据分配个数（相对地址）
var cnt_param = 0 //变量分配个数 

//分析AST树，返回pcode
func analyzeAST(ast: AST) {
    analyzeProgram(ast)
    return global_code
}

func analyzeProgram(ast: AST): Unit {
    if (ast.symbol != Symbol.program) {
        throw WrongSymbolException(toString(ast.symbol), toString(Symbol.program))
    }
    //第一个节点 一定是 ident
    let name = analyzeIdent(ast.children[0])

    global_table.enter(name, Kind.program)
    global_code.gen(Fct.jmp) //跳转
    var tid0 = global_table.position() //记录当前层级在符号表的id
    var cid_jmp = global_code.Position() //记录入口跳转指令id

    var main_block: AST
    if (ast.children.size == 3) { //有函数定义 分析
        var fun_def_list = ast.children[1]
        main_block = ast.children[2]
        analyzeFuncDefList(fun_def_list)
    } else { //没有函数定义 第二个儿子就是主函数
        main_block = ast.children[1]
    }

    //分析main函数
    global_code.codes[cid_jmp].a = global_code.Position() + 1 //更改初始跳转到起始地点
    global_code.gen(Fct.ini, l: 0, a: 0) //ini 申请栈空间  此时还不知道，需要后续回填
    var cid_ini = global_code.Position() //记录入口申请栈空间指令id
    cnt_var = 3 // cnt_var清零(3 保留静态链SL 动态链DL 返回地址RA)
    lev++ // 层级++
    scop = 1 // 作用域为1
    analyzeStmtList(main_block) //分析后面主函数子句
    global_table.tables[tid0].adr = global_code.Position() + 1 //更改符号表中，这个过程的地址
    global_table.tables[tid0].size = cnt_var //更改符号表中，这个过程的size
    global_code.codes[cid_ini].a = cnt_var //更改指令中申请的栈空间
    global_code.gen(Fct.opr, l: 0, a: toInt(Opr.ret)) //ret
    global_table.remove(scop)
    lev--
}

func analyzeFuncDefList(ast: AST) {
    if (ast.symbol != Symbol.fun_def_list) {
        throw WrongSymbolException(toString(ast.symbol), toString(Symbol.fun_def_list))
    }
    for (child in ast.children) {
        analyzeFuncDef(child)
    }
}

//函数调用过程：预留一个位置给返回值，然后压入参数，然后执行函数调用，最后需要出栈
func analyzeFuncDef(ast: AST) {
    if (ast.symbol != Symbol.fun_def) {
        throw WrongSymbolException(toString(ast.symbol), toString(Symbol.fun_def))
    }
    // 儿子有 ident [param] stmt return
    cnt_param = 0
    cnt_var = 3
    let name = analyzeIdent(ast.children[0])

    global_code.gen(Fct.jmp, l: 0, a: 0) //跳转地址后续回填
    var cid_jmp = global_code.Position()
    global_table.enter(name, Kind.function, level: lev, adr: global_code.Position(), size: 0, param: 0, scope: scop) //size param需要后续回填
    var tid0 = global_table.position()
    lev++
    scop = 1 // 作用域为1
    var stmt_list = ast.children[1]
    var ret = ast.children[2]
    if (ast.children.size == 4) {
        var param = ast.children[1]
        stmt_list = ast.children[2]
        ret = ast.children[3]
        //分析所有的参数，从-x - -1分配栈空间。他们的入栈和出栈在调用的时候处理
        analyzeParamList(param) {
            ident_list: ArrayList<AST> =>
            cnt_param = ident_list.size
            var param_adr = -cnt_param //变量的地址为负的，
            for (ident in ident_list) {
                let name = analyzeIdent(ident)
                // global_name.append(name)
                global_table.enter(name, Kind.variable, level: lev, adr: param_adr, scope: scop)
                param_adr++
            }
        }
    }

    //分析 stmt
    global_code.codes[cid_jmp].a = global_code.Position() + 1
    global_code.gen(Fct.ini, l: 0, a: 0) //ini 申请栈空间  此时还不知道，需要后续回填
    var cid_ini = global_code.Position()
    analyzeStmtList(stmt_list)
    global_table.tables[tid0].size = cnt_var //回填符号表中的变量个数
    global_table.tables[tid0].param = cnt_param //回填符号表中的参数个数
    global_code.codes[cid_ini].a = cnt_var //回填代码中的申请栈空间

    //进行返回值处理，回填到预留的地址
    analyzeExpr(ret) //返回值是一个表达式，计算后填入栈顶
    global_code.gen(Fct.sto, l: 0, a: -(cnt_param + 1)) //返回值写入到预留的返回值地址，也是回退之后的栈顶
    global_code.gen(Fct.opr, l: 0, a: toInt(Opr.ret)) //返回，执行相关的栈操作

    //清理临时的缓存
    //清除符号表
    global_table.remove(scop)
    //恢复lev
    lev--
}

func analyzeIdent(ast: AST): String {
    var name = String()
    match (ast.symbol) {
        case Symbol.ident(str) => name = str
        case _ => WrongSymbolException(toString(ast.symbol), toString(Symbol.ident(String())))
    }
    return name
}

func analyzeStmtList(ast: AST): Unit {
    if (ast.symbol != Symbol.stmt_list) {
        throw WrongSymbolException(toString(ast.symbol), toString(Symbol.stmt_list))
    }
    //stmt list节点有很多儿子
    for (child in ast.children) {
        analyzeStmt(child)
    }
}

func analyzeStmt(ast: AST): Unit {
    if (ast.symbol != Symbol.stmt) {
        throw WrongSymbolException(toString(ast.symbol), toString(Symbol.stmt))
    }
    //stmt节点只有一个儿子 是不同类型的语句
    var child = ast.children[0]
    match (child.symbol) {
        case Symbol.declare_stmt => analyzeDeclareStmt(child)
        case Symbol.assign_stmt => analyzeAssignStmt(child)
        case Symbol.if_stmt => analyzeIfStmt(child)
        case Symbol.while_stmt => analyzeWhileStmt(child)
        case Symbol.output_stmt => analyzeOutputStmt(child)
        case Symbol.input_stmt => analyzeInputStmt(child)
        case _ => throw WrongSymbolException("Wrong Symbol Exception, Except one of stmt symbol")
    }
}

func analyzeDeclareStmt(ast: AST) {
    if (ast.symbol != Symbol.declare_stmt) {
        throw WrongSymbolException(toString(ast.symbol), toString(Symbol.declare_stmt))
    }
    //第一个儿子是ident
    let identNode = ast.children[0]
    var name = analyzeIdent(identNode)
    //注册符号表，相对地址从3开始
    global_table.enter(name, Kind.variable, val: 0, level: lev, adr: cnt_var, scope: scop)
    cnt_var++

    //如果有第二个儿子，是一个表达式，需要进行计算并给变量赋值
    if (ast.children.size == 2) {
        let exprNode = ast.children[1]
        //计算表达式
        analyzeExpr(exprNode)
        //给变量赋值
        if (let Some(ident_id) <- global_table.position(name, Kind.variable)) {
            let table: TableSturct = global_table.tables[ident_id]
            global_code.gen(Fct.sto, l: lev - table.level, a: table.adr) //将栈顶存回
        } else {
            throw UnDeclaredIdent(toString(Kind.variable), name) //TODO:position
        }
    }
}

func analyzeAssignStmt(ast: AST) {
    if (ast.symbol != Symbol.assign_stmt) {
        throw WrongSymbolException(toString(ast.symbol), toString(Symbol.assign_stmt))
    }
    //AssignStmt有两个儿子，分别是ident和expr
    let ident = (ast.children[0] as Ident).getOrThrow()
    let name = ident.name
    if (let Some(ident_id) <- global_table.position(name, Kind.variable)) {
        let table: TableSturct = global_table.tables[ident_id]
        analyzeExpr(ast.children[1]) //先分析expr，将结果存回栈顶。
        global_code.gen(Fct.sto, l: lev - table.level, a: table.adr)
    } else {
        throw UnDeclaredIdent(toString(Kind.variable), name) //TODO:position
    }
}

func analyzeIfStmt(ast: AST) {
    if (ast.symbol != Symbol.if_stmt) {
        throw WrongSymbolException(toString(ast.symbol), toString(Symbol.if_stmt))
    }
    //子节点  bool_expr stmt_list [stmt_list]
    analyzeBoolExpr(ast.children[0])

    global_code.gen(Fct.jpc, l: 0, a: 0) //jpc 稍后会回填
    let cid_jpc = global_code.Position()
    //处理if block
    scop++
    analyzeStmtList(ast.children[1]);
    global_table.remove(scop)
    scop--

    global_code.codes[cid_jpc].a = global_code.Position() + 1
    if (ast.children.size == 3) {
        global_code.gen(Fct.jmp, l: 0, a: 0) //如果有else block就要跳过, jmp 稍后回填
        global_code.codes[cid_jpc].a = global_code.Position() + 1 //因为这里有else，会在if末尾添加jmp，所以jpc要再+1
        let cid_jmp = global_code.Position()
        //下面生成else部分的代码
        scop++
        analyzeStmtList(ast.children[2])
        global_table.remove(scop)
        scop--
        global_code.codes[cid_jmp].a = global_code.Position() + 1
    }
}

func analyzeWhileStmt(ast: AST) {
    if (ast.symbol != Symbol.while_stmt) {
        throw WrongSymbolException(toString(ast.symbol), toString(Symbol.while_stmt))
    }
    //子节点 bool_expr stmt_list 
    let cid_while = global_code.Position() //先记录起始的pcode id

    analyzeBoolExpr(ast.children[0])
    global_code.gen(Fct.jpc, l: 0, a: 0) //jpc 稍后会回填
    let cid_jpc = global_code.Position()

    //分析stmt_list
    scop++
    analyzeStmtList(ast.children[1])
    global_table.remove(scop)
    scop--
    global_code.gen(Fct.jmp, l: 0, a: cid_while + 1) //跳回起始
    global_code.codes[cid_jpc].a = global_code.Position() + 1 //回填跳转
}

func analyzeOutputStmt(ast: AST) {
    if (ast.symbol != Symbol.output_stmt) {
        throw WrongSymbolException(toString(ast.symbol), toString(Symbol.output_stmt))
    }
    //下一个节点是arg_list,实际需要做的是，遍历arg_list，对里面的每个expr执行计算，然后print,最后println
    analyzeArgList(ast.children[0]) {
        expr_list: ArrayList<AST> =>
        for (expr in expr_list) {
            analyzeExpr(expr) //先计算expr，结果会存在栈顶
            global_code.gen(Fct.opr, l: 0, a: toInt(Opr.prt))
        }
        global_code.gen(Fct.opr, l: 0, a: toInt(Opr.prtln))
    }
}

func analyzeInputStmt(ast: AST) {
    if (ast.symbol != Symbol.input_stmt) {
        throw WrongSymbolException(toString(ast.symbol), toString(Symbol.input_stmt))
    }
    //下一个节点是arg_list,需要的是每次输入一个，然后执行sto
    analyzeParamList(ast.children[0]) {
        ident_list: ArrayList<AST> => for (ident in ident_list) {
            let name = analyzeIdent(ident)
            global_code.gen(Fct.opr, l: 0, a: toInt(Opr.inp)) //读入到栈顶
            if (let Some(ident_id) <- global_table.position(name, Kind.variable)) {
                let table = global_table.tables[ident_id]
                global_code.gen(Fct.sto, l: lev - table.level, a: table.adr); //变量，找到变量地址并将其值填入
            } else {
                throw UnDeclaredIdent(toString(Kind.variable), name) //TODO:Position
            }
        }
    }
}

func analyzeExpr(ast: AST): Unit {
    if (ast.symbol != Symbol.expr) {
        throw WrongSymbolException(toString(ast.symbol), toString(Symbol.expr))
    }

    let expr = (ast as Expr).getOrThrow()

    if (ast.children.size == 1) { //只有一个节点，就是+-或无符号（默认+），如果是-直接进行变号
        analyzeTerm(ast.children[0]) //先分析儿子
        if (expr.opt == Opt.sub) {
            global_code.gen(Fct.opr, l: 0, a: toInt(Opr.rev))
        }
    } else { //有两个节点，一个expr一个term，先执行expr，然后分析term，然后生成运算符
        analyzeExpr(expr.children[0])
        analyzeTerm(expr.children[1])
        match (expr.opt) {
            case Opt.add => global_code.gen(Fct.opr, l: 0, a: toInt(Opr.add))
            case Opt.sub => global_code.gen(Fct.opr, l: 0, a: toInt(Opr.sub))
            case _ => throw WrongOptException(toString(expr.opt), toString(ast.symbol))
        }
    }
}

func analyzeTerm(ast: AST): Unit {
    if (ast.symbol != Symbol.term) {
        throw WrongSymbolException(toString(ast.symbol), toString(Symbol.term))
    }
    let term = (ast as Term).getOrThrow()
    if (let Some(opt) <- term.opt) { //是一个未处理完的表达式, term opt factor,先分析term
        analyzeTerm(term.children[0])
        analyzeFactor(term.children[1])
        match (opt) {
            case Opt.div => global_code.gen(Fct.opr, l: 0, a: toInt(Opr.div))
            case Opt.mul => global_code.gen(Fct.opr, l: 0, a: toInt(Opr.mul))
            case _ => throw WrongOptException(toString(opt), toString(ast.symbol))
        }
    } else { //是单个数字，也就没有符号了
        analyzeFactor(term.children[0])
    }
}

func analyzeFactor(ast: AST) {
    if (ast.symbol != Symbol.factor) {
        throw WrongSymbolException(toString(ast.symbol), toString(Symbol.factor))
    }
    let child = ast.children[0]
    //factor 只有一个节点 分别处理
    match (child.symbol) {
        //是符号表中的符号
        case Symbol.ident(name) => //取变量名做解析
            if (let Some(ident_id) <- global_table.position(name, Kind.variable)) { //如果找到了变量
                let table: TableSturct = global_table.tables[ident_id]
                global_code.gen(Fct.lod, l: lev - table.level, a: table.adr); //变量，找到变量地址并将其值入栈
            } else if (let Some(ident_id) <- global_table.position(name, Kind.constant)) { //如果找到了常量
                let table: TableSturct = global_table.tables[ident_id]
                global_code.gen(Fct.lit, l: 0, a: table.val) //常量 直接读常量
            } else {
                throw UnDeclaredIdent(toString(Kind.variable) + " or " + toString(Kind.constant), name) //TODO:Position
            }
        case Symbol.number(num) => global_code.gen(Fct.lit, l: 0, a: num) //数字，直接读数字
        case Symbol.expr => analyzeExpr(child) // 下一个节点是Expr，继续执行Expr
        case Symbol.func_call => analyzeFunCall(child) // 下一个节点是函数，调用函数
        case _ => throw WrongSymbolException("Wrong Symbol Exception, Except one of factor child")
    }
}

func analyzeBoolExpr(ast: AST) {
    if (ast.symbol != Symbol.bool_expr) {
        throw WrongSymbolException(toString(ast.symbol), toString(Symbol.bool_expr))
    }
    //ast: expr1 expr2
    let bool_expr = (ast as BoolExpr).getOrThrow()
    analyzeExpr(bool_expr.children[0])
    analyzeExpr(bool_expr.children[1])
    match (bool_expr.opt) {
        case Opt.eq => global_code.gen(Fct.opr, a: toInt(Opr.eq))
        case Opt.ne => global_code.gen(Fct.opr, a: toInt(Opr.ne))
        case Opt.le => global_code.gen(Fct.opr, a: toInt(Opr.le))
        case Opt.lt => global_code.gen(Fct.opr, a: toInt(Opr.lt))
        case Opt.ge => global_code.gen(Fct.opr, a: toInt(Opr.ge))
        case Opt.gt => global_code.gen(Fct.opr, a: toInt(Opr.gt))
        case _ => throw Exception() //细化这个处理
    }
}

func analyzeFunCall(ast: AST) {
    if (ast.symbol != Symbol.func_call) {
        throw WrongSymbolException(toString(ast.symbol), toString(Symbol.func_call))
    }
    //函数调用过程，先预留一个返回值的栈顶，然后压入参数，最后调用函数
    global_code.gen(Fct.lit, l: 0, a: 0) //栈顶压入一个0，留一个返回值
    if (ast.children.size == 2) { //有参数列表，处理参数
        analyzeArgList(ast.children[1]) {
            arg_list: ArrayList<AST> => for (arg in arg_list) {
                analyzeExpr(arg) //计算每一个参数，存入栈顶
            }
        }
    }
    let name = analyzeIdent(ast.children[0])
    if (let Some(ident_id) <- global_table.position(name, Kind.function)) {
        global_code.gen(Fct.cal, l: lev - global_table.tables[ident_id].level, a: global_table.tables[ident_id].adr) //生成调用指令

        //函数调用结束后，要把栈中的参数弹出
        for (_ in 0..global_table.tables[ident_id].param) {
            global_code.gen(Fct.pop)
        }
    } else {
        throw UnDeclaredIdent(toString(Kind.function), name) // TODO:Position
    }
}

//分析ArgList，不同的ArgList需要用不同的操作，因此传入fn函数
func analyzeArgList(ast: AST, fn: (ArrayList<AST>) -> Unit) {
    if (ast.symbol != Symbol.arg_list) {
        throw WrongSymbolException(toString(ast.symbol), toString(Symbol.arg_list))
    }
    fn(ast.children)
}

func analyzeParamList(ast: AST, fn: (ArrayList<AST>) -> Unit) {
    if (ast.symbol != Symbol.param_list) {
        throw WrongSymbolException(toString(ast.symbol), toString(Symbol.param_list))
    }
    fn(ast.children)
}
