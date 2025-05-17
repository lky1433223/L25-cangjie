//仓颉的AST类型
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

public class StmtList <: AST{
    init(){
        symbol = Symbol.stmt_list
    }
}


public class Stmt <: AST{
    init(){
        symbol = Symbol.stmt
    }
}

public class DeclareStmt <: AST{
    init(){
        symbol = Symbol.declare_stmt
    }
}

public class AssignStmt <: AST{
    init(){
        symbol = Symbol.assign_stmt
    }
}

public class OutputStmt <: AST{
    init(){
        symbol = Symbol.output_stmt
    }
}

public class InputStmt <: AST{
    init(){
        symbol = Symbol.input_stmt
    }
}

public class IfStmt <: AST{
    init(){
        symbol = Symbol.if_stmt
    }
}

public class Expr <: AST{
    public var opt:Opt
    init(){
        symbol = Symbol.expr
        opt = Opt.add
    }
    init(opt:Opt){
        symbol = Symbol.expr
        this.opt = opt
    }
}

public class Term <: AST{
    var opt:?Opt //Term节点可能只有一个数，这时就是None
    init(){
        symbol = Symbol.term
        opt = None
    }
    init(opt:Opt){
        symbol = Symbol.term
        this.opt = opt
    }
}

public class BoolExpr <: AST{
    public var opt:Opt
    init(){
        symbol = Symbol.bool_expr
        opt = Opt.eq
    }
    init(opt:Opt){
        symbol = Symbol.bool_expr
        this.opt = opt
    }
}

public class Factor <: AST{
    init(){
        symbol = Symbol.factor
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
    var num:Int
    init(){
        num = 0
        symbol = Symbol.number(num)
    }
    init(num:Int){
        this.num = num
        symbol = Symbol.number(num)
    }
    func setNum(num:Int){
        this.num = num
        symbol = Symbol.number(num)
    }
}


public class ArgList <: AST{
    init(){
        symbol = Symbol.arg_list
    }
}

public class ParamList <: AST{
    init(){
        symbol = Symbol.param_list
    }
}