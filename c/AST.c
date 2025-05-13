#include"AST.h"
#include"NODE.h"
#include"OPT.h"
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

ASTNode* getAst(){
    ASTNode* root = create_node(NODE_PROGRAM);
    root->children[root->child_count++] = (struct ASTNode*)create_node(NODE_BOOL_EXPR);
    root->children[root->child_count++] = (struct ASTNode*)create_node(NODE_NUMBER);
    return root;
}