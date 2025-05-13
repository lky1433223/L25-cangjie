package L25
import std.io.*




main(): Int64 {
    let a = Symbol.ident("id")
    match(a){
        case Symbol.ident(String) => println(String)
        case _ => print("none")
    }
    let proot:CPointer<CASTNode> = unsafe{getAst()}
    let root:CASTNode =  unsafe{proot.read()}
    println(root.child_count)
    for(child_id in 0..root.child_count)
    {
        print(child_id)
        print(" ")
        let child = unsafe{root.children[Int64(child_id)].read()}
        println(child.node_type)
    }


    return 0
}