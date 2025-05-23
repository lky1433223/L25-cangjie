/*
 * @Author: shiinarikka
 * @Date: 2025-05-14 23:06:53
 * @LastEditTime: 2025-05-23 14:00:43
 * @FilePath: /L25/src/L25Exception/VMException.cj
 * @Description: 虚拟机运行异常，通常处理由于虚拟机实现/生成的代码有误而导致的异常，不包含用户的Runtime Error
 */
package L25.L25Exception
//虚拟机运行中越界
open public class OutOfRange <: L25Exception{
    public init(){
        super("OutOfRange");
    }
    public init(message: String) {
        super(message)
    }
    public init(acc:Int, max:Int) {
        super("OutOfRange,acc ${acc} but with max ${max}")
    }
    public open override func getClassName(): String {
        "OutOfRange"
    }
}

//取指令越界
open public class CodeOutOfRange <: L25Exception{
    public init(){
        super("CodeOutOfRange");
    }
    public init(message: String) {
        super(message)
    }
    public init(acc:Int, max:Int) {
        super("Code Out Of Range, acc code ${acc} but with total ${max}")
    }
    public open override func getClassName(): String {
        "CodeOutOfRange"
    }
}