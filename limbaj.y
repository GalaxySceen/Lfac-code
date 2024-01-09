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
%token IF
%token ELSE
%token<string>REL_OP
%token<intValue>NUMBER
%start progr
%left '[' '{'
%right ']' '}'
%left '+' '-' 
%left '*'
%%

progr: declarations block { printf("The program is correct!\n"); };
block : BGIN list END;
list : statement ';' | list statement ';';
statement: ID '(' call_list ')' 
         | decl ';'
         | if_statement
          //| argument, nu merge tot
         ;
call_list : NR | call_list ',' NR;

declarations : decl ';' | declarations decl ';';

if_statement: IF '(' condition ')' blockif       
;

blockif: ID ASSIGN 

decl: TYPE ID {
              if (Sname!=NULL)
                 if(!ids.existsVarStruct($2,Sname)) 
                     ids.addStructVariables($1, $2, "false", "undefined", Sname);
               if (!ids.existsVar($2)) 
                  ids.addVar($1, $2, "false", "0", "global");
              }
    | CONST TYPE ID 
              {
                   if (Sname!=NULL)
                 if(!ids.existsVarStruct($3,Sname)) 
                     ids.addStructVariables($2, $3, "true", "undefined", Sname);
               if (!ids.existsVar($3)) 
                  ids.addVar($2, $3, "true", "0", "global");
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
    | TYPE ID ASSIGN expression
    ;


define: ID ASSIGN NR ';'
        | ID ASSIGN ID ';'
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

expression: ID array_dimensions //adauga NR + logic in plus
          | NR
          ;

condition: expression REL_OP expression
        | expression
;

/* argument: ID ASSIGN ID PLUS NR
            {cout<<"raaaaaa"<<endl;}
        | ID ASSIGN ID PLUS ID
        | ID ASSIGN ID '*' NR
        | ID ASSIGN ID '*' ID
        | ID ASSIGN ID '-' NR
        | ID ASSIGN ID '-' ID
        | ID ASSIGN ID '/' NR
        | ID ASSIGN ID '/' ID
;    */
       

list_param : param | list_param ',' param;

param : TYPE ID
{
    // cout<<Fname<<endl;
    //Fname=strdup($2);
    if(Fname!=NULL)
    {
        ids.addParam($1, $2, "false","undefined", Fname);
        //cout << "The parameter " << $2 << " is declared in the function " << Fname <<endl;
    }
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