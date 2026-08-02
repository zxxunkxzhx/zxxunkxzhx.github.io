%code top {
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
}

%code requires {
void yyerror(const char *s);
int yylex(void);
}

%union {
  unsigned char     uint8;
  unsigned long     ulong;
  char*             yytext_dup;
};

%token <yytext_dup> NUMERIC_STR
%token FUNC_E
%token FUNC_L

%nterm <uint8> uint8_hex
%nterm <ulong> num

%destructor { free($$); } <yytext_dup>

%code {
#define TPRINTF(...) YYFPRINTF(stdout, __VA_ARGS__)
};
%%

program:
    statements
    ;

statements:
    statement
    | statements statement
    ;

statement:
    stmt_e
    | stmt_l
    ;

stmt_e:
    FUNC_E '(' uint8_hex[e_first_hexchr] ',' uint8_hex[e_second_hexchr] ')' {
        TPRINTF("matched E stmt with args `0x%x,0x%x`\n", $e_first_hexchr, $e_second_hexchr);
    }
    ;

uint8_hex:
    NUMERIC_STR  {
        TPRINTF("taking %s as hex number\n", $1);
        $$ = strtol($1, NULL, 16);
    }
    ;

num:
    NUMERIC_STR  {
        TPRINTF("taking %s as decimal number\n", $1);
        $$ = strtol($1, NULL, 10);
    }
    ;

stmt_l:
    FUNC_L '(' {
        TPRINTF("matching L stmt\n");
     }  stmt_l_tail
    ;

stmt_l_tail:
    uint8_hex_seq ')' { TPRINTF("matched stmt_l_tail with 'uint8_hex_seq)'\n"); }
    | num ',' uint8_hex_seq ')' { TPRINTF("matched stmt_l_tail with 'num,uint8_hex_seq)'\n"); }
    ;


uint8_hex_seq:
    uint8_hex {TPRINTF("got a uint8 integer %u", $1);}
    | uint8_hex_seq uint8_hex {}
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
    TPRINTF("yyparse returned %d\n", yyparse());
}