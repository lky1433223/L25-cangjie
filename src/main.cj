package L25
import std.io.*

foreign func buildPoint(): Point3D

main(): Int64 {
    let a = Symbol.ident("id")
    // let b = Symbol.ident("id")
    match(a){
        // case Symbol.nul => print(1)
        case Symbol.ident(String) => println(String)
        case _ => print("none")
    }
    var b:Point3D = unsafe{buildPoint()}
    println(b.x)
    return 0
}