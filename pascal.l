%{
  #include <stdlib.h>
  void yyerror(char *);
  #include "y.tab.h"
%}

digit           [0-9]
alpha           [a-zA-Z]
variable 	{alpha}({alpha}|{digit}|_)*
anything	[^ \n{}$]+	

%%

"{"		{ return LEFT_CURLY_BRACKED; }
"}"		{ return RIGHT_CURLY_BRACKED; }

"$"		{ return DOLLAR_SIGN; }
"IFNDEF"	{ return IFNDEF; }
"IFDEF"		{ return IFDEF; }
"ENDIF"		{ return ENDIF; }

[ \n]            return *yytext;

{anything}	{ yylval.str = strdup(yytext);
		  return RAW; }
%%

int yywrap(void) {
	return 1;
}

