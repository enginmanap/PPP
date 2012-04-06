%{
  #include <stdio.h>
  #include "custom.h"
  int yylex(void);
  void yyerror(char *);
  char* defined;
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

%type <str> program ifdef_block code_block code preprocessor_block ifndef_block space white_space

%%
 
program:
	code_block							{ printf("%s", $1); }
	;


ifdef_block:
	IFDEF white_space code_block RIGHT_CURLY_BRACKED code_block LEFT_CURLY_BRACKED DOLLAR_SIGN ENDIF white_space RIGHT_CURLY_BRACKED	{ if(strcmp($3, defined) == 0)$$ = $5; else $$ = ""; }
	| IFDEF white_space code_block RIGHT_CURLY_BRACKED code_block LEFT_CURLY_BRACKED DOLLAR_SIGN ENDIF RIGHT_CURLY_BRACKED		{ if(strcmp($3, defined) == 0)$$ = $5; else $$ = ""; }

ifndef_block:
	IFNDEF white_space code_block RIGHT_CURLY_BRACKED code_block LEFT_CURLY_BRACKED DOLLAR_SIGN ENDIF white_space RIGHT_CURLY_BRACKED	{ if(strcmp($3, defined) == 0)$$ = ""; else $$ = $5; }
	| IFNDEF white_space code_block RIGHT_CURLY_BRACKED code_block LEFT_CURLY_BRACKED DOLLAR_SIGN ENDIF RIGHT_CURLY_BRACKED		{ if(strcmp($3, defined) == 0)$$ = ""; else $$ = $5; }

preprocessor_block:
	 ifdef_block							{ $$ = $1; } 
	| ifndef_block							{ $$ = $1; } 
	| code								{ $$ = strconcat("{$", $1); }

white_space:
	space								{ $$ = $1; }
	| white_space space						{ $$ = strconcat($1, $2); }

space:
	' '								{ $$ = " "; }
	| '\n'								{ $$ = "\n"; }
	| '\t'								{ $$ = "\t"; }
	
code:
	LEFT_CURLY_BRACKED DOLLAR_SIGN preprocessor_block		{ $$ = $3; }
	| white_space							{ $$ = $1; }
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

int main(int argc, char *argv[] ) {
    if ( argc != 2 ) { /* argc should be 2 for correct execution */
        /* We print argv[0] assuming it is the program name */
        printf( "usage: %s defined_name\n", argv[0] );
    } else {
	defined = argv[1];
	yyparse();
	return 0;
    }
}

