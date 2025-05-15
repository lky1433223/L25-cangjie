package L25
import L25.vm.*
import std.io.*
foreign func yyparse():Unit

main(): Int64 {
    println("请输入L25程序,Ctrl+D结束:")
    unsafe{yyparse()}
    try{
        let AST = translateAST()
    }
    catch(e: Error)
    {
        println(e)
    }
    catch(e : Exception)
    {
        println(e)
    }
    println("翻译成pcode")
    var code:Code = analyze()
    code.print(with_line:true,translate_opr:true)

    return 0
}