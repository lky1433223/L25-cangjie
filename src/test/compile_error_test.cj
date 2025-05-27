/*
 * @Author: shiinarikka
 * @Date: 2025-05-24 01:05:33
 * @LastEditTime: 2025-05-27 17:34:32
 * @FilePath: /L25/src/test/compile_error_test.cj
 * @Description: 编译报错单元测试。编译运行有语义错误的代码，检验编译报错信息的正确性。（语法报错由Bison处理，不进行单元测试）
 */
package L25.test
import L25.compiler.{analyzeAST,translateAST}
import L25.L25Exception.{CompileError,Redefination,UnDeclaredIdent,MissingArgument,ExtraArgument}
import std.unittest.*
import std.unittest.testmacro.*
import L25.vm.*


@Test
class CompileErrorTests{
    static let file_path = "./test_code/error_test"

    func run(filename:String){
        unsafe { 
            let pfname = LibC.mallocCString(filename)
            reset_yyin(pfname) 
            yyparse()
        }
        let ast = translateAST()
        let codes = analyzeAST(ast)
    }

    @TestCase
    func test1(){
        let filename = "${file_path}/1.l25"
        try{
            run(filename)
        }catch(e:Redefination){
            //检测行列
            @Expect(e.first_colume, 17) 
            @Expect(e.first_line, 3)
        }
        @ExpectThrows[Redefination](run(filename)) //检测异常正确抛出
    }

    @TestCase
    func test2(){
        let filename = "${file_path}/2.l25"
        try{
            run(filename)
        }catch(e:Redefination){
            //检测行列
            @Expect(e.first_colume, 13) 
            @Expect(e.first_line, 4)
        }
        @ExpectThrows[Redefination](run(filename)) //检测异常正确抛出
    }

    @TestCase
    func test3(){
        let filename = "${file_path}/3.l25"
        try{
            run(filename)
        }catch(e:Redefination){
            //检测行列
            @Expect(e.first_colume, 13) 
            @Expect(e.first_line, 10)
        }
        @ExpectThrows[Redefination](run(filename)) //检测异常正确抛出
    }

    @TestCase
    func test4(){
        let filename = "${file_path}/4.l25"
        try{
            run(filename)
        }catch(e:MissingArgument){
            //检测行列
            @Expect(e.first_colume, 22) 
            @Expect(e.first_line, 14)
        }
        @ExpectThrows[MissingArgument](run(filename)) //检测异常正确抛出
    }

    @TestCase
    func test5(){
        let filename = "${file_path}/5.l25"
        try{
            run(filename)
        }catch(e:ExtraArgument){
            //检测行列
            @Expect(e.first_colume, 26) 
            @Expect(e.first_line, 14)
        }
        @ExpectThrows[ExtraArgument](run(filename)) //检测异常正确抛出
    }

    @TestCase
    func test6(){
        let filename = "${file_path}/6.l25"
        try{
            run(filename)
        }catch(e:UnDeclaredIdent){
            //检测行列
            @Expect(e.first_colume, 22) 
            @Expect(e.first_line, 6)
        }
        @ExpectThrows[UnDeclaredIdent](run(filename)) //检测异常正确抛出
    }

    @TestCase
    func test7(){
        let filename = "${file_path}/7.l25"
        try{
            run(filename)
        }catch(e:UnDeclaredIdent){
            //检测行列
            @Expect(e.first_colume, 18) 
            @Expect(e.first_line, 5)
        }
        @ExpectThrows[UnDeclaredIdent](run(filename)) //检测异常正确抛出
    }
}