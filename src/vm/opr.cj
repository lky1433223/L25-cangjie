package L25.vm
import L25.L25Exception.UnkonwOpr
//虚拟机用到的运算操作符
public enum Opr{
    ret | //函数返回
    add |
    sub |
    mul |
    div |
    eq |
    ne |
    lt |
    le |
    gt |
    ge |
    prt   |//输出一个数
    prtln |//输出换行符
    inp   |//输入一个数
    rev    //取反
    

    func toInt(){
        match(this) {
            case Opr.ret => return 0
            case Opr.add => return 1
            case Opr.sub => return 2
            case Opr.mul => return 3
            case Opr.div => return 4
            case Opr.eq => return 5
            case Opr.ne => return 6
            case Opr.lt => return 7
            case Opr.le => return 8
            case Opr.gt => return 9
            case Opr.ge => return 10
            case Opr.prt   => return 100
            case Opr.prtln => return 101
            case Opr.inp   => return 102
            case Opr.rev => return 21
        }
    }

    func toString(){
        match(this) {
            case Opr.ret => return "ret"
            case Opr.add => return "add"
            case Opr.sub => return "sub"
            case Opr.mul => return "mul"
            case Opr.div => return "div"
            case Opr.eq => return "eq"
            case Opr.ne => return "ne"
            case Opr.lt => return "lt"
            case Opr.le => return "le"
            case Opr.gt => return "gt"
            case Opr.ge => return "ge"
            case Opr.prt => return "prt"
            case Opr.prtln => return "prtln"
            case Opr.inp => return "inp"
            case Opr.rev => return "rev"
        }
    }
}

public func getOpr(opr_type: Int): Opr {
    match(opr_type) {
        case 0 => return Opr.ret
        case 1 => return Opr.add
        case 2 => return Opr.sub
        case 3 => return Opr.mul
        case 4 => return Opr.div
        case 5 => return Opr.eq
        case 6 => return Opr.ne
        case 7 => return Opr.lt
        case 8 => return Opr.le
        case 9 => return Opr.gt
        case 10 => return Opr.ge
        case 100 => return Opr.prt
        case 101 => return Opr.prtln
        case 102 => return Opr.inp
        case 21 => return Opr.rev
        case _ => throw UnkonwOpr("UnkonwOpr ${opr_type}")
    }
}

public func toInt(opr: Opr){opr.toInt()}

func toString(opr: Opr){opr.toString()}