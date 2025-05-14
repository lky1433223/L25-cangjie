package L25
import L25.vm.*
import std.io.*

main(): Int64 {
    println("请输入L25程序,Ctrl+D结束:")
    try{
        // translateAST()
    }
    catch(e: Error)
    {
        println(e)
    }
    catch(e : Exception)
    {
        println(e)
    }

    var codes: Code = Code()
    codes.gen(Fct.opr, l:0, a:toInt(Opr.inp))
    interpret(codes)


    return 0
}