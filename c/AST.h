#ifndef H_AST_H
#define H_AST_H

#define CHILDREN_CAP 5
#define MAX_IDNET_LEN 100

struct ASTNode;
typedef struct ASTNode ASTNode;
struct ASTNode{
    int node_type;       //标识节点类型
    void* data;     //实际的节点信息
    ASTNode* children[CHILDREN_CAP];
    int child_count;    // 当前子节点数量
};

struct identData{
    char name[MAX_IDNET_LEN];
};

struct numData{
    int num;
};

__attribute__((visibility("default")))
//递归释放整个AST
void free_AST(struct ASTNode* node);


//创建空节点
ASTNode* create_node(int node_type);



//插入一个儿子节点
void insert_child(ASTNode* father, ASTNode* child);

//创建program节点
ASTNode* build_program(ASTNode* ident, ASTNode* func_defs, ASTNode* main_block);

/**
 * 创建一个表示标识符（IDENT）的 AST 节点
 * @param name 标识符名称（如变量名、函数名等）
 * @return 构建好的 ASTNode 指针
 */
ASTNode* build_ident(const char* name);



//创建终结符节点（关键字）
// ASTNode* build_endnode();




#endif