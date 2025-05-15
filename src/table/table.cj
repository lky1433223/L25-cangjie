package L25.table
import std.collection.*
/*
* 符号表
*/
public class Table{
    var tables:ArrayList<TableSturct>
    init(){
        tables = ArrayList<TableSturct>()
    }
    func enter(name:String,kind:Object, val!:Int=0, level!:Int=0, adr!:Int=0, size!:Int = 0){
        var tabelstruct:TableSturct
        match(kind){
            case Object.constant => tabelstruct=TableSturct(name,kind,val)
            case Object.variable => tabelstruct=TableSturct(name,kind,level, adr)
            case Object.procedure => tabelstruct=TableSturct(name,kind,level, adr, size)
        }
        tables.append(tabelstruct)
    }
    func position(name:String):?Int{
        for(i in 0..tables.size){
            if(tables[i].name == name){
                return i
            }
        }
        return None
    }
    func print(){
        //TODO
    }
}