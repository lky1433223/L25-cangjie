/*
 * @Author: shiinarikka
 * @Date: 2025-05-15 14:46:57
 * @LastEditTime: 2025-05-24 19:19:55
 * @FilePath: /L25/src/test/interpret_test.cj
 * @Description: 单元测试，对虚拟机代码进行测试
 */
package L25.test
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*
import L25.vm.*
import L25.L25Exception.{RuntimeError,DivisionByZero}

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
        codes.print(translate_opr:true)
        var res = interpret(codes)
        let expect_res = ArrayList<Int>([3])
        @Expect(res, expect_res)
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
        let expect_res = ArrayList<Int>([-1])
        @Expect(res, expect_res)
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
        let expect_res = ArrayList<Int>([20])
        @Expect(res, expect_res)
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
        let expect_res = ArrayList<Int>([0])
        @Expect(res, expect_res)
    }

    @TestCase
    func eqTest() {
        var codes: Code = Code()
        codes.gen(Fct.lit, l:0, a:5)
        codes.gen(Fct.lit, l:0, a:5)
        codes.gen(Fct.opr, l:0, a:toInt(Opr.eq)) // 5 == 5 → 1
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prt))
        codes.gen(Fct.lit, l:0, a:6)
        codes.gen(Fct.lit, l:0, a:5)
        codes.gen(Fct.opr, l:0, a:toInt(Opr.eq)) // 5 == 6 → 0
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prt))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.ret))
        var res = interpret(codes)
        let expect_res = ArrayList<Int>([1,0])
        @Expect(res, expect_res)
    }

    @TestCase
    func neTest() {
        var codes: Code = Code()
        codes.gen(Fct.lit, l:0, a:5)
        codes.gen(Fct.lit, l:0, a:5)
        codes.gen(Fct.opr, l:0, a:toInt(Opr.ne)) // 5 != 5 → 0
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prt))
        codes.gen(Fct.lit, l:0, a:6)
        codes.gen(Fct.lit, l:0, a:5)
        codes.gen(Fct.opr, l:0, a:toInt(Opr.ne)) // 5 != 6 → 1
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prt))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.ret))
        var res = interpret(codes)
        let expect_res = ArrayList<Int>([0,1])
        @Expect(res, expect_res)
    }

    @TestCase
    func gtTest() {
        var codes: Code = Code()
        codes.gen(Fct.lit, l:0, a:5)
        codes.gen(Fct.lit, l:0, a:4)
        codes.gen(Fct.opr, l:0, a:toInt(Opr.gt)) // 5 > 4 → 1
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prt))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prtln))
        codes.gen(Fct.lit, l:0, a:4)
        codes.gen(Fct.lit, l:0, a:5)
        codes.gen(Fct.opr, l:0, a:toInt(Opr.gt)) // 4 > 5 → 0
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prt))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prtln))
        codes.gen(Fct.lit, l:0, a:998244353)
        codes.gen(Fct.lit, l:0, a:998244353)
        codes.gen(Fct.opr, l:0, a:toInt(Opr.gt)) // 998244353 > 998244353 → 0
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prt))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prtln))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.ret))
        var res = interpret(codes)
        let expect_res = ArrayList<Int>([1,0,0])
        @Expect(res, expect_res)
    }


    @TestCase
    func geTest() {
        var codes: Code = Code()
        codes.gen(Fct.lit, l:0, a:5)
        codes.gen(Fct.lit, l:0, a:4)
        codes.gen(Fct.opr, l:0, a:toInt(Opr.ge)) // 5 >= 4 → 1
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prt))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prtln))
        codes.gen(Fct.lit, l:0, a:4)
        codes.gen(Fct.lit, l:0, a:5)
        codes.gen(Fct.opr, l:0, a:toInt(Opr.ge)) // 4 >= 5 → 0
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prt))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prtln))
        codes.gen(Fct.lit, l:0, a:998244353)
        codes.gen(Fct.lit, l:0, a:998244353)
        codes.gen(Fct.opr, l:0, a:toInt(Opr.ge)) // 998244353 >= 998244353 → 1
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prt))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prtln))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.ret))
        var res = interpret(codes)
        let expect_res = ArrayList<Int>([1,0,1])
        @Expect(res, expect_res)
    }

    @TestCase
    func ltTest() {
        var codes: Code = Code()
        codes.gen(Fct.lit, l:0, a:5)
        codes.gen(Fct.lit, l:0, a:4)
        codes.gen(Fct.opr, l:0, a:toInt(Opr.lt)) // 5 < 4 → 0
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prt))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prtln))
        codes.gen(Fct.lit, l:0, a:4)
        codes.gen(Fct.lit, l:0, a:5)
        codes.gen(Fct.opr, l:0, a:toInt(Opr.lt)) // 4 < 5 → 1
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prt))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prtln))
        codes.gen(Fct.lit, l:0, a:998244353)
        codes.gen(Fct.lit, l:0, a:998244353)
        codes.gen(Fct.opr, l:0, a:toInt(Opr.lt)) // 998244353 < 998244353 → 0
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prt))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prtln))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.ret))
        var res = interpret(codes)
        let expect_res = ArrayList<Int>([0,1,0])
        @Expect(res, expect_res)
    }


    @TestCase
    func leTest() {
        var codes: Code = Code()
        codes.gen(Fct.lit, l:0, a:10214507041)
        codes.gen(Fct.lit, l:0, a:10214507041)
        codes.gen(Fct.opr, l:0, a:toInt(Opr.le)) // 10214507041 <= 10214507041 → 1
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prt))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prtln))
        codes.gen(Fct.lit, l:0, a:58539)
        codes.gen(Fct.lit, l:0, a:343)
        codes.gen(Fct.opr, l:0, a:toInt(Opr.le)) // 458539 <= 343 → 0
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prt))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prtln))
        codes.gen(Fct.lit, l:0, a:998244353)
        codes.gen(Fct.lit, l:0, a:9982443532)
        codes.gen(Fct.opr, l:0, a:toInt(Opr.lt)) // 998244353 <= 9982443532 → 1
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prt))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prtln))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.ret))
        var res = interpret(codes)
        let expect_res = ArrayList<Int>([1,0,1])
        @Expect(res, expect_res)
    }
    
    @TestCase
    func jpcJumpTest1() {
        var codes: Code = Code()
        codes.gen(Fct.lit, l:0, a:0) // 栈顶为0
        codes.gen(Fct.jpc, l:0, a:4) // 应跳转到地址4
        codes.gen(Fct.lit, l:0, a:10)//10
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prt)) //print(10)
        codes.gen(Fct.lit, l:0, a:20)//20
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prt)) //print(20)
        codes.gen(Fct.opr, l:0, a:toInt(Opr.ret))
        var res = interpret(codes)
        let expect_res = ArrayList<Int>([20])
        @Expect(res, expect_res) // 验证跳转生效
    }

    @TestCase
    func jpcJumpTest2() {
        var codes: Code = Code()
        codes.gen(Fct.lit, l:0, a:1) // 栈顶为0
        codes.gen(Fct.jpc, l:0, a:4) // 应不跳转
        codes.gen(Fct.lit, l:0, a:10)//10
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prt)) //print(10)
        codes.gen(Fct.lit, l:0, a:20)//20
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prt)) //print(20)
        codes.gen(Fct.opr, l:0, a:toInt(Opr.ret))
        var res = interpret(codes)
        let expect_res = ArrayList<Int>([10, 20])
        @Expect(res, expect_res) // 验证跳转生效
    }

    @TestCase
    func jmpJumpTest() {
        var codes: Code = Code()
        codes.gen(Fct.lit, l:0, a:1) // 栈顶为0
        codes.gen(Fct.jmp, l:0, a:4) // 直接跳转
        codes.gen(Fct.lit, l:0, a:10)//10
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prt)) //print(10)
        codes.gen(Fct.lit, l:0, a:20)//20
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prt)) //print(20)
        codes.gen(Fct.opr, l:0, a:toInt(Opr.ret))
        var res = interpret(codes)
        let expect_res = ArrayList<Int>([20])
        @Expect(res, expect_res) // 验证跳转生效
    }


    @TestCase
    func revTest() {
        var codes: Code = Code()
        codes.gen(Fct.lit, l:0, a:5)
        codes.gen(Fct.opr, l:0, a:toInt(Opr.rev)) // -5
        codes.gen(Fct.opr, l:0, a:toInt(Opr.prt))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.ret))
        var res = interpret(codes)
        let expect_res = ArrayList<Int>([-5])
        @Expect(res, expect_res)
    }

    @TestCase
    func divZeroTest() {
        var codes: Code = Code()
        codes.gen(Fct.lit, l:0, a:1)
        codes.gen(Fct.lit, l:0, a:10)
        codes.gen(Fct.lit, l:0, a:10)
        codes.gen(Fct.opr, l:0, a:toInt(Opr.rev))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.add))
        codes.gen(Fct.opr, l:0, a:toInt(Opr.div))
        @ExpectThrows[DivisionByZero](interpret(codes))// 预期抛出除零异常
    }

    @TestCase
    /**
     * @description: 从实验2中选取第二题的Pcode，循环计算和，覆盖所有指令。
     * @return {*}
     */
    func lib2Test() {
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
        let expect_res = ArrayList<Int>([5050])
        @Expect(res, expect_res)
    }
}
