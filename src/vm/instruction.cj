package L25.vm

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