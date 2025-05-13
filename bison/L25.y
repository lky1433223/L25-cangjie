%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "AST.h"
#include "NODE.h"
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
    | PROGRAM ident LBRACE func_def  MAIN LBRACE stmt_list RBRACE RBRACE 
    { 
        $$=build_program($2, $4, $7);
        root = $$;
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
    /* empty */
    {
        $$ = NULL;
    }
    ;

stmt:
    /* empty */
    {
        $$ = NULL;
    }
    ;

declare_stmt:
    /* empty */
    {
        $$ = NULL;
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
    /* empty */
    {
        $$ = NULL;
    }
    ;

term:
    /* empty */
    {
        $$ = NULL;
    }
    ;

factor:
    /* empty */
    {
        $$ = NULL;
    }
    ;

ident:
    IDENT
    {
        $$ = build_ident($1);
    }
    ;

number:
    /* empty */
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