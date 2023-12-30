%{
#include <iostream>
#include "limbaj.tab.h"
using namespace std;
%}
cInt [0-9]+
cFloat [-+]?[0-9]+"."[0-9]+
%option noyywrap
%%
"int"|"float"|"char"|"string"|"bool" {yylval.string = strdup(yytext); return TYPE;}
"const" {yylval.string = strdup(yytext);return CONST;}
"begin_progr" {return BGIN;}
"end_progr" {return END;}
[a-zA-Z][a-zA-Z0-9]* {yylval.string = strdup(yytext); return ID;}
"=" {return ASSIGN;}
{cFloat} {yylval.string = strdup(yytext); return FLOAT;}
{cInt} {yylval.string = strdup(yytext); return NR;}
[-]{cInt} {yylval.string = strdup(yytext); return NRNEG;}
[ \t] ;
\n {yylineno++;}
. {return yytext[0];}
    