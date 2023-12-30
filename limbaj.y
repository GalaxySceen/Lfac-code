%{
#include <iostream>
#include "IdList.h"
#include <fstream>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
extern int yylex();
void yyerror(const char * s);
class IdList ids;
ofstream f("output.txt");
%}

%union {
    char* string;
    int intValue;
}

%token BGIN END ASSIGN NR NRNEG FLOAT CONST //Const trebuie facut in fata Type-ului
%token<string> ID TYPE
%start progr
%left '['
%right ']'
%%

progr: declarations block { printf("The program is correct!\n"); };
block : BGIN list END;
list : statement ';' | list statement ';';
statement: ID '(' call_list ')' 
         | ID ASSIGN expression 
         ;
call_list : NR | call_list ',' NR;

declarations : decl ';' | declarations decl ';';

decl: TYPE ID { ids.addVar($1, $2); } //Declarare de tip string x;
    | TYPE ID ASSIGN NR //Declarare de tip int x=15;
    | TYPE ID '(' list_param ')' { ids.addVar($1, $2); }// Declarare de tip string a(parametru 1, parametru 2)
    | TYPE ID '(' ')'  { ids.addVar($1, $2); }// Declarare de tip int x();
    | TYPE ID array_dimensions { ids.addVar($1, $2); }//Declarare de tip int x[] sau int x[100] sau int x[16][12][12][];
    ;

array_dimensions: '[' NR ']' %prec '['
                | '[' NR ']' array_dimensions %prec '['
                | '[' ']' %prec '['
                | '['']' array_dimensions %prec '['
                ;


expression: ID array_dimensions 
          | NR 
          | NRNEG 
          | FLOAT 
          ;

list_param : param | list_param ',' param;

param : TYPE ID;

%%

void yyerror(const char * s){
    printf("error: %s at line:%d\n",s,yylineno);
}

int main(int argc, char** argv)
{
    freopen("output.txt", "w", stdout);
    yyin=fopen(argv[1],"r");
    yyparse();
    std::cout << "Variables:" << std::endl;
    ids.printVars();
    f.close();
}
