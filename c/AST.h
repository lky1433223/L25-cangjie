#ifndef H_AST_H
#define H_AST_H

#define MAX_IDNET_LEN 100

struct ASTNode;
typedef struct ASTNode ASTNode;
struct ListNode;
typedef struct ListNode ListNode;
// 链表节点结构
struct ListNode {
    ASTNode* data;         // data指针
    struct ListNode* next; // 下一个节点
};


struct ASTNode{
    int node_type;       //标识节点类型
    void* data;     //实际的节点信息
    ListNode* children;
    int child_count;    // 当前子节点数量
    int first_line;
    int first_colume;
    int last_line;
    int last_colume;
};

struct identData{
    char name[MAX_IDNET_LEN];
    int name_len;
};

struct numData{
    int num;
};

struct exprData{
    int op; //ADD | SUB
};


struct termData{
    int op; //MUL | DIV
};

struct boolExprData{
    int op; //EQ NE LT LE GT GE
};

__attribute__((visibility("default")))
//递归释放整个AST
void free_AST(struct ASTNode* node);


//创建空节点
ASTNode* create_node(int node_type);



//插入一个儿子节点
void insert_child(ASTNode* father, ASTNode* child);

//创建program节点
ASTNode* build_program(ASTNode* ident, ASTNode* func_def_list, ASTNode* main_block);


//创建func_def_list节点
ASTNode* build_func_def_list();

//创建func_def节点
ASTNode* build_func_def(ASTNode* ident, ASTNode* param_list, ASTNode* stmt_list, ASTNode* ret_expr);

//创建func_call节点
ASTNode* build_func_call(ASTNode* ident, ASTNode* arg_list);

//创建stmt_list节点
ASTNode* build_stmt_list();

//创建stmt节点
ASTNode* build_stmt(ASTNode* next_node);

//创建declare_stmt节点，变量声明
ASTNode* build_declare_stmt(ASTNode* ident, ASTNode* expr);

//创建assign_stmt节点，赋值语句
ASTNode* build_assign_stmt(ASTNode* ident, ASTNode* expr);

//创建output_stmt节点
ASTNode* build_output_stmt(ASTNode* arg_list);

//创建input_stmt节点
ASTNode* build_input_stmt(ASTNode* param_list);

//创建if_stmt节点
ASTNode* build_if_stmt(ASTNode* bool_expr, ASTNode* if_stmt_list, ASTNode* else_stmt_list);


//创建while_stmt节点
ASTNode* build_while_stmt(ASTNode* bool_expr, ASTNode* stmt_list);

//创建expr节点
ASTNode* build_expr(int op, ASTNode* expr, ASTNode* term);

//创建term节点
ASTNode* build_term(int op, ASTNode* term, ASTNode* factor);

//创建factor节点
ASTNode* build_factor(ASTNode* next_node);

//创建bool_expr节点
ASTNode* build_bool_expr(int op, ASTNode* expr1, ASTNode* expr2);

//创建arg_list节点
ASTNode* build_arg_list();

//创建param_list节点
ASTNode* build_param_list();



/**
 * 创建一个表示标识符（IDENT）的 AST 节点
 * @param name 标识符名称（如变量名、函数名等）
 * @return 构建好的 ASTNode 指针
 */
ASTNode* build_ident(const char* name);


/**
 * 创建一个表示数字（NUMBER）的 AST 节点
 * @param  数字
 * @return 构建好的 ASTNode 指针
 */
ASTNode* build_number(const int num);


//创建终结符节点（关键字）
// ASTNode* build_endnode();




#endif