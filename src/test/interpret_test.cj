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





    @TestCase
    func lib2Test() {
        // from lib2 code2
        var codes: Code = Code()
        codes.gen(Fct.jmp, l:0, a:17)    // 0 jmp 0 17
        codes.gen(Fct.jmp, l:0, a:2)     // 1 jmp 0 2
        codes.gen(Fct.ini, l:0, a:3)     // 2 int 0 3
        codes.gen(Fct.lod, l:1, a:3)     // 3 lod 1 3
        codes.gen(Fct.lit, l:0, a:0)     // 4 lit 0 0
        codes.gen(Fct.opr, l:0, a:toInt(Opr.gt))    // 5 opr 0 12
        codes.gen(Fct.jpc, l:0, a:16)    // 6 jpc 0 16
        codes.gen(Fct.lod, l:1, a:4)     // 7 lod 1 4
        codes.gen(Fct.lod, l:1, a:3)     // 8 lod 1 3
        codes.gen(Fct.opr, l:0, a:toInt(Opr.add))     // 9 opr 0 2
        codes.gen(Fct.sto, l:1, a:4)     // 10 sto 1 4
        codes.gen(Fct.lod, l:1, a:3)     // 11 lod 1 3
        codes.gen(Fct.lit, l:0, a:1)     // 12 lit 0 1
        codes.gen(Fct.opr, l:0, a:toInt(Opr.sub))     // 13 opr 0 3
        codes.gen(Fct.sto, l:1, a:3)     // 14 sto 1 3
        codes.gen(Fct.cal, l:1, a:2)     // 15 cal 1 2
        codes.gen(Fct.opr, l:0, a:toInt(Opr.ret))     // 16 opr 0 0
        codes.gen(Fct.ini, l:0, a:5)    // 17 int 0 5
        codes.gen(Fct.lit, l:0, a:0)
        codes.gen(Fct.sto, l:0, a:4)
        codes.gen(Fct.lit, l:0, a:100)   // 18 lit 0 100
        codes.gen(Fct.sto, l:0, a:3)     // 19 sto 0 3
        codes.gen(Fct.cal, l:0, a:2)     // 20 cal 0 2
        codes.gen(Fct.lod, l:0, a:4)     // 21 lod 0 4
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prt))    // 22 opr 0 14
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prtln))    // 23 opr 0 15
        codes.gen(Fct.opr, l:0, a:toInt(Opr.ret))     // 24 opr 0 0
        interpret(codes)
        var res = interpret(codes)
        @Expect(res[0], 5050)
    }
}
