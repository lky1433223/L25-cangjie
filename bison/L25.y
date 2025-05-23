%locations
%define parse.error verbose
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "AST.h"
#include "NODE.h"
#include "OPT.h"

void yyerror(const char *msg);
int yylex(void);
extern FILE* fin;
extern char global_filename[200];
struct ASTNode* root;
__attribute__((visibility("default"))) 
//获取AST根节点指针
ASTNode* getAST();
%}



%union {
    int num;
    char* str;
    struct ASTNode* node;
};

%token PROGRAM FUNC MAIN LET IF ELSE WHILE INPUT OUTPUT RETURN
%token PLUS MINUS STAR DIVIDE EQ NEQ LT LE GT GE ASSIGN ANDSIGN
%token LPAREN RPAREN 
%token LBRACE RBRACE 
%token LBRACKET RBRACKET
%token COLON SEMICOLON COMMA
%left PLUS MINUS
%left STAR DIVIDE

%token <num> NUMBER
%token <str> IDENT

%type <node> program 
%type <node> func_def_list
%type <node> func_def 
%type <node> param_list 
%type <node> stmt_list
%type <node> stmt
%type <node> declare_stmt
%type <node> assign_stmt
%type <node> if_stmt
%type <node> while_stmt
%type <node> func_call
%type <node> arg_list
%type <node> input_stmt
%type <node> output_stmt
%type <node> bool_expr
%type <node> expr
%type <node> term
%type <node> factor
%type <node> ident
%type <node> number

%%
program:
    PROGRAM
    { 
        $$=build_program(NULL,NULL,NULL);
        root = $$;
    }
    | PROGRAM ident LBRACE MAIN LBRACE stmt_list RBRACE RBRACE 
    { 
        $$=build_program($2, NULL, $6);
        root = $$;
    }
    | PROGRAM ident LBRACE func_def_list  MAIN LBRACE stmt_list RBRACE RBRACE 
    { 
        $$=build_program($2, $4, $7);
        root = $$;
    }
    ;

func_def_list:
    func_def
    {
        $$ = build_func_def_list();
        insert_child($$, $1);
    }
    | func_def_list func_def
    {
        $$ = $1;
        insert_child($$, $2);
    }
    ;

func_def:
    FUNC ident LPAREN RPAREN LBRACE stmt_list RETURN expr SEMICOLON RBRACE
    {
        $$ = build_func_def($2, NULL, $6, $8);
    }
    | FUNC ident LPAREN param_list RPAREN LBRACE stmt_list RETURN expr SEMICOLON RBRACE
    {
        $$ = build_func_def($2, $4, $7, $9);
    }
    ;

param_list:
    ident
    {
        $$ = build_param_list();
        insert_child($$, $1);
    }
    | param_list COMMA ident
    {
        $$ = $1;
        insert_child($$, $3);
    }
    ;

stmt_list:
    stmt SEMICOLON
    {
        $$ = build_stmt_list();
        insert_child($$, $1);
    }
    | stmt_list stmt SEMICOLON
    {
        $$ = $1;
        insert_child($$, $2);
    }
    ;

stmt:
    declare_stmt
    {
        $$ = build_stmt($1);
    }
    | assign_stmt
    {
        $$ = build_stmt($1);
    }
    | output_stmt
    {
        $$ = build_stmt($1);
    }
    | input_stmt
    {
        $$ = build_stmt($1);
    }
    | if_stmt
    {
        $$ = build_stmt($1);
    }
    | while_stmt
    {
        $$ = build_stmt($1);
    }
    ;

declare_stmt:
    LET ident
    {
        $$ = build_declare_stmt($2, NULL);
    }
    | LET ident ASSIGN expr
    {
        $$ = build_declare_stmt($2,$4);
    }
    ;

assign_stmt:
    ident ASSIGN expr
    {
        $$ = build_assign_stmt($1,$3);
    }
    ;

if_stmt:
    IF LPAREN bool_expr RPAREN LBRACE stmt_list RBRACE
    {
        $$ = build_if_stmt($3, $6, NULL);
    }
    | IF LPAREN bool_expr RPAREN LBRACE stmt_list RBRACE ELSE LBRACE stmt_list RBRACE
    {
        $$ = build_if_stmt($3, $6, $10);
    }
    ;

while_stmt:
    WHILE LPAREN bool_expr RPAREN LBRACE stmt_list RBRACE
    {
        $$ = build_while_stmt($3, $6);
    }
    ;

