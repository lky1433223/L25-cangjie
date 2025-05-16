%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "AST.h"
#include "NODE.h"
#include "OPT.h"
void yyerror(char *msg);
int yylex(void);
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


%token NUMBER
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
%type <node> letter
%type <node> digit

%%
program:
    /* test */
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
        $$ = NULL;
    }
    | func_def_list func_def
    {
        $$ = NULL;
    }
    ;

func_def:
    /* empty */
    {
        $$ = NULL;
    }
    ;

param_list:
    /* empty */
    {
        $$ = NULL;
    }
    ;

stmt_list:
    stmt SEMICOLON
    {
        $$ = build_stmt_list(NULL, $1);
    }
    | stmt_list stmt SEMICOLON
    {
        $$ = build_stmt_list($1, $2);
    }
    ;

stmt:
    declare_stmt
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
    /* empty */
    {
        $$ = NULL;
    }
    ;

if_stmt:
    /* empty */
    {
        $$ = NULL;
    }
    ;

while_stmt:
    /* empty */
    {
        $$ = NULL;
    }
    ;

func_call:
    /* empty */
    {
        $$ = NULL;
    }
    ;

arg_list:
    /* empty */
    {
        $$ = NULL;
    }
    ;

input_stmt:
    /* empty */
    {
        $$ = NULL;
    }
    ;

output_stmt:
    /* empty */
    {
        $$ = NULL;
    }
    ;

bool_expr:
    /* empty */
    {
        $$ = NULL;
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
        $$ = NULL;
    }
    ;

letter:
    /* empty */
    {
        $$ = NULL;
    }
    ;

digit:
    /* empty */
    {
        $$ = NULL;
    }
    ;


%%


ASTNode* getAST(){
    return root;
}

void yyerror(char* msg ) {
        printf("%s\n",msg);
}