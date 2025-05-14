//这里主要负责实现C类型Ast到Cangjie类型Ast的转译，这个中间层可以保证后续操作的安全
package L25
import std.collection.*
foreign func yyparse():Unit

func buildProgram(croot:CASTNode):Program
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
    let name_len = cdata.name_len          //name长度
    //从Varray翻译
    let tmp_strarray =  ArrayList<Rune>()  
    for(i in 0..cdata.name.size where i < Int64(name_len))
    {
        tmp_strarray.append(Rune(cdata.name[i]))
    }   
    res.name = String(tmp_strarray)
    println("buildIdent" + res.name)
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
    var root : AST
    match (node_symbol){
        case Symbol.program => root = buildProgram(croot)
        case Symbol.ident(String) => root = buildIdent(croot)
        case _ => throw UnkonwSymbol("未知的节点类型")
    }
    //处理儿子节点
    let child_count = croot.child_count
    for(child_id in 0..child_count)
    {
        let cpchild = croot.children[Int64(child_id)]
        if(cpchild.isNull()) {continue}
        let child = dfsCAST(cpchild)
    }
    return root
    

}
func translateAST(): AST
{
    unsafe{yyparse()}
    let CASTproot:CPointer<CASTNode> = unsafe{getAST()} //获取C语言语法树指针
    
    if(CASTproot.isNull()) //判断指针是否为空。这里如果访问RE会导致程序无法结束。
    {
        throw ParseException("无法获取语法树根节点。请检查语法错误。")
    }
    let ASTroot:AST = dfsCAST(CASTproot) //递归解析CAST，创建cangjie类型AST
    unsafe{free_AST(CASTproot)}
    return ASTroot
}