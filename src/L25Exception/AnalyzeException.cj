/*
 * @Author: shiinarikka
 * @Date: 2025-05-16 00:12:32
 * @LastEditTime: 2025-05-23 14:15:00
 * @FilePath: /L25/src/L25Exception/AnalyzeException.cj
 * @Description: 定义所有在语义分析期的程序异常（不包含用户程序的Compile Error）
 */
package L25.L25Exception
open public class AnalyzeException <: L25Exception{
    public init(){
        super("AnalyzeException");
    }
    public init(message: String) {
        super(message)
    }
    public open override func getClassName(): String {
        "AnalyzeException"
    }
}

/**
 * @description: 语义分析中，一个函数获取到了和预期不同的AST节点类型，会抛出此异常。
 */
public class WrongSymbolException <: AnalyzeException{
    public init(){
        super("WrongSymbolException");
    }
    public init(message: String) {
        super(message)
    }
    public init(now:String, acc:String) {
        super("Wrong Symbol Exception, acc ${acc} but get ${now}")
    }
    public override func getClassName(): String {
        "WrongSymbolException"
    }
}