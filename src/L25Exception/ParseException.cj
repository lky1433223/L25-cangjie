package L25.L25Exception
//Parse过程报错 基类包含了程序可能的报错和编译报错
open public class ParseException <: L25Exception{
    public init(){
        super("ParseException");
    }
    public init(message: String) {
        super(message)
    }
    public open override func getClassName(): String {
        "ParseException"
    }
}


open public class CompileError <: ParseException{
    public init(){
        super("CompileError");
    }
    public init(message: String) {
        super(message)
    }
    public open override func getClassName(): String {
        "CompileError"
    }
}

open public class UndefinedSymbol<: CompileError{
    public init(){
        super("UndefinedSymbol");
    }
    public init(message: String) {
        super(message)
    }
    public init(kind:String, name:String) {
        super("Undefined Symbol, ${kind}:${name}")
    }
    public open override func getClassName(): String {
        "UndefinedSymbol"
    }
}