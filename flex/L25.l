%{

#include <string.h>
#include "parser.tab.h"
#include "AST.h"
FILE* fin = NULL;
char global_filename[200];
void yyerror(char *);
int yywrap(void);

//YY_USER_ACTION 会在处理每一个变量的时候调用
#define YY_USER_ACTION \
    yylloc.first_line = yylloc.last_line; \
    yylloc.first_column = yylloc.last_column; \
    for (char *p = yytext; *p; p++) { \
        if (*p == '\n') { \
            yylloc.last_line++; \
            yylloc.last_column = 1; \
        } else { \
            yylloc.last_column++; \
        } \
    } \
    //printf("%d %d %d %d\n", yylloc.first_line, yylloc.first_column, yylloc.last_line, yylloc.last_column);

extern YYLTYPE yylloc;  // Bison 会在 parser.tab.h 中定义 YYLTYPE
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

void reset_yylloc(){
  yylloc.first_line = 1;
  yylloc.first_column = 0;
  yylloc.last_line = 1;
  yylloc.last_column = 0;
}

void reset_yyin(char* fname)
{
  strcpy(global_filename, fname);
  printf("use L25 FILE %s \n", global_filename);
  if ((fin = fopen(fname, "r")) == NULL)
	{
		printf("Can't open the input file!\n");
		exit(1);
	}
  yyset_in(fin);
}