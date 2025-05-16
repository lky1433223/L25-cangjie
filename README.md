# L25-cangjie

a compiler developed in cangjie for L25
本项目使用 flex+bison 实现 L25 语法的词法分析和语法分析。并构建 AST。
由仓颉实现 AST 的解析和 Pcode 生成。

# [仓颉](https://cangjie-lang.cn/)

仓颉是由华为技术有限公司开发的面向全场景应用开发的现代编程语言。
感谢仓颉的[跨语言互操作](https://cangjie-lang.cn/docs?url=%2F0.53.18%2Fuser_manual%2Fsource_zh_cn%2FFFI%2Fcangjie-c.html)能力，本项目才能基于 flex 和 bison 进行快速开发。
在本项目中，C 语言部分的代码会返回一棵 AST 的根节点指针。在仓颉中捕获这一个指针，并由[CPointer<T>](https://docs.cangjie-lang.cn/docs/0.53.18/libs/std/core/core_package_api/core_package_intrinsics.html#cpointert)进行解析。
解析后的 C 风格的 AST 会被[翻译](src/translate.cj)为仓颉风格的 AST，并进行后续的翻译工作。

# L25 语言

## 非终结符

处理列表
| 非终结符 | C Node | Bison 处理 | CAST 定义 | AST 定义 | CAST → AST 翻译 | 代码生成 (analyze) | 注释 |
|------------------|--------|------------|-------------|------------|--------------------|--------------------|------|
| program | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 已完成 |
| func_def_list | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | 需实现函数定义列表解析 |
| func_def | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | 需实现函数定义（含参数列表、返回语句） |
| param_list | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | 待定义参数列表规则 |
| stmt_list | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | 需支持语句块解析 |
| stmt |  ✅  | ✅ | ✅ | ✅ | ✅ | - | 需实现语句分发逻辑 |
| declare_stmt | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | 需实现 `let` 声明语句 |
| assign_stmt | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | 需实现赋值语句 |
| if_stmt | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | 需实现条件语句 |
| while_stmt | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | 需实现循环语句 |
| func_call | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | 需实现函数调用 |
| expr | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | 需实现表达式解析 |
| term | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | 需实现表达式解析 |
| factor | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | 需实现表达式解析 |
| ident | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | 需完善标识符绑定 |
| number | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | 需完善数值绑定 |
| bool_expr | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | 需实现布尔表达式 |


## 终结符
