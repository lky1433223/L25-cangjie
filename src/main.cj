package L25
import L25.vm.*
import std.io.*
foreign func yyparse():Unit

main(): Int64 {
    
    unsafe{yyparse()}
    try{
        println("请输入L25程序,Ctrl+D结束:")
        let ast = translateAST()
        println("翻译成pcode")
        var code:Code = analyze(ast)
        code.print(with_line:true,translate_opr:true)
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