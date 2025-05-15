package L25
import L25.vm.*
//TODO: 没有传引用的方式吗，全局变量还是有点太抽象了
var global_code : Code = Code()
//分析AST树，返回pcode
func analyze(){
    global_code.gen(Fct.jmp, a:0)
    global_code.gen(Fct.jmp, a:0)
    global_code.gen(Fct.jmp, a:0)
    global_code.gen(Fct.jmp, a:0)
    global_code.gen(Fct.jmp, a:0)
    global_code.gen(Fct.jmp, a:0)
    global_code.gen(Fct.opr, l:0, a:toInt(Opr.add))
    return global_code
}