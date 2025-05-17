//这里主要负责实现C类型Ast到Cangjie类型Ast的转译，这个中间层可以保证后续操作的安全
package L25
import L25.L25Exception.*
import std.collection.*

func buildProgram(_:CASTNode):Program
{
    var res = Program()
    println("build Program")
    return res
}
func buildIdent(croot:CASTNode):Ident
{
    var res = Ident() //定义Ident类型
    let cpdata: CPointer<CIdentData> = unsafe{CPointer<CIdentData>(croot.data)} //C data指针
    if(cpdata.isNull()){throw Exception("empty point")}
    let cdata = unsafe{cpdata.read()} //解析指针
    let name_len = cdata.name_len     //name长度
    //从Varray翻译
    let tmp_strarray =  ArrayList<Rune>()  
    for(i in 0..cdata.name.size where i < Int64(name_len))
    {
        tmp_strarray.append(Rune(cdata.name[i]))
    }   
    res.setName(String(tmp_strarray))
    println("build Ident " + res.name)
    return res
}
func buildNumber(croot:CASTNode):Number
{
    let cpdata: CPointer<CNumData> = unsafe{CPointer<CNumData>(croot.data)} //C data指针
    if(cpdata.isNull()){throw Exception("empty point")}
    let cdata = unsafe{cpdata.read()} //解析指针
    var res = Number(Int64(cdata.num)) //定义Ident类型
    println("build Number ${res.num}" )
    return res
}



func buildStmtList(_:CASTNode):StmtList
{
    var res = StmtList()
    println("build StmtList")
    return res
}

func buildStmt(_:CASTNode):Stmt
{
    var res = Stmt()
    println("build Stmt")
    return res
}

func buildDeclareStmt(_:CASTNode):DeclareStmt
{
    var res = DeclareStmt()
    println("build DeclareStmt")
    return res
}

func buildAssignStmt(_:CASTNode):AssignStmt
{
    var res = AssignStmt()
    println("build AssignStmt")
    return res
}

func buildOutputStmt(_:CASTNode):OutputStmt
{
    var res = OutputStmt()
    println("build OutputStmt")
    return res
}

func buildInputStmt(_:CASTNode):InputStmt
{
    var res = InputStmt()
    println("build InputStmt")
    return res
}

func buildExpr(croot:CASTNode):Expr
{
    println("build buildExpr")
    let cpdata: CPointer<CexprData> = unsafe{CPointer<CexprData>(croot.data)} //C data指针
    if(cpdata.isNull()){throw Exception("empty point")}
    let cdata = unsafe{cpdata.read()} //解析指针
    let op = cdata.op
    var res = Expr(getOpt(op))
    return res
}

func buildTerm(croot:CASTNode):Term
{
    println("build buildTerm")
    let cpdata: CPointer<CtermData> = unsafe{CPointer<CtermData>(croot.data)} //C data指针
    if(cpdata.isNull()){throw Exception("empty point")}
    let cdata = unsafe{cpdata.read()} //解析指针
    let op = cdata.op
    var res = Term()
    if(op != 0){res = Term(getOpt(op))}
    return res
}

func buildFactor(_:CASTNode):Factor
{
    println("build buildFactor")
    var res = Factor()
    return res
}


func buildArgList(_:CASTNode):ArgList
{
    var res = ArgList()
    println("build ArgList")
    return res
}

func builParamList(_:CASTNode):ParamList
{
    var res = ParamList()
    println("build ParamList")
    return res
}

func dfsCAST(cproot:CPointer<CASTNode>):AST
{
    //判断C语言指针是否为空
    if(cproot.isNull()){throw Exception("empty point")}
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
        case _ => throw UnkonwSymbol("未知的节点类型, ${croot.node_type}")
    }
    //处理儿子节点
    let child_count = croot.child_count
    for(child_id in 0..child_count)
    {
        let cpchild = croot.children[Int64(child_id)]
        if(cpchild.isNull()) {continue}
        let child = dfsCAST(cpchild)
        root.insertChild(child)
    }
    return root
}

func printAST(root:AST, deep!:Int = 0):Unit
{
    for(_ in 1..=deep){
        print(" ")
    }
    println(toString(root.symbol))
    for(child in root.children)
    {
        printAST(child, deep:deep + 1)
    }
}

func translateAST(): AST
{
    
    let CASTproot:CPointer<CASTNode> = unsafe{getAST()} //获取C语言语法树指针
    
    if(CASTproot.isNull()) //判断指针是否为空。这里如果访问RE会导致程序无法结束。
    {
        throw ParseException("无法获取语法树根节点。请检查错误。")
    }
    let ASTroot:AST = dfsCAST(CASTproot) //递归解析CAST，创建cangjie类型AST

    printAST(ASTroot)

    unsafe{free_AST(CASTproot)} //释放树，防止内存泄漏
    return ASTroot
}