package L25.vm
import std.console.*
import std.convert.*
let stacksize = 1024
public func interpret(code : Code){
    var p = 0; /* 指令指针 */
	var b = 1; /* 指令基址 */
	var t = 0; /* 栈顶指针 */
    var i = Instruction(Fct.jmp, _l:0, _a:0)/* 存放当前指令 */
    var s = Array<Int>(stacksize,item:0) /* 栈 */
    println("start L25")
    s[0] = 0
    s[1] = 0
    s[2] = 0
    s[3] = 0
    do{
        println("pointer:${p}")
        i = code.getCode(p)
        p += 1
        match(i.f){
            case Fct.lit => t = t + 1
                            s[t] = i.a
            case Fct.opr => let opr = getOpr(i.a)
                            match(opr){
                                case Opr.ret => t = b - 1
                                                p = s[t+3]
                                                b = s[t+2]
                                case Opr.add => t = t - 1
                                                s[t] = s[t] + s[t + 1]
                                
                                case Opr.prt => print(s[t])
                                case Opr.prtln => println()
                                case Opr.inp => let str: String = Console.stdIn.readln().getOrThrow()
                                                let num = Int64.parse(str)
                                                t = t + 1
                                                s[t] = num
                                                
                                case _ => return
                            }


            case _ => return
        }
    }while(p!=0)

}