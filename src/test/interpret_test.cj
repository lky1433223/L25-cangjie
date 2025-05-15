package L25.test
import std.unittest.*
import std.unittest.testmacro.*
import L25.vm.*

@Test
class InterpretTests{

    @TestCase
    func addTest() {
        var codes: Code = Code()
        codes.gen(Fct.lit, l:0, a:1)
        codes.gen(Fct.lit, l:0, a:2)
        codes.gen(Fct.opr, l:0, a:toInt(Opr.add))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prt))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prtln))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.ret))
        var res = interpret(codes)
        @Expect(res[0], 3)
    }


    @TestCase
    func subTest() {
        var codes: Code = Code()
        codes.gen(Fct.lit, l:0, a:1)
        codes.gen(Fct.lit, l:0, a:2)
        codes.gen(Fct.opr, l:0, a:toInt(Opr.sub))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prt))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prtln))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.ret))
        interpret(codes)
        var res = interpret(codes)
        @Expect(res[0], -1)
    }


    @TestCase
    func mulTest() {
        var codes: Code = Code()
        codes.gen(Fct.lit, l:0, a:4)
        codes.gen(Fct.lit, l:0, a:5)
        codes.gen(Fct.opr, l:0, a:toInt(Opr.mul))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prt))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prtln))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.ret))
        interpret(codes)
        var res = interpret(codes)
        @Expect(res[0], 20)
    }

        @TestCase
    func divTest() {
        var codes: Code = Code()
        codes.gen(Fct.lit, l:0, a:4)
        codes.gen(Fct.lit, l:0, a:5)
        codes.gen(Fct.opr, l:0, a:toInt(Opr.div))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prt))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prtln))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.ret))
        interpret(codes)
        var res = interpret(codes)
        @Expect(res[0], 0)
    }
}
