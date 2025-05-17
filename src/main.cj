package L25
import L25.vm.*
import L25.L25Exception.ParseException
import std.io.*
import std.console.*
import std.convert.*
foreign func yyparse():Int
foreign func reset_yyin(fname: CString):Unit //重定向yyparse的输入
main(): Int64 {
    try{
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
        println("从CAST翻译成AST:")
        let ast = translateAST()
        println("编译:")
        var code:Code = analyze(ast)
        code.print(with_line:true,translate_opr:true)
        println("执行程序")
        interpret(code)
    }
    catch(e: Error)
    {
        println(e)
    }
    catch(e : Exception)
    {
        println(e)
    }
    

    return 0
}