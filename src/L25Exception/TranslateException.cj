/*
 * @Author: shiinarikka
 * @Date: 2025-05-23 14:24:20
 * @LastEditTime: 2025-05-23 14:24:28
 * @FilePath: /L25/src/L25Exception/TranslateException.cj
 * @Description: CAST->AST翻译期的异常
 */
package L25.L25Exception

public open class TranslateException <: L25Exception {
    public init() {
        super("TranslateException");
    }
    public init(message: String) {
        super(message)
    }
    public open override func getClassName(): String {
        "TranslateException"
    }
}
