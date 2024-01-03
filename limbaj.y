%{
#include <iostream>
#include "IdList.h"
#include <fstream>
#include <stdbool.h>
#include <string>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
extern int yylex();
void yyerror(const char * s);
class IdList ids;
ofstream f("output.txt");
using namespace std;

%}

%union {
    char* string;
    int intValue;
    float floatValue;
}

%token BGIN END ASSIGN CONST BOOL BOOLRESPONSE
%token<intValue>NR 
%token<floatValue>FLOAT
%token<string> ID TYPE
%start progr
%left '['
%right ']'
%%

progr: declarations block { printf("The program is correct!\n"); };
block : BGIN list END;
list : statement ';' | list statement ';';
statement: ID '(' call_list ')' 
         | decl ';'
         ;
call_list : NR | call_list ',' NR;

declarations : decl ';' | declarations decl ';';

decl: TYPE ID {
               if (!ids.existsVar($2)) 
                  ids.addVar($1, $2, "false", "0", "global");
              }
    | CONST TYPE ID 
              {
               if (!ids.existsVar($3)) 
                  ids.addVar($2, $3, "true", "0", "global");
              }
    | TYPE ID ASSIGN NR
    {
       if (!ids.existsVar($2)) 
        ids.addVar($1, $2, "false", to_string($4).c_str(), "global");
    
    }
    | CONST TYPE ID ASSIGN NR
     {
       if (!ids.existsVar($2)) 
        ids.addVar($2, $3, "true", to_string($5).c_str(), "global");
    }
    |TYPE ID array_dimensions //aici trebuie verificat addVarul ca vreau sa ii dau is ambigour
{
    if (!ids.existsVar($2)) 
    {
        std::string Arr = "Array of ";
        const char* typeString = (Arr + $1).c_str();
        std::cout << "Debug: Type string: " << typeString << std::endl;


        char* idString = strdup($2);  // Make a copy of $2

        ids.addVar(typeString, idString, "false", "is ambiguous", "global");

}
}


    | TYPE ID '(' list_param ')' 
    | TYPE ID '(' ')'  
    | BOOL ID
    | TYPE ID ASSIGN expression
    ;

array_dimensions: '[' NR ']' %prec '['
                | '[' NR ']' array_dimensions %prec '['
                | '[' ']' %prec '['
                | '['']' array_dimensions %prec '['
                ;

expression: ID array_dimensions //adauga NR + logic in plus
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
    cout << "Variables:" << endl;
    ids.printVars();
    f.close();
}