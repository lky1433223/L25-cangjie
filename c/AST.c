#include"AST.h"
#include"NODE.h"
#include"OPT.h"
#include "parser.tab.h"  // 包含 Bison 生成的头文件
#include<assert.h>
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include <stdarg.h>
extern YYLTYPE yylloc;   // 声明全局位置变量

//TODO:维护非根节点的yylloc信息，现在在create_node的时候创建，实际是错误的，
int safe_fprintf(FILE* stream, const char* format, ...) {
    va_list args;
    va_start(args, format);
    int ret = vfprintf(stream, format, args);
    va_end(args);
    return ret;
}

ASTNode* create_node(int node_type) {
    // 分配节点内存
    ASTNode* node = malloc(sizeof(ASTNode));
    if (!node) return NULL;
    // 初始化基础字段
    node->node_type = node_type;
    node->data = NULL;
    node->child_count = 0;
    node->children = malloc(sizeof(ListNode));
    node->children->data = NULL;
    node->children->next = NULL;
    node->first_line = yylloc.first_line;
    node->first_colume = yylloc.first_column;
    node->last_line = yylloc.last_line;
    node->last_colume = yylloc.last_column;
    return node;
}

void insert_list(ListNode* head, ASTNode* data) {
    if (head == NULL) {
        safe_fprintf(stderr, "Insert to an empty List"); // 空链表无法插入
        return;
    }

    // 找到最后一个节点
    while (head->next != NULL) {
        head = head->next;
    }

    // 分配新节点
    ListNode* newNode = (ListNode*)malloc(sizeof(ListNode));
    if (newNode == NULL) {
        // 内存分配失败
        safe_fprintf(stderr, "Failed to allocate new ListNode");
        return;
    }
    newNode->data = data;
    newNode->next = NULL;

    // 插入到链表尾部
    head->next = newNode;
}

void free_AST(struct ASTNode* node) {
    if (node == NULL) {
        return;
    }

    // 1. 先递归释放所有子节点
    ListNode* child = node->children;
    while (child != NULL) {
        ListNode* next = child->next;
        free_AST(child->data); // 递归释放子节点
        free(child);           // 释放链表节点
        child = next;
    }

    // 2. 释放当前节点的 data 数据
    if (node->data != NULL) {
        if (node->node_type == NODE_IDENT) {
            free(((struct identData*)node->data));
        }
        else if (node->node_type == NODE_NUMBER) {
            free(((struct numData*)node->data));
        }
        else if (node->node_type == NODE_EXPR) {
            free(((struct exprData*)node->data));
        }
        else if (node->node_type == NODE_TERM) {
            free(((struct termData*)node->data));
        }
        else if (node->node_type == NODE_BOOL_EXPR) {
            free(((struct boolExprData*)node->data));
        }
    }

    // 3. 最后释放当前节点自身
    free(node);
}

void insert_child(ASTNode* father, ASTNode* child)
{
    insert_list(father->children, child);
    father->child_count++;
}


ASTNode* build_program(ASTNode* ident, ASTNode* func_def_list, ASTNode* main_block)
{
    ASTNode* node = create_node(NODE_PROGRAM);
    if (ident) insert_child(node, ident);
    if (func_def_list) insert_child(node, func_def_list); // 可以是一个 func_def 列表
    if (main_block) insert_child(node, main_block);
    return node;
}



ASTNode* build_func_def_list()
{
    ASTNode* node = create_node(NODE_FUNC_DEF_LIST);
    return node;
}

ASTNode* build_func_def(ASTNode* ident, ASTNode* param_list, ASTNode* stmt_list, ASTNode* ret_expr)
{
    ASTNode* node = create_node(NODE_FUNC_DEF);
    if(ident)      insert_child(node, ident);
    if(param_list) insert_child(node, param_list);
    if(stmt_list)  insert_child(node, stmt_list);
    if(ret_expr)   insert_child(node, ret_expr);
    return node;
}

ASTNode *build_func_call(ASTNode *ident, ASTNode *arg_list)
{
    ASTNode* node = create_node(NODE_FUNC_CALL);
    if(ident) insert_child(node, ident);
    if(arg_list) insert_child(node, arg_list);
    return node;
}

ASTNode* build_stmt_list(){
    ASTNode* node = create_node(NODE_STMT_LIST);
    return node;
}

ASTNode* build_stmt(ASTNode* next_node){
    ASTNode* node = create_node(NODE_STMT);
    if(next_node) insert_child(node, next_node);
    return node;
}

ASTNode* build_declare_stmt(ASTNode* ident, ASTNode* expr){
    ASTNode* node = create_node(NODE_DECLARE_STMT);
    if(ident) insert_child(node, ident);
    if(expr) insert_child(node, expr);
    return node;
}

ASTNode* build_assign_stmt(ASTNode* ident, ASTNode* expr){
    ASTNode* node = create_node(NODE_ASSIGN_STMT);
    if(ident) insert_child(node, ident);
    if(expr) insert_child(node, expr);
    return node;
}

