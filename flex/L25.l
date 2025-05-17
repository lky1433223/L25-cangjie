%{

#include <string.h>
#include "parser.tab.h"
#include "AST.h"
FILE* fin;
void yyerror(char *);
int yywrap(void);

%}

letter [a-zA-Z]
digit [0-9]+
ident {letter}({letter}|[0-9])*

%%

"program"   { return PROGRAM; } 
"func"      { return FUNC; }
"main"      { return MAIN; }
"let"       { return LET; }
"if"        { return IF; }
"else"      { return ELSE; }
"while"     { return WHILE; }
"input"     { return INPUT; }
"output"    { return OUTPUT; }
"return"    { return RETURN; }

{digit}     { yylval.num = atoi(yytext);  return NUMBER; }
{ident}     { yylval.str = strdup(yytext);return IDENT; }

"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return STAR; }
"/"         { return DIVIDE; }
"=="        { return EQ; }
"!="        { return NEQ; }
"<"         { return LT; }
"<="        { return LE; }
">"         { return GT; }
">="        { return GE; }
"="         { return ASSIGN; }
"&"         { return ANDSIGN; }

"("         { return LPAREN; }
")"         { return RPAREN; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
"["         { return LBRACKET; }
"]"         { return RBRACKET; }
":"         { return COLON; }
";"         { return SEMICOLON; }
","         { return COMMA; }

[ \t\n]     {}
"//".*      {} /* 仅支持单行注释 */

.           { return yytext[0]; }
%%

int yywrap(void)
{
  return 1;
}

void reset_yyin(char* fname)
{
  printf("use L25 FILE %s \n", fname);
  if ((fin = fopen(fname, "r")) == NULL)
	{
		printf("Can't open the input file!\n");
		exit(1);
	}
  yyset_in(fin);
}