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