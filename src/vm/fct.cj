package L25.vm

/* 虚拟机代码指令 */
public enum Fct{
    lit |
    opr |
    lod |
    sto |
    cal |
    ini |
    jmp |
    jpc

    operator func ==(b: Fct): Bool{
        return toString(this) == toString(b)
    }
}


func toString(fct: Fct): String {
    match(fct) {
        case Fct.lit => return "lit"
        case Fct.opr => return "opr"
        case Fct.lod => return "lod"
        case Fct.sto => return "sto"
        case Fct.cal => return "cal"
        case Fct.ini => return "ini"
        case Fct.jmp => return "jmp"
        case Fct.jpc => return "jpc"
    }
}