/*
 * @Author: shiinarikka
 * @Date: 2025-05-24 01:04:07
 * @LastEditTime: 2025-05-26 15:52:15
 * @FilePath: /L25/src/test/compile_test.cj
 * @Description: 编译运行单元测试。编译运行测试用的L25代码，对比预期结果。
 */
package L25.test
import L25.compiler.{analyzeAST,translateAST}
import L25.vm.interpret
import std.unittest.*
import std.unittest.testmacro.*
import std.collection.*

/**
 * @description: Bison的yyparse函数
 * @return {Int}: 如果分析通过返回0
 */
foreign func yyparse(): Int
/**
 * @description: 重定向词语法分析输入
 * @param {CString}: 文件名
 * @return: Unit
 */
foreign func reset_yyin(fname: CString): Unit


@Test
class CompileTests{
    static let file_path = "./test_code/correct_test"

    func run(filename:String):ArrayList<Int>{
        unsafe { 
            let pfname = LibC.mallocCString(filename)
            reset_yyin(pfname) 
            yyparse()
        }
        let ast = translateAST()
        let codes = analyzeAST(ast)
        codes.print(with_line: true, translate_opr: true)
        interpret(codes)
    }

    @TestCase[test_item in [
        (1, []),
        (2, [1996488706]),
        (3, [3]),
        (4, [1,2,3,4]),
        (5, [2025,2027]),
        (6, [9]),
        (7, [12]),
        (8, [4,4,4,5,5,5,5]),
        (9, [-58, -30, -39, 200, 1250]),
        (10,[1,1,-1,1,1,-1,1]),
        (11, [2025,2026]),
        (12, [120]),
        (13, [11, -1]),
        (14, [225])
    ]]
    func test1(test_item:(Int, Array<Int>)){
        let filename = "${file_path}/${test_item[0]}.l25"
        @Expect(run(filename), ArrayList<Int>(test_item[1]))
    }
}