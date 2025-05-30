package L25.compiler
import std.collection.*
import L25.L25Exception.Redefination
/*
* 符号表
*/
public enum Kind{
    constant | // 常量
	variable | // 变量
	function | // 函数
	program    // 程序名
	operator func  ==(right: Kind){
		return toString(this) == toString(right)
	}
}

public func toString(obj: Kind): String {
    match(obj) {
        case Kind.constant => return "constant"
        case Kind.variable => return "variable"
        case Kind.function => return "function"
        case Kind.program  => return "program"
    }
}

public class TableSturct{
    var name: String
    public var kind: Kind
    public var val:Int       /* 数值，仅const使用 */
    public var level:Int     /* 所处层，仅const不使用，用于分配变量地址 */
    public var scope:Int     /* 作用域 */
    public var adr:Int       /* 地址，仅const不使用 */
    public var size:Int      /* 需要分配的数据区空间, 仅procedure使用 */
    public var param:Int     /* 变量个数，仅procedure使用 */
    //初始化常量
    init(name:String, kind:Kind, val:Int){
        this.name = name
        this.kind = kind
        this.val = val
        level = 0
        adr = 0
        size = 0
        param = 0
        scope = 0
    }
    //初始化变量
    init(name:String, kind:Kind, level:Int, adr:Int, scope:Int){
        this.name = name
        this.kind = kind
        this.level = level
        this.adr = adr
        this.scope = scope
        val = 0
        size = 0
        param = 0
    }
    //初始化函数
    init(name:String, kind:Kind, level:Int, adr:Int, size:Int, param:Int, scope:Int){
        this.name = name
        this.kind = kind
        this.level = level
        this.adr = adr
        this.size = size
        this.param = param
        this.scope = scope
        val = 0
    }
    //初始化程序名
    init(name:String, kind:Kind){
        this.name = name
        this.kind = kind
        this.level = 0
        this.adr = 0
        this.size = 0
        val = 0
        param = 0
        scope = 0
    }
}

public class Table{
    public var tables:ArrayList<TableSturct>
    public init(){
        tables = ArrayList<TableSturct>()
    }
    public func clear(){
        tables.clear()
    }
    public func enter(name:String,kind:Kind, val!:Int=0, level!:Int=0, adr!:Int=0, size!:Int = 0, param!:Int = 0, scope!:Int=0){
        //查找是否存在变量名冲突(同类型 同作用域 重名)，允许变量名遮蔽，
        for(item in tables){
            if(item.kind == kind && item.name == name && item.scope == scope){
                throw Redefination(toString(kind), name) 
            }
        }
        
        var tabelstruct:TableSturct
        match(kind){
            case Kind.constant => tabelstruct=TableSturct(name,kind,val)
            case Kind.variable => tabelstruct=TableSturct(name,kind,level, adr, scope)
            case Kind.function => tabelstruct=TableSturct(name,kind,level, adr, size, param, scope)
            case Kind.program  => tabelstruct=TableSturct(name,kind)
        }
        tables.append(tabelstruct)
        
    }

    //查找一个符号在表里的id  由于符号遮蔽 优先选择最高scope的符号
    public func position(name:String, kind:Kind):?Int{
        for(i in tables.size -1 ..= 0 : -1){
            if(tables[i].name == name && tables[i].kind == kind){
                return i
            }
        }
        return None
    }
    //返回当前最新元素的id
    public func position():Int{
        return tables.size - 1
    }
    //删除某一作用域的所有符号
    public func remove(scope:Int){
        @When[debug]
        func printSelf(){
            this.print()
        }
        @When[!debug]
        func printSelf(){
            //Do nothing
        }
        printSelf()
        
        for(i in tables.size-1 ..= 0 : -1){
            if(tables[i].scope == scope){
                tables.remove(i)
            }
        }
        
    }
    public func print(){
        // 打印表头
        println("符号表:")
        println("+-----+----------------------+----------+-------+-------+-------+-------+-------+-------+")
        println("| idx | name                 | kind     | value | level | addr  | size  | param | scope |")
        println("+-----+----------------------+----------+-------+-------+-------+-------+-------+-------+")
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

            let param = match(entry.kind) {
                case Kind.function => "${entry.param}"
                case _ => "-"
            }

            let scope = match(entry.kind) {
                case Kind.variable => "${entry.scope}"
                case Kind.function => "${entry.scope}"
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
                "| ${size.padRight(5)} " + 
                "| ${param.padRight(5)} " +
                "| ${scope.padRight(5)} |"
            )
        }

        println("+-----+----------------------+----------+-------+-------+-------+-------+-------+-------+")
    }
}