%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);
int yylex(void);

int scope_depth = 0;
%}

%token OB CB IDENTIFIER

%%

program:
    block
    ;

block:
    OB { scope_depth++; printf("[Parser] Entered scope. Depth: %d\n", scope_depth); }
    statements 
    CB { scope_depth--; printf("[Parser] Exited scope (Popped). Depth: %d\n", scope_depth); }
    ;

statements:
    %empty
    | statements statement
    ;

statement:
    IDENTIFIER { printf("[Parser] Processed identifier inside statement\n"); }
    | block
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
#if YYDEBUG==1
    // if tracing info compiled, req for it to be outputed
    yydebug = 1;
#endif
    printf("yyparse returned %d\n", yyparse());
}