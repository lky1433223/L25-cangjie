package L25
import std.io.*




main(): Int64 {
    let a = Symbol.ident("id")
    match(a){
        case Symbol.ident(String) => println(String)
        case _ => print("none")
    }
    let proot:CPointer<CASTNode> = unsafe{create_node(20)}
    let root:CASTNode =  unsafe{proot.read()}
    println(root.node_type)
    println(root.child_count)


    return 0
}