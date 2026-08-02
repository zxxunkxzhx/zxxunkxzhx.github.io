%{
#include <assert.h>
#include <stdio.h>

#include "parser.tab.h"
%}

HEXDIGIT [0-9a-fA-F]
%%

E               { return FUNC_E; }
L               { return FUNC_L; }

{HEXDIGIT}+     { yylval.yytext_dup = strdup(yytext); assert(yylval.yytext_dup); return NUMERIC_STR; }

[ \t\r\n]   ; /* ignore whitespace */
.           {
                char ebuf[256];
                sprintf(ebuf, "Unknown character: '%c'\n", yytext[0]);
                yyerror(ebuf);
                return YYerror;
            }

%%

int yywrap(void) { return 1; }