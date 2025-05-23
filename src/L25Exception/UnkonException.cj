/*
 * @Author: shiinarikka
 * @Date: 2025-05-15 23:58:56
 * @LastEditTime: 2025-05-23 13:57:58
 * @FilePath: /L25/src/L25Exception/UnkonException.cj
 * @Description: 一些Enum和C中的宏定义Int类型有相互对照关系，在转换过程中，如果有未定义的类型则会抛出Unknown异常。
 */
package L25.L25Exception

open public class Unkonw <: L25Exception{
    public init(){
        super("Unkonw");
    }
    public init(message: String) {
        super(message)
    }
    public open override func getClassName(): String {
        "Unkonw"
    }
}

public class UnkonwOpr <: Unkonw{
        public init(){
        super("UnkonwOpr");
    }
    public init(message: String) {
        super(message)
    }
    public override func getClassName(): String {
        "UnkonwOpr"
    }
}

public class UnkonwSymbol <: Unkonw{
    public init(){
        super("UnkonwSymbol");
    }
    public init(message: String) {
        super(message)
    }
    public override func getClassName(): String {
        "UnkonwSymbol"
    }
}


public class UnkonwOpt <: Unkonw{
        public init(){
        super("UnkonwOpt");
    }
    public init(message: String) {
        super(message)
    }
    public override func getClassName(): String {
        "UnkonwOpt"
    }
}