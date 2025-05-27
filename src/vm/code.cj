package L25.vm
import std.collection.*
import L25.L25Exception.OutOfRange
import L25.utils.Color


/* 虚拟机代码结构 */
public class Instruction{
    let f: Fct
    let l: Int
    public var a: Int
    init(_f:Fct, _l!:Int=0, _a!:Int=0) {
        f = _f
        l = _l
        a = _a
    }
}
//存储可执行的代码，并且包含代码生成文件
public class Code{
    public var codes : ArrayList<Instruction>
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
    public func clear(){
        codes.clear()
    }
    //返回当前最新的code的id
    public func Position():Int{
        return codes.size - 1
    }
    public func print(with_line!:Bool = false, translate_opr!:Bool = false){
        var line = 0
        println("Pcode:")
        for(code in codes){
            
            if(with_line){
                print("${Color.ANSI_BLUE}${line.toString().padLeft(3)}${Color.ANSI_RESET}${Color.ANSI_GRAY}|${Color.ANSI_RESET} ")
            }
            print("${Color.ANSI_RESET}${toString(code.f)}${Color.ANSI_RESET} ")
            print("${Color.ANSI_RESET}${code.l.toString()}${Color.ANSI_RESET} ")
            if(translate_opr && (code.f == Fct.opr)){
                print((getOpr ~> toString)(code.a))
            }
            else{
                print(code.a)
            }
            println()
            line++
        }
    }
}