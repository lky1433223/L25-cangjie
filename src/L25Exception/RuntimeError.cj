/*
 * @Author: shiinarikka
 * @Date: 2025-05-23 14:04:00
 * @LastEditTime: 2025-05-24 18:27:00
 * @FilePath: /L25/src/L25Exception/RuntimeError.cj
 * @Description: 包含所有运行时错误
 */
package L25.L25Exception
public open class RuntimeError <: L25Exception {
    public init() {
        super("RuntimeError");
    }
    public init(message: String) {
        super(message)
       
    }
    public open override func getClassName(): String {
        "RuntimeError"
    }
}
public open class DivisionByZero <: L25Exception {
    public init() {
        super("DivisionByZero");
    }
    public init(message: String) {
        super(message)
       
    }
    public open override func getClassName(): String {
        "DivisionByZero"
    }
}
