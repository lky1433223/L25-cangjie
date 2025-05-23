/*
 * @Author: shiinarikka
 * @Date: 2025-05-16 00:00:04
 * @LastEditTime: 2025-05-23 13:58:29
 * @FilePath: /L25/src/L25Exception/L25Exception.cj
 * @Description: L25分析中所有异常的基类
 */
package L25.L25Exception

public open class L25Exception <: Exception {
    public init() {
        super("L25Exception");
    }
    public init(message: String) {
        super(message)
    }
    public open override func getClassName(): String {
        "L25Exception"
    }
}
