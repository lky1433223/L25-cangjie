#include"AST.h"
#include"NODE.h"
#include"OPT.h"
#include<stdio.h>
#include<stdlib.h>

AstNode* create_node(int node_type) {
    // 分配节点内存
    AstNode* node = malloc(sizeof(AstNode));
    if (!node) return NULL;

    // 初始化基础字段
    node->node_type = node_type;
    node->data = NULL;
    node->child_count = 0;
    return node;
}

AstNode* getAst(){
    AstNode* root = create_node(NODE_PROGRAM);
    return root;
}   