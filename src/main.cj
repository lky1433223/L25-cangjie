package L25

import L25.vm.*
import L25.L25Exception.*
import L25.utils.Color
import std.io.*
import std.console.*
import std.convert.*

var global_filename: String = "Console"
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

/**
 * @description: 读取L25代码，进行词语法分析
 * @return: {Int64} yyparse的返回值
 * @Exception: ParseException
 */
func parse(_: Int): Int64 {
    println("请输入L25文件名(留空则需要后续手动输入代码)")
    if (let Some(fname) <- Console.stdIn.readln()) {
        if (fname.size != 0) {
            global_filename = fname
            let pfname = unsafe { LibC.mallocCString(fname) }
            unsafe { reset_yyin(pfname) }
        } else {
            println("请输入L25代码,Ctrl+D结束")
        }
    } else {
        println("请输入L25代码,Ctrl+D结束")
    }
    let yyresult: Int = unsafe { yyparse() }
    if (yyresult != 0) {
        throw ParseException("语法分析异常,请检查程序")
    }
    return yyresult
}

/**
 * @description: 将AST从C指针的风格翻译为仓颉的类风格
 * @return {AST}: AST的根节点
 * @Exception: TranslateException UnKonwException ParseException
 */
func translate(_: Int64): AST {
    println("--------------翻译CAST->AST------------")
    let ast = translateAST()
    return ast
}

func analyze(ast: AST): Code {
    println("--------------执行语法分析并生成Pcode------------")
    var code: Code = analyzeAST(ast)
    code.print(with_line: true, translate_opr: true)
    return code
}

func run(code: Code) {
    println("--------------执行程序-------------")
    var res = interpret(code)
    return res
}

main(): Int64 {
    try {
        let compile = (parse ~> translate ~> analyze ~> run)
        let _ = compile(0)
    } catch (e: CompileError) { //捕获编译报错并输出
        @When[debug]
        func printError() {
            let st = e.getStackTrace()
            for (item in st) {
                println(item.methodName)
            }
        }

        @When[!debug]
        func printError() {
            let ERROR_TAG = "${Color.ERROR_TAG}Error${Color.ANSI_RESET}"
            let ERROR_FILE = "${Color.ANSI_CYAN}${global_filename}${Color.ANSI_RESET}"
            let ERROR_POS = "${Color.ERROR_LOC}${e.first_line}:${e.first_colume}${Color.ANSI_RESET}"
            println("${ERROR_TAG} in ${ERROR_FILE} at ${ERROR_POS}: ${Color.ERROR_MSG}${e}${Color.ANSI_RESET}")
        }
        printError()
    } catch (e: Error) {
        @When[debug]
        func printError() {
            let st = e.getStackTrace()
            for (item in st) {
                println(item.methodName)
            }
        }

        @When[!debug]
        func printError() {
            println(e)
        }
        printError()
    } catch (e: Exception) {
        @When[debug]
        func printError() {
            let st = e.getStackTrace()
            for (item in st) {
                println(item.methodName)
            }
        }

        @When[!debug]
        func printError() {
            println(e)
        }
        printError()
    }

    return 0
}
