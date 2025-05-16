package L25.L25Exception
//cangjie Enum/C type 未知报错
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