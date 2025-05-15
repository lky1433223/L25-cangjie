package L25.table
public enum Object{
    constant | // 常量
	variable | // 变量
	function | // 函数
	program    // 程序名
	operator func  ==(right: Object){
		return toString(this) == toString(right)
	}
}

func toString(obj: Object): String {
    match(obj) {
        case Object.constant => return "constant"
        case Object.variable => return "variable"
        case Object.function => return "function"
        case Object.program  => return "program"
    }
}