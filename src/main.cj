package L25
import std.io.*


foreign func malloc(size: UIntNative): CPointer<Unit>
foreign func free(ptr: CPointer<Unit>): Unit
foreign func buildPoint(): CPointer<Point3D>

main(): Int64 {
    let a = Symbol.ident("id")
    match(a){
        case Symbol.ident(String) => println(String)
        case _ => print("none")
    }

    let sizeofPoint3D: UIntNative = 24
    var pb = unsafe{buildPoint()}

    unsafe{free}
    return 0
}