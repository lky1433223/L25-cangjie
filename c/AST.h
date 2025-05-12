#ifndef H_AST_H
#define H_AST_H

#define CHILDREN_CAP 5
typedef struct{
    int node_type;       //标识节点类型
    void* data;     //实际的节点信息
    struct AstNode* children[CHILDREN_CAP];
    int child_count;    // 当前子节点数量
}AstNode;


__attribute__((visibility("default"))) 
AstNode* getAst();

__attribute__((visibility("default"))) 
AstNode* create_node(int node_type);

#endif