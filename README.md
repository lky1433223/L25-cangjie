# L25-cangjie
a compiler developed in cangjie for L25
本项目使用flex+bison实现L25语法的词法分析和语法分析。并构建AST。
由仓颉实现AST的解析和Pcode生成。

# L25语言

# [仓颉](https://cangjie-lang.cn/)
仓颉是由华为技术有限公司开发的面向全场景应用开发的现代编程语言。
感谢仓颉的[跨语言互操作](https://cangjie-lang.cn/docs?url=%2F0.53.18%2Fuser_manual%2Fsource_zh_cn%2FFFI%2Fcangjie-c.html)能力，本项目才能基于flex和bison进行快速开发。
在本项目中，C语言部分的代码会返回一棵AST的根节点指针。在仓颉中捕获这一个指针，并由[CPointer<T>](https://docs.cangjie-lang.cn/docs/0.53.18/libs/std/core/core_package_api/core_package_intrinsics.html#cpointert)进行解析。
解析后的C风格的AST会被[翻译](src/translate.cj)为仓颉风格的AST，并进行后续的翻译工作。
