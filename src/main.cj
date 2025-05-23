package L25
import L25.vm.*
import L25.L25Exception.ParseException
import std.io.*
import std.console.*
import std.convert.*
/**
 * @description: Bison的yyparse函数
 * @return {Int}: 如果分析通过返回0
 */
foreign func yyparse():Int
/**
 * @description: 重定向词语法分析输入
 * @param {CString}: 文件名
 * @return: Unit
 */
foreign func reset_yyin(fname: CString):Unit 

/**
 * @description: 读取L25代码，进行词语法分析
 * @return: {Int64} yyparse的返回值
 * @Exception: ParseException
 */
func parse(_:Int):Int64{
    println("请输入L25文件名(留空则需要后续手动输入代码)")
    if(let Some(fname) <-  Console.stdIn.readln()){
        if(fname.size != 0){
            let pfname = unsafe{LibC.mallocCString(fname)}
            unsafe{reset_yyin(pfname)}
        }
        else{
            println("请输入L25代码,Ctrl+D结束")
        }
    }
    else{
        println("请输入L25代码,Ctrl+D结束")
    }
    let yyresult:Int = unsafe{yyparse()}
    if(yyresult!=0){throw ParseException("语法分析异常,请检查程序")}
    return yyresult
}

/**
 * @description: 将AST从C指针的风格翻译为仓颉的类风格
 * @return {AST}: AST的根节点
 * @Exception: TranslateException UnKonwException ParseException
 */
func translate(_:Int64):AST{
    println("从CAST翻译成AST:")
    let ast = translateAST()
    return ast
}
func analyze(ast:AST):Code{
    println("编译:")
    var code:Code = analyzeAST(ast)
    code.print(with_line:true,translate_opr:true)
    return code
}
func run(code:Code){
    println("执行程序")
    var res = interpret(code)
    return res
}

main(): Int64 {
    try{
        let compile = (parse ~> translate ~> analyze ~> run)
        let _ = compile(0)
    }
    catch(e: Error)
    {
        @When[debug]
        func printTree(){
            let st = e.getStackTrace()
            for(item in st){
                println(item.methodName)
            }
        }
        @When[!debug]
        func printTree(){
            println(e)
        }
        printTree()
    }
    catch(e : Exception)
    {
        // @When[debug]
        // func printTree(){
        //     let st = e.getStackTrace()
        //     for(item in st){
        //         println(item.methodName)
        //     }
        // }
        // @When[!debug]
        // func printTree(){
        // }
        // printTree()
        println(e)
    }
    

    return 0
}