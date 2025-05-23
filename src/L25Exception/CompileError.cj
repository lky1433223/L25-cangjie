/*
 * @Author: shiinarikka
 * @Date: 2025-05-23 14:03:13
 * @LastEditTime: 2025-05-23 14:12:36
 * @FilePath: /L25/src/L25Exception/CompileError.cj
 * @Description: 包含所有编译报错
 */
package L25.L25Exception
open public class CompileError <: L25Exception{
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

/**
 * @description: 未定义Error。
 */
open public class UnDeclaredIdent<: CompileError{
    public init(){
        super("UnDeclaredIdent");
    }
    public init(message: String) {
        super(message)
    }
    public init(kind:String, name:String) {
        super("UnDeclared Ident, ${kind}:${name}")
    }
    public open override func getClassName(): String {
        "UnDeclaredIdent"
    }
}