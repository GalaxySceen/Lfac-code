#include <iostream>
#include "IdList.h"
#include <cstring>
#include <stdbool.h>
using namespace std;

void IdList::addVar(const char* type, const char* name, const char* isconst, const char* value, const char* where) 
{
    // Add the type, name, and isConst information
    types.push_back(type);
    names.push_back(name);
    isConst.push_back(isconst);
    whereisdefined.push_back(where);
    if (strcmp(type, "int") == 0) 
        values.push_back(to_string(atoi(value))); 
    else if (strcmp(type, "char") == 0 || strcmp(type, "string") == 0) 
    {
        values.push_back(value);
    } 
    else if (strcmp(type, "bool") == 0) 
    {
        if (strcmp(value, "true") == 0 || strcmp(value, "false") == 0) 
            values.push_back(value);
    } 
}


bool IdList::existsVar(const char* s) 
{
    string strvar = string(s);
    for (const string& name : names) {
        if (strvar == name) {
            return true;
        }
    }
    return false;
}

void IdList::printVars()  
{
    for (size_t i = 0; i < names.size(); ++i) {
        cout << "Name: " << names[i] << ", Type: " << (isConst[i] == "true" ? "const " : "") << types[i] << ", Value: " << values[i] << ", Defined: " << whereisdefined[i] << endl;
    }
}

bool IdList::checkVarType(const string& type, const string& id, const string& expr)
{
    size_t index = 0;
    bool variableFound = false;

    for (; index < names.size(); ++index) {
        if (id == names[index]) {
            variableFound = true;
            break;
        }
    }

    if (!variableFound) {
        cout << "Variable " << id << " not declared." << endl;
        return false;
    }

    if (types[index] != expr) {
        cout << "Type mismatch for variable " << id << ". Expected type: " << types[index] << ", Actual type: " << expr << endl;
        return false;
    }

    return true;
}

void IdList:: addVarVector(const char* type, const char* name, const char* isconst, const char* value ,const char* where)
{
    string Arr = "Array of ";
    if(value[0]=='-')
        cout<<"Error: Array size cannot be negative"<<endl;
    const char* typeString = (Arr + type).c_str();
    types.push_back(typeString);
    names.push_back(name);
    isConst.push_back(isconst);
    whereisdefined.push_back(where);
    values.push_back(value);
}

void IdList::addVarFunction(const char* type, const char* name, const char* isconst, const char* value ,const char* where)
{
    string Func = "Function ";
    const char* typeString = (Func + type).c_str();
    types.push_back(typeString);
    names.push_back(name);
    isConst.push_back(isconst);
    whereisdefined.push_back(where);
    values.push_back(value);
}

void IdList::addParam(const char* type, const char* name, const char* isconst, const char* value ,const char* where)
{
    string Func = "Parameter to function ";
    string rez=Func+where;
    const char* typeString = rez.c_str();
    //cout<<typeString<<endl;
    types.push_back(type);
    names.push_back(name);
    isConst.push_back(isconst);
    whereisdefined.push_back(typeString);
    values.push_back(value);
}


const char* IdList::getValue(const char* s) 
{
    string strvar = string(s);
    for (size_t i = 0; i < names.size(); ++i) 
    {
        if (strvar == names[i]) 
        {
            if(whereisdefined[i]=="Global")
                return values[i].c_str();
        }
    }
    return "";
}
void IdList:: addVarStruct(const char* type, const char* name, const char* isconst, const char* value ,const char* where)
{
    types.push_back(type);
    names.push_back(name);
    isConst.push_back(isconst);
    whereisdefined.push_back(where);
    values.push_back(value);
}

void IdList::addStructVariables(const char* type, const char* name, const char* isconst, const char* value ,const char* where)
{
    string Func = "Variable of struct ";
    string rez=Func+where;
    const char* typeString = rez.c_str();
    types.push_back(type);
    names.push_back(name);
    isConst.push_back(isconst);
    whereisdefined.push_back(typeString);
    values.push_back(value);
}

bool IdList::existsVarStruct(const char* s,const char* w) 
{
    string strvar = string(s);
    string wherevar= string(w);
    wherevar="Variable of struct "+wherevar;
    int i=0;
    for (const string& name : names) 
    {
        
        if (strvar == name)
           if(wherevar == whereisdefined[i])
             return true;
        i++;
    }
    return false;
}

void IdList::switchValue(const char* s,const char* v) 
{
    string strvar = string(s);
    string strval = string(v);
    for (size_t i = 0; i < names.size(); ++i) 
    {
        if (strvar == names[i]) 
        {
            values[i]=strval;
        }
    }
}

IdList::~IdList() 
{

}

bool isDigit(char c)
{
    return std::isdigit(static_cast<unsigned char>(c)) != 0;
}

bool isOperator(char c) 
{
    return c == '+' || c == '-' || c == '*' || c == '/';
}

bool evaluateExpression(const string& expression) 
{
    int operand1 = 0;
    int operand2 = 0;
    char op = '\0';

    size_t i = 0;

    while (i < expression.size() && isDigit(expression[i])) {
        operand1 = operand1 * 10 + (expression[i] - '0');
        i++;
    }

    if (i < expression.size() && isOperator(expression[i])) {
        op = expression[i];
        i++;
    } else {
        return false;
    }
    while (i < expression.size() && isDigit(expression[i])) {
        operand2 = operand2 * 10 + (expression[i] - '0');
        i++;
    }

    if (i + 1 < expression.size() && expression[i] == '=' && isDigit(expression[i + 1])) {
        int result = expression[i + 1] - '0';
        switch (op) {
            case '+':
                return (operand1 + operand2) == result;
            case '-':
                return (operand1 - operand2) == result;
            case '*':
                return (operand1 * operand2) == result;
            case '/':
                return operand2 != 0 && (operand1 / operand2) == result;
            default:
                return false;
        }
    }
    return true;
}

const char* adunare(const char* a, const char* b) 
{
    int num1 = atoi(a);
    int num2 = atoi(b);

    int sum = num1 + num2;
    char result[20];  
    char* result_str = strdup(result);
    return result_str;
}