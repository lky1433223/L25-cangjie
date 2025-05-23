//这里主要负责实现C类型Ast到Cangjie类型Ast的转译，这个中间层可以保证后续操作的安全
package L25
import L25.L25Exception.*
import std.collection.*
var global_deep = 0

@When[debug]
func printBuildStatus(node:AST){
    for(_ in 1..global_deep){
        print(" ")
    }
    println("${toString(node.symbol)} ${node.first_line}:${node.first_colume}-${node.last_line}:${node.last_colume}")
}
@When[!debug]
func printBuildStatus(_:AST){
    //Do nothing
}


func buildProgram(_:CASTNode):Program
{
    var res = Program()
    return res
}

func buildFuncDefList(_:CASTNode):FuncDefList{
    var res = FuncDefList()
    return res
}

func buildFuncDef(_:CASTNode):FuncDef{
    var res = FuncDef()
     
    return res
}

func buildIdent(croot:CASTNode):Ident
{
    var res = Ident() //定义Ident类型
    let cpdata: CPointer<CIdentData> = unsafe{CPointer<CIdentData>(croot.data)} //C data指针
    if(cpdata.isNull()){throw TranslateException("empty point")}
    let cdata = unsafe{cpdata.read()} //解析指针
    let name_len = cdata.name_len     //name长度
    //从Varray翻译
    let tmp_strarray =  ArrayList<Rune>()  
    for(i in 0..cdata.name.size where i < Int64(name_len))
    {
        tmp_strarray.append(Rune(cdata.name[i]))
    }   
    res.setName(String(tmp_strarray))
     
    return res
}

func buildNumber(croot:CASTNode):Number
{
    let cpdata: CPointer<CNumData> = unsafe{CPointer<CNumData>(croot.data)} //C data指针
    if(cpdata.isNull()){throw TranslateException("empty point")}
    let cdata = unsafe{cpdata.read()} //解析指针
    var res = Number(Int64(cdata.num)) //定义Ident类型
     
    return res
}

func buildStmtList(_:CASTNode):StmtList
{
    var res = StmtList()
     
    return res
}

func buildStmt(_:CASTNode):Stmt
{
    var res = Stmt()
     
    return res
}

func buildDeclareStmt(_:CASTNode):DeclareStmt
{
    var res = DeclareStmt()
     
    return res
}

func buildAssignStmt(_:CASTNode):AssignStmt
{
    var res = AssignStmt()
     
    return res
}

func buildOutputStmt(_:CASTNode):OutputStmt
{
    var res = OutputStmt()
     
    return res
}

func buildIfStmt(_:CASTNode):IfStmt
{
    var res = IfStmt()
     
    return res
}

func buildWhileStmt(_:CASTNode):WhileStmt
{
    var res = WhileStmt()
     
    return res
}

func buildInputStmt(_:CASTNode):InputStmt
{
    var res = InputStmt()
     
    return res
}

func buildExpr(croot:CASTNode):Expr
{
    let cpdata: CPointer<CexprData> = unsafe{CPointer<CexprData>(croot.data)} //C data指针
    if(cpdata.isNull()){throw TranslateException("empty point")}
    let cdata = unsafe{cpdata.read()} //解析指针
    let op = cdata.op
    var res = Expr(getOpt(op))
     
    return res
}

func buildTerm(croot:CASTNode):Term
{
    let cpdata: CPointer<CtermData> = unsafe{CPointer<CtermData>(croot.data)} //C data指针
    if(cpdata.isNull()){throw TranslateException("empty point")}
    let cdata = unsafe{cpdata.read()} //解析指针
    let op = cdata.op
    var res = Term()
    if(op != 0){res = Term(getOpt(op))}
     
    return res
}

func buildBoolExpr(croot:CASTNode):BoolExpr{
    let cpdata: CPointer<CboolExprData> = unsafe{CPointer<CboolExprData>(croot.data)} //C data指针
    if(cpdata.isNull()){throw TranslateException("empty point")}
    let cdata = unsafe{cpdata.read()} //解析指针
    let op = cdata.op
    var res = BoolExpr(getOpt(op))
     
    return res
}

func buildFactor(_:CASTNode):Factor
{
    var res = Factor()
     
    return res
}

