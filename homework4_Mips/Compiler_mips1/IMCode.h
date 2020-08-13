#pragma once
#include <string>
#include <vector>
#include <fstream>
#include "type.h"
using namespace std;

class IMCode;
class IMCodeEntry;

struct glbString {
	string name;
	string value;
};
//中间代码
class IMCode
{
private:
	IMCode(ofstream& fim);
	vector<IMCodeEntry*> IMCodeTable;
	ofstream& outputFile;
	vector<glbString> glbStrings;
public:
	static IMCode& initIMCode(ofstream& fim);
	void insertIMCodeEntry(IMCodeEntry* aimoced);
	void output();
	vector<IMCodeEntry*> getIMCodeTable() { return IMCodeTable; }
	void pushGlbString(glbString temp) { glbStrings.push_back(temp); }
	vector<glbString> getGlbString() { return glbStrings; }
};

//四元式的操作数
class IMItem
{
private:
	string name;
	IMItemKind kind; //Const, GlbVar, LcVar, TempVar, Func, String
	int value; //Const:值, Var:偏移, TempVar:偏移
	EntryType type;
public:
	friend class IMCodeEntry;
	IMItem(string aname, IMItemKind akind, EntryType atype, int avalue = 0);
	string toString();
	IMItemKind getKind() { return kind; }
	int getValue() { return value; }
	string getName() { return name; }
	EntryType getType() { return type; }
	//void setValue(int avalue) { value = avalue; }
};


//四元式
class IMCodeEntry
{
private:
	IMOpType op;
	IMItem* item1 = NULL;
	IMItem* item2 = NULL;
	IMItem* item3 = NULL;
public:
	friend class IMCode;
	IMCodeEntry(IMOpType aop);
	IMCodeEntry(IMOpType aop, IMItem* aitem1);
	IMCodeEntry(IMOpType aop, IMItem* aitem1, IMItem* aitem2);
	IMCodeEntry(IMOpType aop, IMItem* aitem1, IMItem* aitem2, IMItem* aitem3);
	string toString();
	IMOpType getOp() { return op; }
	IMItem* getItem1() { return item1; }
	IMItem* getItem2() { return item2; }
	IMItem* getItem3() { return item3; }
};




