%{
#include <stdio.h>

#include "parser.tab.h"

extern int scope_depth;
%}

%%

"{"         { return OB; }
"}"         { return CB; }

[a-zA-Z]+   { 
                printf("[Lexer] Evaluated identifier '%s' at scope depth: %d\n", yytext, scope_depth);
                return IDENTIFIER; 
            }

[ \t\n]     ; /* ignore whitespace */
.           { printf("Unknown character: %s\n", yytext); }

%%

int yywrap(void) { return 1; }