func buildFuncCall(_:CASTNode):FuncCall
{
    var res = FuncCall()
     
    return res
}

func buildArgList(_:CASTNode):ArgList
{
    var res = ArgList()
     
    return res
}

func builParamList(_:CASTNode):ParamList
{
    var res = ParamList()
     
    return res
}

func dfsCAST(cproot:CPointer<CASTNode>):AST
{
    global_deep++
    //判断C语言指针是否为空
    if(cproot.isNull()){throw TranslateException("empty point")}
    //解析地址到struct
    let croot = unsafe{cproot.read()}
    //处理data字段
    let node_symbol = getSymbol(croot.node_type)
    // println(croot.node_type)
    var root : AST
    match (node_symbol){
        case Symbol.program => root = buildProgram(croot)
        case Symbol.ident(_) => root = buildIdent(croot)
        case Symbol.stmt_list => root = buildStmtList(croot)
        case Symbol.stmt => root = buildStmt(croot)
        case Symbol.declare_stmt => root = buildDeclareStmt(croot)
        case Symbol.assign_stmt => root = buildAssignStmt(croot)
        case Symbol.expr => root = buildExpr(croot)
        case Symbol.term => root = buildTerm(croot)
        case Symbol.factor => root = buildFactor(croot)
        case Symbol.number(_) => root = buildNumber(croot)
        case Symbol.input_stmt => root = buildInputStmt(croot)
        case Symbol.output_stmt => root = buildOutputStmt(croot)
        case Symbol.arg_list => root = buildArgList(croot)
        case Symbol.param_list => root = builParamList(croot)
        case Symbol.bool_expr => root = buildBoolExpr(croot)
        case Symbol.if_stmt => root = buildIfStmt(croot)
        case Symbol.while_stmt => root = buildWhileStmt(croot)
        case Symbol.fun_def_list => root = buildFuncDefList(croot)
        case Symbol.fun_def => root = buildFuncDef(croot)
        case Symbol.func_call => root = buildFuncCall(croot)
        case _ => throw UnkonwSymbol("未知的节点类型, ${croot.node_type}")
    }
    //拷贝line colume
    root.setLC(croot.first_line, croot.first_colume, croot.last_line, croot.last_colume)
    printBuildStatus(root)
    //遍历链表，处理儿子节点
    let child_count = croot.child_count
    var current = unsafe{croot.children.read().next}
    for(_ in 0..child_count)
    {
        let cpchild = unsafe{current.read().data}
        if(cpchild.isNull()) {continue}
        let child = dfsCAST(cpchild)
        root.insertChild(child)
        current = unsafe{current.read().next}
    }
    global_deep--
    return root
}

func printAST(node:AST, prefix: String, isTail:Bool):Unit
{
    print(prefix)
    if(isTail){
        print("\u{001B}[90m└── \u{001B}[0m")
    }
    else{
        print("\u{001B}[90m├── \u{001B}[0m")
    }
    println(toColorString(node.symbol))
    var children = node.children
    for(i in 0..children.size)
    {
        var isLast = (i == children.size-1)
        var newPrefix = prefix.clone()
        if(isTail){
            newPrefix = newPrefix + "    "
        }
        else{
            newPrefix = newPrefix + "\u{001B}[90m│   \u{001B}[0m" 
        }
        printAST(children[i], newPrefix, isLast)
    }
}

func printASTRoot(root:AST){
    println(toColorString(root.symbol))
    for (i in 0..root.children.size) {
        printAST(root.children[i], "", i == root.children.size-1)
    }
}

func translateAST(): AST
{
    
    let CASTproot:CPointer<CASTNode> = unsafe{getAST()} //获取C语言语法树指针
    
    if(CASTproot.isNull()) //判断指针是否为空。这里如果访问RE会导致程序无法结束。
    {
        throw ParseException("无法获取语法树根节点。请检查错误。")
    }
    println("遍历 CAST 翻译中...")
    let ASTroot:AST = dfsCAST(CASTproot) //递归解析CAST，创建cangjie类型AST
    println("CAST -> AST 翻译完成")
    println("AST如下:")

    printASTRoot(ASTroot)

    unsafe{free_AST(CASTproot)} //释放树，防止内存泄漏
    return ASTroot
}