package L25
import L25.vm.*
import std.io.*
import L25.L25Exception.ParseException
foreign func yyparse():Int

main(): Int64 {
    try{
        println("请输入L25程序,Ctrl+D结束:")
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