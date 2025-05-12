package L25
import std.io.*


foreign func getAst() : CPointer<CAstNode>

main(): Int64 {
    let a = Symbol.ident("id")
    match(a){
        case Symbol.ident(String) => println(String)
        case _ => print("none")
    }

    let sizeofPoint3D: UIntNative = 24

    return 0
}