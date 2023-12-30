#include <iostream>
#include <vector>
#include <string>
using namespace std;
class IdList 
{
    vector<string> types;  
    vector<string> names; 
    vector<string> value;
    vector<string> whereisdefined;

public:
    bool existsVar(const char* s);
    void addVar(const char* type, const char* name);
    void printVars();
    ~IdList();
};
