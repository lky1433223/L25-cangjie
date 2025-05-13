#include"AST.h"
#include"NODE.h"
#include"OPT.h"
#include<assert.h>
#include<stdio.h>
#include<stdlib.h>

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
        // 假设你用 strdup 存储了 IDENT 的名字，或者 malloc 存储了数值
        free(node->data);
    }

    // 3. 最后释放当前节点自身
    free(node);
}

void insert_child(ASTNode* father, ASTNode* child)
{
    assert(father->child_count < CHILDREN_CAP);
    father->children[father->child_count++] = child;
}

ASTNode* build_endnode(int node_type)
{
    ASTNode* root = create_node(NODE_PROGRAM);
    return root;
}