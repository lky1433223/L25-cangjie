package L25.table

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