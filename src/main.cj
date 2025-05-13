package L25
import std.io.*



foreign func yyparse():Unit


main(): Int64 {
    let a = Symbol.ident("id")
    match(a){
        case Symbol.ident(String) => println(String)
        case _ => print("none")
    }

    unsafe{yyparse()}

    let proot:CPointer<CASTNode> = unsafe{getAST()}
    let root:CASTNode =  unsafe{proot.read()}
    println(root.node_type)
    // for(child_id in 0..root.child_count)
    // {
    //     print(child_id)
    //     print(" ")
    //     let child = unsafe{root.children[Int64(child_id)].read()}
    //     println(child.node_type)
    // }


    return 0
}