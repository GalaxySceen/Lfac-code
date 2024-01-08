%{
#include <iostream>
#include "limbaj.tab.h"
using namespace std;
#define YYSTYPE union
%}
cInt [-+]?[1-9][0-9]*
cFloat [-+]?[0-9]+"."[0-9]+
%option noyywrap
%%
"int"    {yylval.string = strdup(yytext); return TYPE;}
"float"  {yylval.string = strdup(yytext); return TYPE;}
"char"   {yylval.string = strdup(yytext); return TYPE;}
"string" {yylval.string = strdup(yytext); return TYPE;}
"bool"   {yylval.string = strdup(yytext); return BOOL;}
"const"  {yylval.string = strdup(yytext); return CONST;}
"begin_progr" {return BGIN;}
"end_progr"   {return END;}
"struct" {yylval.string = strdup(yytext);}
"true"  {yylval.string = strdup(yytext); return BOOLRESPONSE;}
"false" {yylval.string = strdup(yytext); return BOOLRESPONSE;}
[a-zA-Z][a-zA-Z0-9]* {yylval.string = strdup(yytext); return ID;}
"="    {return ASSIGN;}
{cFloat} {yylval.floatValue = atof(yytext); return FLOAT;}
{cInt}   {yylval.intValue = atoi(yytext); return NR;}
[ \t] ;
\n {yylineno++;}
. {return yytext[0];}
