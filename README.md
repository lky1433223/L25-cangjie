# L25-cangjie

> a compiler developed by **仓颉** for **L25 languages**

![License](https://img.shields.io/github/license/lky1433223/L25-cangjie)
![Issues](https://img.shields.io/github/issues/lky1433223/L25-cangjie)
![Stars](https://img.shields.io/github/stars/lky1433223/L25-cangjie)


本编译器使用[flex](https://github.com/westes/flex)，[bison](https://www.gnu.org/software/bison/manual/bison.html#)和[仓颉](#关于仓颉)实现[L25语言](#l25-语言)的编译执行，功能如下:

- 基于flex+bison实现基本词语法分析，并构建AST
  

- **加分：** 使用仓颉对AST进行语义分析，生成Pcode代码
  
- **加分：** 附加实现一个VScode代码高亮插件：[colorL25](https://marketplace.visualstudio.com/items?itemName=ShiinaRikka.colorl25&ssr=false#overview)
  
- 实现语法报错和简单错误处理

- 使用仓颉实现Pcode解释执行

# Quick Start 🤗
## 直接运行

TODO:release

## 自己构建
1. 配置仓颉
   - 安装[仓颉工具链](https://cangjie-lang.cn/docs?url=%2F0.53.18%2Fuser_manual%2Fsource_zh_cn%2Ffirst_understanding%2Finstall_Community.html)
   - 安装[CJPM](https://cangjie-lang.cn/docs?url=%2F0.53.18%2Fuser_manual%2Fsource_zh_cn%2FCompile-And-Build%2Fcjpm_usage_OHOS.html)
   - (可选) 安装[IDE插件](https://cangjie-lang.cn/docs?url=%2F0.53.18%2Ftools%2Fsource_zh_cn%2FIDE%2Fuser_manual_community.html)
2. 安装flex + bison
3. 构建项目
   ```bash
   make
   ```
4. 运行自己的代码
   
   ```bash
   cjpm run
   ```

5. 运行单元测试
   ```bash
   cjpm test
   ```



# L25 语言

## EBNF描述

```ENBF
<program> = "program" <ident> "{" { <func_def> } "main" "{" <stmt_list> "}" "}"

<func_def> = "func" <ident> "(" [ <param_list> ] ")" "{" <stmt_list> "return" <expr> ";" "}"

<param_list> = <ident> { "," <ident> }

<stmt_list> = <stmt> ";" { <stmt> ";" }

<stmt> = <declare_stmt> | <assign_stmt> | <if_stmt> | <while_stmt> | <input_stmt> |

<output_stmt> | <func_call>

<declare_stmt> = "let" <ident> [ "=" <expr> ]

<assign_stmt> = <ident> "=" <expr>

<if_stmt> = "if" "(" <bool_expr> ")" "{" <stmt_list> "}" [ "else" "{" <stmt_list> "}" ]

<while_stmt> = "while" "(" <bool_expr> ")" "{" <stmt_list> "}"

<func_call> = <ident> "(" [ <arg_list> ] ")"

<arg_list> = <expr> { "," <expr> }

<input_stmt> = "input" "(" <ident> { "," <ident> } ")"

<output_stmt> = "output" "(" <expr> { "," <expr> } ")"

<bool_expr> = <expr> ("==" | "!=" | "<" | "<=" | ">" | ">=") <expr>

<expr> = [ "+" | "-" ] <term> { ("+" | "-") <term> }

<term> = <factor> { ("*" | "/") <factor> }

<factor> = <ident> | <number> | "(" <expr> ")" | <func_call>

<ident> = <letter> { <letter> | <digit> }

<number> = <digit> { <digit> }

<letter> = "a" | "b" | ... | "z" | "A" | "B" | ... | "Z"

<digit> = "0" | "1" | ... | "9"
```

## 语法特性
- 变量名覆盖
  
  内部作用域的变量会覆盖外部变量。

  ```swift
    //TODO:example
  ```
- 



# 代码结构

# 单元测试
## 解释器测试
## 编译器测试


# 关于仓颉 
<img src="images/cangjie.png" alt="仓颉"  height="50" style="vertical-align: middle; display: inline-block; margin: 0 2px;" /> 

[仓颉](https://cangjie-lang.cn/)是由华为技术有限公司开发的面向全场景应用开发的现代编程语言。

感谢[仓颉](https://cangjie-lang.cn/)的[跨语言互操作](https://cangjie-lang.cn/docs?url=%2F0.53.18%2Fuser_manual%2Fsource_zh_cn%2FFFI%2Fcangjie-c.html)能力，本项目才能基于 flex 和 bison 进行快速开发。

在本项目中，`C` 部分的代码会返回 `AST` 的根节点指针。在`仓颉`中捕获这一个指针，并由[CPointer<T>](https://docs.cangjie-lang.cn/docs/0.53.18/libs/std/core/core_package_api/core_package_intrinsics.html#cpointert)进行解析。

解析后的 `C` 风格的 `AST` 会被[翻译](src/translate.cj)为`仓颉`风格的`AST`，再进行后续的语义分析和代码生成工作。


# Task List

## 待实现的语法

- 实现多种变量类型
- 指针类型
- 实现函数嵌套声明
  
## 语义语法分析及代码生成
| 非终结符 | C Sturct | Bison  | CAST  | AST  | CAST → AST  |  analyze | 备注 |
|------------------|--------|------------|-------------|------------|----------------|------------|------|
| program | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | - |
| func_def_list |✅ | ✅|✅ | ✅ | ✅ | ✅ | - |
| func_def | ✅ | ✅ | ✅ | ✅ |✅ | ✅ | - |
| param_list | ✅ | ✅ | ✅ | ✅| ✅| ✅| - |
| arg_list | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | - |
| stmt_list | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | - |
| stmt |  ✅  | ✅ | ✅ | ✅ | ✅ | ✅ | - |
| declare_stmt | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | - |
| assign_stmt | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | - |
| input_stmt | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | - |
| output_stmt | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | - |
| if_stmt | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | - |
| while_stmt | ✅ | ✅ | ✅ |✅ | ✅ | ✅ | - |
| func_call | ✅ | ✅ | ✅ | ✅ |✅ | ✅ | - |
| expr | ✅ | ✅  | ✅  | ✅  | ✅  | ✅  | - |
| term | ✅ | ✅  | ✅  | ✅  | ✅  | ✅  | - |
| factor | ✅ | ✅  | ✅  | ✅  | ✅  | ✅  | - |
| ident | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | - |
| number | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | - |
| bool_expr | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | - |