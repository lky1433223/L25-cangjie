%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <AST.h>
void yyerror(char * );

int yylex(void);

%}

%union {
    int bval;
    int val;   
    struct {
        int value; // 小数部分的值（如二进制 "11" 对应 3）
        int len;   // 小数部分的位数（如 "11" 对应 len=2）
    } sval;
};

%token <val> B 
%token Dot
%type <val> N 
%type <sval> S

%%

N: N expr '\n'

     | expr '\n'

     ;

expr:  S Dot S {printf("%f \n", $1.value + $3.value / pow(2,$3.len));}

     | S {printf("%d \n", $1.value);}    

     ;

S:  S B {$$.value=$1.value*2+$2; $$.len += 1;}

     | B {$$.value=$1;$$.len = 1;} 

%%

int main()

{

yyparse();

return 0;

}

void yyerror(char* msg ) {

        printf("%s\n",msg);

}