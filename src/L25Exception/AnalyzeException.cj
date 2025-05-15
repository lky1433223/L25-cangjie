package L25.L25Exception
open public class AnalyzeException <: L25Exception{
    public init(){
        super("AnalyzeException");
    }
    public init(message: String) {
        super(message)
    }
    public open override func getClassName(): String {
        "AnalyzeException"
    }
}

public class WrongSymbolException <: AnalyzeException{
    public init(){
        super("WrongSymbolException");
    }
    public init(message: String) {
        super(message)
    }
    public init(now:String, acc:String) {
        super("Wrong Symbol Exception, acc ${acc} but get ${now}")
    }
    public override func getClassName(): String {
        "WrongSymbolException"
    }
}