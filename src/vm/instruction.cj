package L25.vm

/* 虚拟机代码结构 */
public struct Instruction{
    let f: Fct
    let l: Int
    let a: Int
    init(_f:Fct, _l!:Int=0, _a!:Int=0) {
        f = _f
        l = _l
        a = _a
    }
}