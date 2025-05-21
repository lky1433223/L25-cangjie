package L25.table
public enum Kind{
    constant | // 常量
	variable | // 变量
	function | // 函数
	program    // 程序名
	operator func  ==(right: Kind){
		return toString(this) == toString(right)
	}
}

public func toString(obj: Kind): String {
    match(obj) {
        case Kind.constant => return "constant"
        case Kind.variable => return "variable"
        case Kind.function => return "function"
        case Kind.program  => return "program"
    }
}