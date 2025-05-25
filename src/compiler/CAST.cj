//CAST 对应 C语言的AST node
package L25.compiler

let MAX_IDNET_LEN = 100

@C
struct ListNode {
    var data: CPointer<CASTNode> = CPointer<CASTNode>()
    var next: CPointer<ListNode> = CPointer<ListNode>()
}

@C
struct CASTNode {
    var node_type: Int32 = 0
    var data: CPointer<Unit> = CPointer<Unit>()
    var children: CPointer<ListNode> = CPointer<ListNode>()
    var child_count: Int32 = 0
    var first_line: Int32 = 0
    var first_colume: Int32 = 0
    var last_line: Int32 = 0
    var last_colume: Int32 = 0
}

@C
struct CIdentData {
    var name: VArray<UInt8, $100> = VArray<UInt8, $100>(item: 0)
    var name_len: Int32 = 0
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

@C
struct CboolExprData {
    var op: Int32 = 0
}

foreign func getAST(): CPointer<CASTNode>

foreign func free_AST(root: CPointer<CASTNode>): Unit
