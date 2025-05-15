package L25.test
import std.unittest.*
import std.unittest.testmacro.*
import L25.vm.*

@Test
class InterpretTests{
    @TestCase
    func selfTest() {
        var codes: Code = Code()
        codes.gen(Fct.opr, l:0, a:toInt(Opr.inp))
        interpret(codes)
    }

    @TestCase
    func addTest() {
        var codes: Code = Code()
        codes.gen(Fct.lit, l:0, a:1)
        codes.gen(Fct.lit, l:0, a:2)
        codes.gen(Fct.opr, l:0, a:toInt(Opr.add))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prt))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prtln))
        interpret(codes)
    }
}
