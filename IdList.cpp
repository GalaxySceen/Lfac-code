#include <iostream>
#include "IdList.h"
using namespace std;

void IdList::addVar(const char* type, const char* name)
 {
    types.push_back(string(type));
    names.push_back(string(name));
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
         cout<< "Name: " << names[i] << ", Type: " << types[i] << endl;
    }
}


IdList::~IdList() 
{

}




