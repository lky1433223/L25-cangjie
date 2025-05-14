#include"AST.h"
#include"NODE.h"
#include"OPT.h"
#include<assert.h>
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

ASTNode* create_node(int node_type) {
    // 分配节点内存
    ASTNode* node = malloc(sizeof(ASTNode));
    if (!node) return NULL;
    // 初始化基础字段
    node->node_type = node_type;
    node->data = NULL;
    node->child_count = 0;
    return node;
}


void free_AST(struct ASTNode* node) {
    if (node == NULL) {
        return;
    }

    // 1. 先递归释放所有子节点
    for (int i = 0; i < node->child_count; ++i) {
        free_AST(node->children[i]);
    }

    // 2. 释放当前节点的 data 数据（根据你的实际使用情况调整）
    if (node->data != NULL) {
        if (node->node_type == NODE_IDENT) {
            free(((struct identData*)node->data));
        } else if (node->node_type == NODE_NUMBER) {
            free(((struct numData*)node->data));
        }
    }

    // 3. 最后释放当前节点自身
    free(node);
}

void insert_child(ASTNode* father, ASTNode* child)
{
    assert(father->child_count < CHILDREN_CAP);
    father->children[father->child_count++] = child;
}


ASTNode* build_program(ASTNode* ident, ASTNode* func_defs, ASTNode* main_block)
{
    ASTNode* node = create_node(NODE_PROGRAM);
    if (ident) insert_child(node, ident);
    if (func_defs) insert_child(node, func_defs); // 可以是一个 func_def 列表
    if (main_block) insert_child(node, main_block);
    return node;
}


ASTNode* build_ident(const char* name) {
    // 分配 AST 节点内存
    ASTNode* node = create_node(NODE_IDENT);
    if (!node) {
        fprintf(stderr, "Failed to allocate AST node for ident: %s\n", name);
        return NULL;
    }

    // 分配 identData 结构体内存
    struct identData* id_data = (struct identData*)malloc(sizeof(struct identData));
    if (!id_data) {
        fprintf(stderr, "Failed to allocate identData for: %s\n", name);
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