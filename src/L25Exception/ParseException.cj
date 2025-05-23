/*
 * @Author: shiinarikka
 * @Date: 2025-05-13 23:42:46
 * @LastEditTime: 2025-05-23 14:05:06
 * @FilePath: /L25/src/L25Exception/ParseException.cj
 * @Description: Parse过程异常，通常是在Bison语法分析过程中出错，不包含Compile Error
 */
package L25.L25Exception
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




