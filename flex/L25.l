%{

#include "stdio.h"

#include<stdlib.h>

#include "parser.tab.h"

void yyerror(char *);

int yywrap(void);

%}

%%

0 {yylval.bval=0;return B;}

1 {yylval.bval=1;return B;}

"." {return Dot;}

\n  {return *yytext;}

.       {yyerror("Unknown character!");}

%%

int yywrap(void)

{

  return 1;

}

