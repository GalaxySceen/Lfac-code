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
    void addVarVector(const char* type, const char* name, const char* isConst, const char* value ,const char* where);
    bool checkVarType(const string& type, const string& id, const string& expr);
    void printVars();
    void addParam(const char* type, const char* name, const char* isConst, const char* value ,const char* where);
    void addVarFunction(const char* type, const char* name, const char* isConst, const char* value ,const char* where);
    void addVarStruct(const char* type, const char* name, const char* isconst, const char* value ,const char* where);
    void addStructVariables(const char* type, const char* name, const char* isconst, const char* value ,const char* where);
    bool existsVarStruct(const char* s,const char* w);
    const char* getValue(const char* s);
    void switchValue(const char* s,const char* v);
    ~IdList();

};