package L25

@C
struct CASTNode{
    var node_type: Int32 = 0
    var data : CPointer<Unit> = CPointer<Unit>()
    var children: VArray<CPointer<CASTNode>, $5> = VArray<CPointer<CASTNode>, $5>(item: CPointer<CASTNode>())
    var child_count: Int32 = 0
}

@C
struct CIdentData {
    var name: VArray<UInt8, $200> = VArray<UInt8, $200>(item:0)
}

@C
struct CNumData {
    var num: Int32 = 0
}

foreign func getAST() : CPointer<CASTNode>
foreign func create_node(node_type:Int32) :  CPointer<CASTNode>
foreign func free_AST(root: CPointer<CASTNode>):Unit

