package L25
import L25.vm.*
import L25.L25Exception.ParseException
import std.io.*
import std.console.*
import std.convert.*
foreign func yyparse():Int
foreign func reset_yyin(fname: CString):Unit //重定向yyparse的输入
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
        println(e)
    }
    catch(e : Exception)
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
        }
        printTree()
        println(e)
    }
    

    return 0
}