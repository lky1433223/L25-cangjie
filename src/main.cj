package L25
import std.io.*


main(): Int64 {
    println("请输入L25程序,Ctrl+D结束:")
    try{
        translateAST()
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