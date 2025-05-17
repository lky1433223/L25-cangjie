#ifndef H_NODE_H
#define H_NODE_H
// 节点类型常量（用宏代替enum）
#define NODE_PROGRAM        0
#define NODE_FUNC_DEF       1
#define NODE_PARAM_LIST     2  //函数参数列表
#define NODE_STMT_LIST      3
#define NODE_DECLARE_STMT   4
#define NODE_ASSIGN_STMT    5
#define NODE_IF_STMT        6
#define NODE_WHILE_STMT     7
#define NODE_FUNC_CALL      8
#define NODE_EXPR           9
#define NODE_IDENT          10
#define NODE_NUMBER         11
#define NODE_STRING_LIST    12
#define NODE_BOOL_EXPR      13
#define NODE_FUNC_DEF_LIST  14
#define NODE_STMT           15
#define NODE_INPUT_STMT     16
#define NODE_OUTPUT_STMT    17
#define NODE_TERM           18
#define NODE_FACTOR         19
#define NODE_ARG_LIST       20
#endif