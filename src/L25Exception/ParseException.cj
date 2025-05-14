package L25.L25Exception
open public class ParseException <: Exception{
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

open public class Unkonw <: Exception{
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