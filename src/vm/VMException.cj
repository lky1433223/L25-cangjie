package L25.vm
open class OutOfRange <: Exception{
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

