%{
  #include <stdio.h>
  #include "custom.h"
  int yylex(void);
  void yyerror(char *);
%}

%union{
	int num;
	char* str;
}

%token SPACE
%token LEFT_CURLY_BRACKED
%token RIGHT_CURLY_BRACKED
%token DOLLAR_SIGN
%token IFDEF 
%token IFNDEF 
%token ENDIF 
%token <str>RAW 
%token <str> VARIABLE

%type <str> program ifdef_block code_block code preprocessor_block ifndef_block

%%
 
program:
	code_block							{ printf("%s", $1); }
	;


ifdef_block:
	IFDEF code_block RIGHT_CURLY_BRACKED code_block LEFT_CURLY_BRACKED DOLLAR_SIGN ENDIF ' ' RIGHT_CURLY_BRACKED	{ $$ = ""; }
	| IFDEF code_block RIGHT_CURLY_BRACKED code_block LEFT_CURLY_BRACKED DOLLAR_SIGN ENDIF RIGHT_CURLY_BRACKED	{ $$ = ""; }

ifndef_block:
	IFNDEF code_block RIGHT_CURLY_BRACKED code_block LEFT_CURLY_BRACKED DOLLAR_SIGN ENDIF ' ' RIGHT_CURLY_BRACKED	{ $$ = ""; }
	| IFNDEF code_block RIGHT_CURLY_BRACKED code_block LEFT_CURLY_BRACKED DOLLAR_SIGN ENDIF RIGHT_CURLY_BRACKED	{ $$ = ""; }

preprocessor_block:
	 ifdef_block							{ $$ = ""; } 
	| ifndef_block							{ $$ = ""; } 
	| code								{ $$ = strconcat("", $1); }

code:
	LEFT_CURLY_BRACKED DOLLAR_SIGN preprocessor_block		{ $$ = $3; }
	| ' '								{ $$ = " "; }	
	| '\n'								{ $$ = "\n"; }
	| RIGHT_CURLY_BRACKED 						{ $$ = "}"; }
	| DOLLAR_SIGN 							{ $$ = "$"; }
	| RAW								{ $$ = $1; }

code_block:
	code								{ $$ = $1; }
	| code_block code						{ $$ = strconcat($1, $2); }

%%
void yyerror(char *s) {
	fprintf(stderr, "%s\n", s);
}

int main(void) {
	yyparse();
	return 0;
}

