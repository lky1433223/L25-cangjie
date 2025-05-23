/*
 * @Author: shiinarikka
 * @Date: 2025-05-23 14:03:13
 * @LastEditTime: 2025-05-23 23:06:57
 * @FilePath: /L25/src/L25Exception/CompileError.cj
 * @Description: 包含所有编译报错
 */
package L25.L25Exception
public open class CompileError <: L25Exception {
    public let first_line:Int
    public let first_colume:Int
    public let last_line:Int
    public let last_colume:Int
    public init() {
        super("CompileError");
        first_line  = 0
        first_colume = 0
        last_line = 0
        last_colume = 0
    }
    public init(message: String) {
        super(message)
        first_line  = 0
        first_colume = 0
        last_line = 0
        last_colume = 0
    }
    public init(message: String, first_line:Int, first_colume:Int, last_line:Int, last_colume:Int) {
        super(message)
        this.first_line  = first_line
        this.first_colume = first_colume
        this.last_line = last_line
        this.last_colume = last_colume
    }
    public open override func getClassName(): String {
        "CompileError"
    }
}

/**
 * @description: 未定义Error。
 */
public open class UnDeclaredIdent <: CompileError {
    public init() {
        super("UnDeclaredIdent");
    }
    public init(message: String) {
        super(message)
    }
    public init(kind: String, name: String) {
        super("UnDeclared Ident, ${kind}:${name}")
    }
    public init(kind: String, name: String, first_line:Int, first_colume:Int, last_line:Int, last_colume:Int) {
        super("UnDeclared Ident, ${kind}:${name}", first_line, first_colume, last_line, last_colume)
    }
    public open override func getClassName(): String {
        "UnDeclaredIdent"
    }
}


/**
 * @description: 未定义Error。
 */
public open class Redefination <: CompileError {
    public init() {
        super("Redefination");
    }
    public init(message: String) {
        super(message)
    }
    public init(kind: String, name: String) {
        super("Redefination Ident, ${kind}: ${name}")
    }
    public init(kind: String, name: String, first_line:Int, first_colume:Int, last_line:Int, last_colume:Int) {
        super("Redefination Ident, ${kind}: ${name}", first_line, first_colume, last_line, last_colume)
    }
    public open override func getClassName(): String {
        "Redefination"
    }
}