ASTNode* build_output_stmt(ASTNode* arg_list){
    ASTNode* node = create_node(NODE_OUTPUT_STMT);
    if(arg_list) insert_child(node, arg_list);
    return node;
}

ASTNode* build_input_stmt(ASTNode* param_list){
    ASTNode* node = create_node(NODE_INPUT_STMT);
    if(param_list) insert_child(node, param_list);
    return node;
}


ASTNode* build_if_stmt(ASTNode* bool_expr, ASTNode* if_stmt_list, ASTNode* else_stmt_list){
    ASTNode* node = create_node(NODE_IF_STMT);
    if(bool_expr) insert_child(node, bool_expr);
    if(if_stmt_list) insert_child(node, if_stmt_list);
    if(else_stmt_list) insert_child(node, else_stmt_list);
    return node;
}

ASTNode* build_while_stmt(ASTNode* bool_expr, ASTNode* stmt_list){
    ASTNode* node = create_node(NODE_WHILE_STMT);
    if(bool_expr) insert_child(node, bool_expr);
    if(stmt_list) insert_child(node, stmt_list);
    return node;
}

ASTNode* build_expr(int op, ASTNode* expr, ASTNode* term){
    // 分配 AST 节点内存
    ASTNode* node = create_node(NODE_EXPR);
    if (!node) {
        safe_fprintf(stderr, "Failed to allocate AST node for expr");
        return NULL;
    }
    // 分配 exprData 结构体内存
    struct exprData* expr_data = (struct exprData*)malloc(sizeof(struct exprData));
    if (!expr_data) {
        safe_fprintf(stderr, "Failed to allocate exprData");
        free(node);
        return NULL;
    }
    expr_data->op = op;
    node->data = expr_data;
    if(expr) insert_child(node, expr);
    if(term) insert_child(node, term);
    return node;
}

ASTNode* build_term(int op, ASTNode* term, ASTNode* factor){
    // 分配 AST 节点内存
    ASTNode* node = create_node(NODE_TERM);
    if (!node) {
        safe_fprintf(stderr, "Failed to allocate AST node for term");
        return NULL;
    }
    // 分配 exprData 结构体内存
    struct termData* term_data = (struct termData*)malloc(sizeof(struct termData));
    if (!term_data) {
        safe_fprintf(stderr, "Failed to allocate termData");
        free(node);
        return NULL;
    }
    if(op == OP_DIV || op == OP_MUL){
        term_data->op = op;
    }
    else{
        term_data->op = 0;
    }
    node->data = term_data;
    if(term) insert_child(node, term);
    if(factor) insert_child(node, factor);

    return node;
}

ASTNode* build_factor(ASTNode* next_node){
    ASTNode* node = create_node(NODE_FACTOR);
    if(next_node) insert_child(node, next_node);
    return node;
}

ASTNode* build_bool_expr(int op, ASTNode* expr1, ASTNode* expr2){
    ASTNode* node = create_node(NODE_BOOL_EXPR);
    // 分配 boolExprData 结构体内存
    struct boolExprData* bool_expr_data = (struct boolExprData*)malloc(sizeof(struct boolExprData));
    if (!bool_expr_data) {
        safe_fprintf(stderr, "Failed to allocate boolExprData");
        free(node);
        return NULL;
    }
    bool_expr_data->op = op;
    node->data = bool_expr_data;
    if(expr1) insert_child(node, expr1);
    if(expr2) insert_child(node, expr2);
    return node;
}

ASTNode* build_arg_list(){
    ASTNode* node = create_node(NODE_ARG_LIST);
    return node;
}

ASTNode* build_param_list(){
    ASTNode* node = create_node(NODE_PARAM_LIST);
    return node;
}

ASTNode* build_ident(const char* name) {
    // 分配 AST 节点内存
    ASTNode* node = create_node(NODE_IDENT);
    if (!node) {
        safe_fprintf(stderr, "Failed to allocate AST node for ident: %s\n", name);
        return NULL;
    }

    // 分配 identData 结构体内存
    struct identData* id_data = (struct identData*)malloc(sizeof(struct identData));
    if (!id_data) {
        safe_fprintf(stderr, "Failed to allocate identData for: %s\n", name);
        free(node);
        return NULL;
    }

    // 复制标识符名称到结构体中
    strcpy(id_data->name, name);
    id_data->name_len = strlen(id_data->name);
    // 将数据绑定到 AST 节点
    node->data = id_data;

    return node;
}

ASTNode* build_number(const int num){
    // 分配 AST 节点内存
    ASTNode* node = create_node(NODE_NUMBER);
    if (!node) {
        safe_fprintf(stderr, "Failed to allocate AST node for number: %d\n", num);
        return NULL;
    }
    // 分配 numData 结构体内存
    struct numData* num_data = (struct numData*)malloc(sizeof(struct numData));
    if (!num_data) {
        safe_fprintf(stderr, "Failed to allocate numData for: %d\n", num);
        free(node);
        return NULL;
    }
    num_data->num = num;
    node->data = num_data;
    return node;
}