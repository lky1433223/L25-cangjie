package L25.vm

import std.collection.*
//存储可执行的代码，并且包含代码生成文件
public class Code{
    var codes : ArrayList<Instruction>
    public init(){
        codes = ArrayList<Instruction>()
    }
    public func gen(f:Fct, l!:Int = 0, a!:Int = 0):Unit{
        codes.append(Instruction(f,_l:l,_a:a))
    }
    public func getCode(point:Int):Instruction{
        if(point>=codes.size){
            throw OutOfRange(point, codes.size)
        }
        return codes[point]
    }
}