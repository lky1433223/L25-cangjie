package L25.vm
import std.console.*
import std.convert.*
import std.collection.*

let stacksize = 1024
public func interpret(code : Code){
    var p = 0; /* 指令指针 */
	var b = 1; /* 指令基址 */
	var t = 0; /* 栈顶指针 */
    var i = Instruction(Fct.jmp, _l:0, _a:0)/* 存放当前指令 */
    var s = Array<Int>(stacksize,item:0) /* 栈 */
    var res = ArrayList<Int>()
    /* 通过过程基址求上l层过程的基址 */
    func base(l:Int, b:Int):Int{
        var b1:Int = b
        var l1:Int = l
        while(l1 > 0){
            b1 = s[b1];
            l1--;
        }
        return b1;
    }
    println("start L25")
    s[0] = 0
    s[1] = 0
    s[2] = 0
    s[3] = 0
    do{
        // println("pointer:${p}")
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

                                case Opr.sub => t = t - 1
                                                s[t] = s[t] - s[t+1] // 栈顶为 a - b（注意操作数顺序）
                                                 
                                case Opr.mul => t = t - 1
                                                s[t] = s[t] * s[t + 1]  // 栈顶为 a * b
                                        
                                case Opr.div => t = t - 1
                                                if (s[t + 1] == 0) {
                                                    throw Exception("Division by zero in Opr.div")
                                                }
                                                s[t] = s[t] / s[t + 1]  // 栈顶为 a / b（注意操作数顺序）

                                case Opr.eq =>  t = t - 1
                                                match{
                                                    case s[t] == s[t+1] => s[t] = 1
                                                    case _ => s[t] = 0
                                                }

                                case Opr.ne =>  t = t - 1
                                                match {
                                                    case s[t] != s[t+1] => s[t] = 1
                                                    case _ => s[t] = 0
                                                }

                                case Opr.lt =>  t = t - 1
                                                match {
                                                    case s[t] < s[t + 1] => s[t] = 1
                                                    case _ => s[t] = 0
                                                }

                                case Opr.le =>  t = t - 1
                                                match {
                                                    case s[t] <= s[t + 1] => s[t] = 1
                                                    case _ => s[t] = 0
                                                }
                                    
                                case Opr.gt =>  t = t - 1
                                                match {
                                                    case s[t] > s[t + 1] => s[t] = 1
                                                    case _ => s[t] = 0
                                                }

                                case Opr.ge =>  t = t - 1
                                                match {
                                                    case s[t] >= s[t + 1] => s[t] = 1
                                                    case _ => s[t] = 0
                                                }

                                case Opr.prt => print(s[t])
                                                print(" ")
                                                res.append(s[t])
                                                t = t - 1

                                case Opr.prtln => println()

                                case Opr.inp => println("输入一个数字：")
                                                let str: String = Console.stdIn.readln().getOrThrow()
                                                let num = Int64.parse(str)
                                                t = t + 1
                                                s[t] = num
                                case Opr.rev => s[t] = -s[t]
                            }
            case Fct.lod => t = t + 1
                            s[t] = s[base(i.l, b) + i.a]
            case Fct.sto => s[base(i.l, b) + i.a] = s[t]
                            t = t - 1
            case Fct.cal => s[t + 1] = base(i.l, b) /* 将父过程基地址入栈，即建立静态链 */
                            s[t + 2] = b /* 将本过程基地址入栈，即建立动态链 */
                            s[t + 3] = p;	/* 将当前指令指针入栈，即保存返回地址 */
                            b = t + 1;	/* 改变基地址指针值为新过程的基地址 */
                            p = i.a;	/* 跳转 */
            case Fct.ini => t = t + i.a
            case Fct.jmp => p = i.a
            case Fct.jpc => if(s[t] == 0){
                                p = i.a
                            }
                            t = t - 1
        }
    }while(p!=0)
    return res
}

