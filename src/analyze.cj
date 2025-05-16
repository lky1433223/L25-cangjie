//这里实现AST遍历分析，并且生成代码
package L25
import L25.vm.*
import L25.table.*
import L25.L25Exception.*

//TODO: 没有传引用的方式吗，全局变量还是有点太抽象了
var global_code : Code = Code() // 虚拟机代码
var global_table: Table = Table() // 符号表
var lev = 0 //层级记录
var cnt_var = 0 //数据分配个数（相对地址）
//分析AST树，返回pcode
func analyze(ast:AST){
    analyzeProgram(ast)
    global_table.print()
    return global_code
}
func analyzeProgram(ast:AST):Unit{
    if(ast.symbol != Symbol.program){
        throw WrongSymbolException(toString(ast.symbol), toString(Symbol.program))
    }
    //第一个节点 一定是 ident
    let name = analyzeIdent(ast.children[0])
    
    global_table.enter(name, Kind.program)
    global_code.gen(Fct.jmp) //跳转
    var tid0 = global_table.position() //记录当前层级在符号表的id
    var cid0 = global_code.Position()  //记录起始指令id
    //TODO:分析函数定义


    //分析main函数
    cnt_var = 3 // cnt_var清零(3 保留静态链SL 动态链DL 返回地址RA)
    lev++       // 层级++
    analyzeStmtList(ast.children[1]) //分析后面子句
    
    global_code.codes[cid0].a = global_code.Position()+1 //更改初始跳转到起始地点
    global_table.tables[tid0].adr = global_code.Position()+1 //更改符号表中，这个过程的地址
    global_table.tables[tid0].size = cnt_var //更改符号表中，这个过程的size
    global_code.gen(Fct.ini,l:0, a:cnt_var) //ini 申请栈空间
    global_code.gen(Fct.opr,l:0, a:toInt(Opr.ret)) //ret
    lev--
}

func analyzeIdent(ast:AST):String{
    var name = String()
    match(ast.symbol){
        case Symbol.ident(str) => name = str
        case _ => WrongSymbolException(toString(ast.symbol), toString(Symbol.ident(String())))
    }
    return name
}

func analyzeStmtList(ast:AST):Unit{
    if (ast.symbol != Symbol.stmt_list) {
        throw WrongSymbolException(toString(ast.symbol), toString(Symbol.stmt_list))
    }
    //stmt list节点有很多儿子
    for(child in ast.children){
        analyzeStmt(child)
    }
}

func analyzeStmt(ast:AST):Unit{
    if (ast.symbol != Symbol.stmt) {
        throw WrongSymbolException(toString(ast.symbol), toString(Symbol.stmt))
    }
    //stmt节点只有一个儿子 是不同类型的语句
    var child = ast.children[0]
    match(child.symbol) {
        case Symbol.declare_stmt => analyzeDeclareStmt(child)
        case Symbol.assign_stmt => analyzeAssignStmt(child)
        case Symbol.if_stmt => analyzeIfStmt(child)
        case Symbol.while_stmt => analyzeWhileStmt(child)
        case Symbol.output_stmt => analyzeOutputStmt(child)
        case Symbol.input_stmt => analyzeInputStmt(child)
        case _ => throw WrongSymbolException("Wrong Symbol Exception, Except one of stmt symbol")
    }
}

func analyzeDeclareStmt(ast:AST){
    if (ast.symbol != Symbol.declare_stmt) {
        throw WrongSymbolException(toString(ast.symbol), toString(Symbol.declare_stmt))
    }
    //第一个儿子是ident
    let identNode = ast.children[0]
    var name = analyzeIdent(identNode)
    //注册符号表，相对地址从3开始
    global_table.enter(name, Kind.variable, val:0, level:lev, adr:cnt_var)
    cnt_var++

    //如果有第二个儿子，是一个表达式，需要进行计算并给变量赋值
    if(ast.children.size == 2){
        let exprNode = ast.children[1]
        //计算表达式
        analyzeExpr(exprNode)
        //给变量赋值
        if(let Some(ident_id) <- global_table.position(name)){
            let table: TableSturct = global_table.tables[ident_id]
            global_code.gen(Fct.sto, l:lev - table.level, a:table.adr)//将栈顶存回
        }
        else{
            //TODO：处理变量未声明异常
        }
    }
}

func analyzeAssignStmt(ast:AST){

}

func analyzeIfStmt(ast:AST){
    
}

func analyzeWhileStmt(ast:AST){
    
}

func analyzeOutputStmt(ast:AST){

}

func analyzeInputStmt(ast:AST){

}

func analyzeExpr(ast:AST):Unit{
    let expr = (ast as Expr).getOrThrow()
    //只有一个节点，就是+-或无符号（默认+），如果是-直接进行变号
    if(ast.children.size == 1){ 
        analyzeTerm(ast.children[0]) //先分析儿子
        if(expr.opt == Opt.sub){
            global_code.gen(Fct.opr, l:0, a:toInt(Opr.rev))
        }
    }
    //有两个节点，一个expr一个term，先执行expr，然后分析term，然后生成运算符
    else{
        analyzeExpr(expr.children[0])
        analyzeTerm(expr.children[1])
        match(expr.opt){
            case Opt.add => global_code.gen(Fct.opr, l:0, a:toInt(Opr.add))
            case Opt.sub => global_code.gen(Fct.opr, l:0, a:toInt(Opr.sub))
            case _ => throw Exception() //TODO:细化符号错误的异常
        }
    }
}
func analyzeTerm(ast:AST):Unit{
    let term = (ast as Term).getOrThrow()
    println("analyze Term")
    
    if(let Some(opt) <- term.opt){ //是一个未处理完的表达式, term opt factor,先分析term
        print(opt.toInt())
        print(" ")
        println(term.children.size)
        analyzeTerm(term.children[0])
        analyzeFactor(term.children[1])
        match(opt){
            case Opt.div => global_code.gen(Fct.opr, l:0, a:toInt(Opr.div))
            case Opt.mul => global_code.gen(Fct.opr, l:0, a:toInt(Opr.mul))
            case _ => throw Exception() //TODO:细化符号错误的异常
        }
    }
    else{                          //是单个数字，也就没有符号了
        println("no opt ")
        println(term.children.size)
        analyzeFactor(term.children[0])
    }
}
func analyzeFactor(ast:AST){
    let child = ast.children[0]
    //factor 只有一个节点 分别处理
    match(child.symbol){
        //是符号表中的符号
        case Symbol.ident(name) => //给变量赋值
                                    if(let Some(ident_id) <- global_table.position(name)){
                                        let table: TableSturct = global_table.tables[ident_id]
                                        match(table.kind){
                                            case Kind.constant => global_code.gen(Fct.lit, l:0, a:table.val) //常量 直接读常量
                                            case Kind.variable => global_code.gen(Fct.lod, l:lev - table.level, a:table.adr); //变量，找到变量地址并将其值入栈
                                            case _ => throw CompileError() //TODO:细化这个CE
                                        }
                                    }
                                    else{
                                        throw CompileError() //TODO:细化这个CE
                                    }
        case Symbol.number(num) =>  global_code.gen(Fct.lit, l:0, a:num) //数字，直接读数字
        case Symbol.expr        =>  analyzeExpr(child)        // 下一个节点是Expr，继续执行Expr
        case Symbol.func_call   =>  analyzeFunCall(child)     // 下一个节点是函数，调用函数
        case _ => throw WrongSymbolException("Wrong Symbol Exception, Except one of factor child")
    }
}

func analyzeFunCall(ast:AST){

}