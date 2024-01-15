%{
#include <iostream>
#include "IdList.h"
#include <fstream>
#include <stdbool.h>
#include <string.h>
extern FILE* yyin;
extern char* yytext;
extern int yylineno;
extern int yylex();
void yyerror(const char * s);
class IdList ids;
ofstream f("output.txt");
using namespace std;
char* Fname=NULL;
char* Sname=NULL;
%}

%union {
    char* string;
    int intValue;
    float floatValue; 
}

%token BGIN END ASSIGN CONST BOOL BOOLRESPONSE
%token<intValue>NR 
%token<floatValue>FLOAT
%token<string> ID TYPE STRUCT
%token IF ELSE
%token<string>REL_OP
%token<intValue>NUMBER
%start progr
%left '['
%right ']'
%left '+' '-' 
%left '*'
%%

progr: declarations block { printf("The program is correct!\n"); };
block : BGIN list END;
list : statement ';' | list statement ';';
statement: ID '(' call_list ')' 
         | decl ';'
         | if_statement
         | ID ASSIGN NR
         ;
call_list : NR | call_list ',' NR;

declarations : decl ';' | declarations decl ';';

if_statement: IF '(' condition ')' blockif;

blockif: ID ASSIGN NR

decl: TYPE ID {
               if (Sname!=NULL)
                 if(!ids.existsVarStruct($2,Sname)) 
                     ids.addStructVariables($1, $2, "false", "undefined", Sname);
               if (!ids.existsVar($2)) 
                  ids.addVar($1, $2, "false", "undefined", "global");
                
              }
    | CONST TYPE ID 
              {
              if (Sname!=NULL)
                 if(!ids.existsVarStruct($3,Sname)) 
                     ids.addStructVariables($2, $3, "true", "undefined", Sname);
               if (!ids.existsVar($3)) 
                  ids.addVar($2, $3, "true", "undefined", "global");
              }
    | TYPE ID ASSIGN NR
    {
         if (Sname!=NULL)
            if(!ids.existsVarStruct($2,Sname)) 
                ids.addStructVariables($1, $2, "false", to_string($4).c_str(), Sname);
         if (!ids.existsVar($2)) 
              ids.addVar($1, $2, "false", to_string($4).c_str(), "global");
    
    }
    | CONST TYPE ID ASSIGN NR
     {
        if (Sname!=NULL)
            if(!ids.existsVarStruct($3,Sname)) 
                  ids.addStructVariables($2, $3, "true", to_string($5).c_str(), Sname);
       if (!ids.existsVar($3)) 
        ids.addVar($2, $3, "true", to_string($5).c_str(), "global");
    }
    |TYPE ID array_dimensions 
    {  
        if (Sname!=NULL)
            if(!ids.existsVarStruct($2,Sname)) 
                ids.addStructVariables($1, $2, "false", "is ambiguous", Sname);
        if (!ids.existsVar($2)) 
            ids.addVarVector($1, $2, "false", "is ambiguous", "global");   
    }
    | TYPE ID '(' ')'
    {
        if(!ids.existsVar($2))
            ids.addVarFunction($1, $2, "false", "is ambiguous", "global");
    }  
    | TYPE ID '(' {Fname=strdup($2);} list_param ')' '{' define '}' 
    {
        if (!ids.existsVar($2)) 
        {
            ids.addVarFunction($1, $2, "false", "is ambiguous", "global"); 
            // cout << "Function " << Fname << " is declared" << endl; 
        }
    }
    | STRUCT ID  '{' {Sname= $2;}declarations '}'
    {   
        if (!ids.existsVar($2)) ids.addVarStruct($1, $2, "false", "is ambiguous", "global");
    }
    ;

array_dimensions: '[' NR ']' %prec '['
                {
                    if(NR<0)
                        cout<<"Error: Array size must be positive"<<endl;
                }
                | '[' NR ']' array_dimensions %prec '['
                {
                    if(NR<0)
                        cout<<"Error: Array size must be positive"<<endl;
                }
                | '[' ']' %prec '['
                | '['']' array_dimensions %prec '['
                ;

define: ID ASSIGN NR ';'
        | ID ASSIGN ID ';'
;

condition: expression REL_OP expression
          |expression 
;

/* argument: ID ASSIGN ID '+' NR
        | ID ASSIGN ID '+' ID
        | ID ASSIGN ID '*' NR
        | ID ASSIGN ID '*' ID
        | ID ASSIGN ID '-' NR
        | ID ASSIGN ID '-' ID
        | ID ASSIGN ID '/' NR
        | ID ASSIGN ID '/' ID    */
       
expression: ID array_dimensions
          | NR
          ;

list_param : param | list_param ',' param;

param : TYPE ID
{
    if(Fname!=NULL)
        ids.addParam($1, $2, "false","undefined", Fname);
};

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