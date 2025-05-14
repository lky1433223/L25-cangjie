package L25


public interface AST{

}

public class Program <: AST{
    
}

public class Ident <: AST{
    var name:String
    init() {
        name = String()
    }
}

public class Number <: AST{

}