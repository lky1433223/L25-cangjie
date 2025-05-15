package L25.table

public class TableSturct{
    var name: String
    var kind: Object
    var val:Int
    var level:Int
    var adr:Int
    var size:Int
    //初始化常量
    init(name:String, kind:Object, val:Int){
        this.name = name
        this.kind = kind
        this.val = val
        level = 0
        adr = 0
        size = 0
    }
    //初始化变量
    init(name:String, kind:Object, level:Int, adr:Int){
        this.name = name
        this.kind = kind
        this.level = level
        this.adr = adr
        val = 0
        size = 0
    }
    //初始化函数
    init(name:String, kind:Object, level:Int, adr:Int, size:Int){
        this.name = name
        this.kind = kind
        this.level = level
        this.adr = adr
        this.size = size
        val = 0
    }
}