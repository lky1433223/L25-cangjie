package L25.table
import std.collection.*
/*
* 符号表
*/
public class Table{
    public var tables:ArrayList<TableSturct>
    public init(){
        tables = ArrayList<TableSturct>()
    }
    public func enter(name:String,kind:Kind, val!:Int=0, level!:Int=0, adr!:Int=0, size!:Int = 0){
        //TODO:检查符号表冲突
        var tabelstruct:TableSturct
        match(kind){
            case Kind.constant => tabelstruct=TableSturct(name,kind,val)
            case Kind.variable => tabelstruct=TableSturct(name,kind,level, adr)
            case Kind.function => tabelstruct=TableSturct(name,kind,level, adr, size)
            case Kind.program  => tabelstruct=TableSturct(name,kind)
        }
        tables.append(tabelstruct)
    }
    //查找一个符号在表里的id
    public func position(name:String):?Int{
        //TODO:增加指定查找的类型
        for(i in 0..tables.size){
            if(tables[i].name == name){
                return i
            }
        }
        return None
    }
    //返回当前最新元素的id
    public func position():Int{
        return tables.size - 1
    }
    public func print(){
        // 打印表头
        println("符号表:")
        println("+-----+----------------------+----------+-------+-------+-------+-------+")
        println("| idx | name                 | kind     | value | level | addr  | size  |")
        println("+-----+----------------------+----------+-------+-------+-------+-------+")
        for (idx in 0..tables.size) {
            let entry = tables[idx]
            let name = entry.name
            let kind = toString(entry.kind)

            let value = match(entry.kind) {
                case Kind.constant => "${entry.val}"
                case _ => "-"
            }

            let level = match(entry.kind) {
                case Kind.variable => "${entry.level}"
                case Kind.function => "${entry.level}"
                case _ => "-"
            }

            let addr = match(entry.kind) {
                case Kind.variable => "${entry.adr}"
                case Kind.function => "${entry.adr}"
                case Kind.program  => "${entry.adr}"
                case _  => "-"
            }

            let size = match(entry.kind) {
                case Kind.function => "${entry.size}"
                case Kind.program  => "${entry.size}"
                case _ => "-"
            }

            // 格式化输出
            println(
                "| ${idx.toString().padLeft(3)} " +
                "| ${name.padRight(20)} " +
                "| ${kind.padRight(8)} " +
                "| ${value.padRight(5)} " +
                "| ${level.padRight(5)} " +
                "| ${addr.padRight(5)} " +
                "| ${size.padRight(5)} |"
            )
        }

        println("+-----+----------------------+----------+-------+-------+-------+-------+")
    }
}