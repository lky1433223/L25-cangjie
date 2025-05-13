#ifndef H_AST_H
#define H_AST_H

#define CHILDREN_CAP 5

struct ASTNode;
typedef struct ASTNode ASTNode;
struct ASTNode{
    int node_type;       //标识节点类型
    void* data;     //实际的节点信息
    ASTNode* children[CHILDREN_CAP];
    int child_count;    // 当前子节点数量
};



__attribute__((visibility("default"))) 
//创建空节点
ASTNode* create_node(int node_type);

__attribute__((visibility("default")))
//递归释放整个AST
void free_ast(struct ASTNode* node);


__attribute__((visibility("default"))) 
//插入一个儿子节点
void insert_child(ASTNode* father, ASTNode* child);


__attribute__((visibility("default"))) 
//创建终结符节点（关键字）
ASTNode* build_endnode(int node_type);


__attribute__((visibility("default"))) 
ASTNode* getAst();

#endif