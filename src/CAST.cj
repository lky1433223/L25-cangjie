package L25

@C
struct CASTNode{
    var node_type: Int32 = 0
    var data : CPointer<CASTNode> = CPointer<CASTNode>()
    var children: VArray<CPointer<CASTNode>, $5> = VArray<CPointer<CASTNode>, $5>(item: CPointer<CASTNode>())
    var child_count: Int32 = 0
}

foreign func getAst() : CPointer<CASTNode>
foreign func create_node(node_type:Int32) :  CPointer<CASTNode>
