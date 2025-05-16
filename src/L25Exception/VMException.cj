package L25.L25Exception
//虚拟机运行时的报错
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