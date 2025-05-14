package L25
enum Symbol{
    program | 
    fun_def | 
    fun_def_list | 
    param_list | 
    stmt_list | 
    declare_stmt | 
    assign_stmt | 
    if_stmt | 
    while_stmt | 
    func_call | 
    expr |
    string_list | 
    bool_expr |
    ident(String) |
    number(Int64) 
}

func getSymbol(node_type: Int32): Symbol {
    match (node_type) {
        case 0 => return Symbol.program
        case 1 => return Symbol.fun_def
        case 2 => return Symbol.param_list
        case 3 => return Symbol.stmt_list
        case 4 => return Symbol.declare_stmt
        case 5 => return Symbol.assign_stmt
        case 6 => return Symbol.if_stmt
        case 7 => return Symbol.while_stmt
        case 8 => return Symbol.func_call
        case 9 => return Symbol.expr
        case 10 => return Symbol.ident("")  // NODE_IDENT，需动态传入标识符名称
        case 11 => return Symbol.number(0)   // NODE_NUMBER，需动态传入数值
        case 12 => return Symbol.string_list // NODE_STRING_LIST
        case 13 => return Symbol.bool_expr
        case 14 => return Symbol.fun_def_list
        case _ => throw UnkonwSymbol("未知的节点类型: ${node_type}")
    }
}