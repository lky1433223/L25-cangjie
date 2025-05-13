#ifndef H_AST_H
#define H_AST_H

#define CHILDREN_CAP 5

struct ASTNode;
typedef struct {
    int node_type;       //标识节点类型
    void* data;     //实际的节点信息
    struct ASTNode* children[CHILDREN_CAP];
    int child_count;    // 当前子节点数量
}ASTNode;


__attribute__((visibility("default"))) 
ASTNode* getAst();

__attribute__((visibility("default"))) 
ASTNode* create_node(int node_type);

#endif