package L25.L25Exception
//L25分析中所有异常的基类
open public class L25Exception <: Exception{
    public init(){
        super("L25Exception");
    }
    public init(message: String) {
        super(message)
    }
    public open override func getClassName(): String {
        "L25Exception"
    }
}