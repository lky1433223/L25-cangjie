/*
 * @Author: shiinarikka
 * @Date: 2025-05-24 01:05:33
 * @LastEditTime: 2025-05-24 01:05:39
 * @FilePath: /L25/src/test/compile_error.cj
 * @Description: 编译报错单元测试。编译运行有语义错误的代码，检验编译报错信息的正确性。（语法报错由Bison处理，不进行单元测试）
 */
package L25.test
import std.unittest.*
import std.unittest.testmacro.*
import L25.vm.*