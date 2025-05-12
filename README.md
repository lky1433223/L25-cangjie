# L25-cangjie
a compiler developed in cangjie for L25
本项目使用flex+bison实现L25语法的词法分析和语法分析。并构建AST。
由仓颉实现AST的解析和Pcode生成。


# [仓颉](https://cangjie-lang.cn/)
仓颉是由华为技术有限公司开发的面向全场景应用开发的现代编程语言。
感谢仓颉的[跨语言互操作](https://cangjie-lang.cn/docs?url=%2F0.53.18%2Fuser_manual%2Fsource_zh_cn%2FFFI%2Fcangjie-c.html)能力，本项目才能基于flex和bison进行快速开发。

仓颉内置类型
https://docs.cangjie-lang.cn/docs/0.53.18/libs/std/core/core_package_api/core_package_intrinsics.html
