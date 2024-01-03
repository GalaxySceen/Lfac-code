#include <iostream>
#include <vector>
#include <cstring>
using namespace std;
class IdList 
{ private:

    vector<string> isConst;
    vector<string> types;  
    vector<string> names; 
    vector<string> values;
    vector<string> whereisdefined;

public:

    bool existsVar(const char* s);
    void addVar(const char* type, const char* name, const char* isConst, const char* value ,const char* where);
    bool checkVarType(const string& type, const string& id, const string& expr);
    void printVars();
    ~IdList();

};
