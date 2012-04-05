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
%token ENDIF 
%token <str>RAW 
%token <str> VARIABLE

%type <str> program program_definition ifdef_block_start ifdef_block_end ifdef_block code_block code

%%
 
program:
	program_definition						{ printf("%s", $1); }
	;

program_definition:
	code_block						{ $$ = $1; }
	;

ifdef_block_start:
	LEFT_CURLY_BRACKED DOLLAR_SIGN IFDEF code_block RIGHT_CURLY_BRACKED	{ $$ = ""; }
ifdef_block_end:
	LEFT_CURLY_BRACKED DOLLAR_SIGN ENDIF ' ' RIGHT_CURLY_BRACKED	{ $$ = ""; }

ifdef_block:
	ifdef_block_start code_block ifdef_block_end				{ $$ = $2; }

code:
	' '								{ $$ = " "; }	
	| '\n'								{ $$ = "\n"; }
	| RAW								{ $$ = $1; }
	| ifdef_block							{ $$ = ""; }

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

