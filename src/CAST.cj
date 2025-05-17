//CAST 对应 C语言的AST node
package L25
let MAX_IDNET_LEN = 100
let CHILDREN_CAP  = 100
@C
struct CASTNode{
    var node_type: Int32 = 0
    var data : CPointer<Unit> = CPointer<Unit>()
    var children: VArray<CPointer<CASTNode>, $100> = VArray<CPointer<CASTNode>, $100>(item: CPointer<CASTNode>())
    var child_count: Int32 = 0
}

@C
struct CIdentData {
    var name: VArray<UInt8, $100> = VArray<UInt8, $100>(item:0)
    var name_len : Int32 = 0
}

@C
struct CNumData {
    var num: Int32 = 0
}

@C
struct CexprData {
    var op: Int32 = 0
}

@C
struct CtermData {
    var op: Int32 = 0
}

foreign func getAST() : CPointer<CASTNode>
foreign func free_AST(root: CPointer<CASTNode>):Unit

