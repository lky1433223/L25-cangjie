package L25.table

public class TableSturct{
    var name: String
    var kind: Kind
    var val:Int
    var level:Int
    var adr:Int
    var size:Int
    //初始化常量
    init(name:String, kind:Kind, val:Int){
        this.name = name
        this.kind = kind
        this.val = val
        level = 0
        adr = 0
        size = 0
    }
    //初始化变量
    init(name:String, kind:Kind, level:Int, adr:Int){
        this.name = name
        this.kind = kind
        this.level = level
        this.adr = adr
        val = 0
        size = 0
    }
    //初始化函数
    init(name:String, kind:Kind, level:Int, adr:Int, size:Int){
        this.name = name
        this.kind = kind
        this.level = level
        this.adr = adr
        this.size = size
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
    }
}