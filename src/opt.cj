package L25
import L25.L25Exception.UnkonwOpt
//语法分析得到的运算操作
public enum Opt {
    add | // OP_ADD   1
    sub | // OP_SUB   2
    mul | // OP_MUL   3
    div | // OP_DIV   4
    eq  | // OP_EQ    5
    ne  | // OP_NE    6
    lt  | // OP_LT    7
    le  | // OP_LE    8
    gt  | // OP_GT    9
    ge    // OP_GE    10



    func toInt(): Int32 {
        match(this) {
            case Opt.add => return 1
            case Opt.sub => return 2
            case Opt.mul => return 3
            case Opt.div => return 4
            case Opt.eq => return 5
            case Opt.ne => return 6
            case Opt.lt => return 7
            case Opt.le => return 8
            case Opt.gt => return 9
            case Opt.ge => return 10
        }
    }

    operator func ==(right:Opt){
        return this.toInt() == right.toInt()
    }
}


func getOpt(value: Int32): Opt {
    match(value) {
        case 1 => return Opt.add
        case 2 => return Opt.sub
        case 3 => return Opt.mul
        case 4 => return Opt.div
        case 5 => return Opt.eq
        case 6 => return Opt.ne
        case 7 => return Opt.lt
        case 8 => return Opt.le
        case 9 => return Opt.gt
        case 10 => return Opt.ge
        case _ => throw UnkonwOpt("未知的操作类型: ${value}")
    }
}

func toInt(opt:Opt){opt.toInt()}