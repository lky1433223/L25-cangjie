package L25
import std.collection.*

open public class AST{
    var children: ArrayList<AST>
    var symbol: Symbol
    init() {
        children = ArrayList<AST>()
        symbol = Symbol.empty
    }
    public func insertChild(child:AST){
        children.append(child)
    }

}

public class Program <: AST{
    init(){
        symbol = Symbol.program
    }
}

public class Ident <: AST{
    var name:String
    init() {
        name = String()
        symbol = Symbol.ident(name)
    }
    init(_name:String){
        name = _name
        symbol = Symbol.ident(name)
    }
    func setName(_name:String)
    {
        name = _name;
        symbol = Symbol.ident(name)
    }
}

public class Number <: AST{

}