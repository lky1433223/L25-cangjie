//这里标记节点的symbol
package L25
import L25.L25Exception.UnkonwSymbol
enum Symbol{
    empty |
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
    number(Int64) |
    stmt |
    input_stmt |
    output_stmt |
    term |
    factor 

    operator func ==(right:Symbol){
        return toString(this) == toString(right)
    }
    operator func !=(right:Symbol){
        return toString(this) != toString(right)
    }
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
        case 15 => return Symbol.stmt
        case 16 => return Symbol.input_stmt
        case 17 => return Symbol.output_stmt
        case 18 => return Symbol.term
        case 19 => return Symbol.factor
        case _ => throw UnkonwSymbol("未知的节点类型: ${node_type}")
    }
}

func toString(symbol: Symbol): String {
    match (symbol) {
        case Symbol.program => return "program"
        case Symbol.fun_def => return "fun_def"
        case Symbol.param_list => return "param_list"
        case Symbol.stmt_list => return "stmt_list"
        case Symbol.declare_stmt => return "declare_stmt"
        case Symbol.assign_stmt => return "assign_stmt"
        case Symbol.if_stmt => return "if_stmt"
        case Symbol.while_stmt => return "while_stmt"
        case Symbol.func_call => return "func_call"
        case Symbol.expr => return "expr"
        case Symbol.string_list => return "string_list"
        case Symbol.bool_expr => return "bool_expr"
        case Symbol.fun_def_list => return "fun_def_list"
        case Symbol.ident(name) => return "ident ${name}"
        case Symbol.number(value) => return "number ${value}"
        case Symbol.stmt => return "stmt"
        case Symbol.empty => return "empty"
        case Symbol.input_stmt => return "input_stmt"
        case Symbol.output_stmt => return "output_stmt"
        case Symbol.term => return "term"
        case Symbol.factor => return "factor"
    }
}