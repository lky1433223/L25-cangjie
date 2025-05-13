//这里主要负责实现C类型Ast到Cangjie类型Ast的转译，这个中间层可以保证后续操作的安全
package L25
foreign func yyparse():Unit
func translateAST(): AST
{
    unsafe{yyparse()}
    let CASTproot:CPointer<CASTNode> = unsafe{getAST()} //获取C语言语法树指针
    let ASTroot:AST = Program() //创建cangjie语法树指针
    if(CASTproot.isNull()) //判断指针是否为空。这里如果访问RE会导致程序无法结束。
    {
        throw ParseException("无法获取语法树根节点。请检查语法错误。")
    }
    let root:CASTNode =  unsafe{CASTproot.read()} //解析指针，解析到CASTNode类型
    //TODO:递归解析
    println(root.node_type)
    println(root.child_count)
    for(child_id in 0..root.child_count)
    {
        print(child_id)
        print(" ")
        let child = unsafe{root.children[Int64(child_id)].read()}
        println(child.node_type)
        if(child.node_type == 10)
        {
            println("is nameData")
            let data_unit_point = child.data
            let data_point = CPointer<CIdentData>(data_unit_point)
            println(data_point.isNull())
            let data = unsafe{data_point.read()}
            for (ch in 0..data.name.size)
            {
                if(data.name[ch] == 0)
                {
                    break
                }
                print(Rune(data.name[ch]))
            }
            println()

            // println(cstr)
        }
    }
    unsafe{free_AST(CASTproot)}
    return ASTroot
}