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
    const char* typeString = (Func + where).c_str();
    types.push_back(type);
    names.push_back(name);
    isConst.push_back(isconst);
    whereisdefined.push_back(typeString);
    values.push_back(value);
}


IdList::~IdList() 
{

}




