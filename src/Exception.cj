package L25
open class ParseException <: Exception{
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

class UnkonwSymbol <: Exception{
    public init(){
        super("UnkonwSymbol");
    }
    public init(message: String) {
        super(message)
    }
    public open override func getClassName(): String {
        "UnkonwSymbol"
    }
}