func_call:
    ident LPAREN RPAREN
    {
        $$ = build_func_call($1, NULL);
    }
    | ident LPAREN arg_list RPAREN
    {
        $$ = build_func_call($1, $3);
    }
    ;

arg_list:
    expr
    {
        $$ = build_arg_list();
        insert_child($$, $1);
    }
    | arg_list COMMA expr
    {
        $$ = $1;
        insert_child($$, $3);
    }
    ;

input_stmt:
    INPUT LPAREN param_list RPAREN
    {
        $$ = build_input_stmt($3);
    }
    ;

output_stmt:
    OUTPUT LPAREN arg_list RPAREN
    {
        $$ = build_output_stmt($3);
    }
    ;

bool_expr:
    expr EQ expr
    {
        $$ = build_bool_expr(OP_EQ, $1, $3);
    }
    | expr NEQ expr
    {
        $$ = build_bool_expr(OP_NE, $1, $3);
    }
    | expr LT expr
    {
        $$ = build_bool_expr(OP_LT, $1, $3);
    }
    | expr LE expr
    {
        $$ = build_bool_expr(OP_LE, $1, $3);
    }
    | expr GT expr
    {
        $$ = build_bool_expr(OP_GT, $1, $3);
    }
    | expr GE expr
    {
        $$ = build_bool_expr(OP_GE, $1, $3);
    }
    ;

expr:
    PLUS term
    {
        $$ = build_expr(OP_ADD, NULL, $2);
    }
    | MINUS term
    {
        $$ = build_expr(OP_SUB, NULL, $2);
    }
    | term
    {
        //默认是加法
        $$ = build_expr(OP_ADD, NULL, $1);
    }
    | expr PLUS term
    {
        $$ = build_expr(OP_ADD, $1, $3);
    }
    | expr MINUS term
    {
        $$ = build_expr(OP_SUB, $1, $3);
    }
    ;

term:
    factor
    {
        $$ = build_term(0, NULL, $1);
    }
    | term STAR factor
    {
        $$ = build_term(OP_MUL, $1, $3);
    }
    | term DIVIDE factor
    {
        $$ = build_term(OP_DIV, $1, $3);
    }
    ;

factor:
    ident
    {
        $$ = build_factor($1);
    }
    | number
    {
        $$ = build_factor($1);
    }
    | LPAREN expr RPAREN
    {
        $$ = build_factor($2);
    }
    | func_call
    {
        $$ = build_factor($1);
    }
    ;

ident:
    IDENT
    {
        $$ = build_ident($1);
    }
    ;

number:
    NUMBER
    {
        $$ = build_number($1);
    }
    ;



%%


ASTNode* getAST(){
    return root;
}

void print_error_context_file(const char* filename, int line_num, int col_num) {
    FILE* file = fopen(filename, "r");
    if (!file) {
        fprintf(stderr, "Cannot open source file for error context\n");
        return;
    }

    // 定位到错误行
    char line[1024];
    int current_line = 1;
    while (fgets(line, sizeof(line), file)) {
        if (current_line == line_num) break;
        current_line++;
    }

    if (current_line != line_num) {
        fclose(file);
        return;
    }

    // 生成箭头指示
    char indicator[256] = {0};
    int tab_adjust = 0;
    for (int i=0; i<col_num-1 + tab_adjust; i++) {
        if (line[i] == '\t') tab_adjust += 3; // 假设 tab 宽度为4
        strcat(indicator, " ");
    }
    strcat(indicator, "\x1b[31m^~~ \x1b[0m");

    fprintf(stderr,"  | \x1b[36m%04d\x1b[0m | %s",line_num,line);
    fprintf(stderr,"  |        %s\n",indicator);

    fclose(file);
}

void yyerror(const char* msg ) {
    if(fin){
        fprintf(stderr, "\033[38;5;196m\033[48;5;232mError\033[0m in \033[36m%s\033[0m at \033[38;5;226m%d:%d\033[0m: \033[38;5;255m%s\033[0m\n", global_filename, yylloc.first_line, yylloc.first_column, msg);
        print_error_context_file(global_filename, yylloc.first_line, yylloc.first_column);
    }
    else{
        fprintf(stderr, "\033[38;5;196m\033[48;5;232mError\033[0m in \033[36m%s\033[0m at \033[38;5;226m%d:%d\033[0m: \033[38;5;255m%s\033[0m\n", "Console", yylloc.first_line, yylloc.first_column, msg);
    }
}