#pragma once
#include <string>
#include <vector>
#include <map>
#include "type.h"
#include "IMCode.h"
using namespace std;

class IMCode;
class IMCodeEntry;
class IMItem;
class Block;

class SymbolTable;
class Entry;
class VarEntry;
class ConstEntry;
class FuncEntry;

class SymbolTable
{
private:
	vector<FuncEntry*> funcTable;
	vector<VarEntry*> tempParas;
	vector<Entry*> localIdenfrTable;
	vector<Entry*> globalIdenfrTable;
	//ErrorHandler& errorHandler;
public:
	SymbolTable();
	static SymbolTable& initSymbolTable();
	vector<VarEntry*> getTempParas() { return tempParas; }
	void insertIdenfr(Entry* entry);
	void insertFunc(FuncEntry* funcEntry);
	//void insertTempParas(VarEntry* varEntry, int type);
	void removeIdenfr();
	void setGlobalIdenfrTable();
	int checkDupDefId(string token);
	int checkDupDefFuncId(string token);
	int checkUndefId(string token);
	int checkUndefFuncId(string token);
	int checkConstChange(string token);
	int getIdType(string token);
	void clrLocalIdenfrTable(FuncEntry* curFuncDefPtr);
	int checkParaUnmatch(string token, vector<VarEntry*>* valueParas);
	//void clrTempParas();
	//void setErrorHandler(ErrorHandler aErrorHander);
	bool hasFunc(string name);
	int getVarOffset(string name, bool varIsGlb); //false:local, true:global
	bool isVarGlobal(string name);
	FuncEntry* getFuncPtr(string name);
	IMItem* findIMItem(string name, FuncEntry* curFuncDefPtr);
	vector<Entry*> getGlobalIdenfrTable() { return globalIdenfrTable; }
	EntryType findFuncRetType(string name);
	set<IMItem> getRegParas();
	void insertSVar2RegIntoFuncTable();
};




class Entry {
private:
	string name;
	EntryKind kind; //CONST, VAR, FUNC
	EntryType type; //VOID, CHAR, INT, STRING
public:
	Entry(string aname, EntryKind akind, EntryType atype);
	EntryKind getKind();
	EntryType getType();
	string getName();
	virtual void print();
};

class VarEntry : public Entry {
private:
	int dim;
	int arrSize;
	int offset;
public:
	friend class SymbolTable;
	VarEntry(string aname, EntryType atype, int asize, int aoffset);
	int getDim();
	bool isArray();
	void setOffset(int aoffset);
	int getVarOffset();
};

class ConstEntry : public Entry {
private:
	int value;
public:
	friend class SymbolTable;
	ConstEntry(string aname, EntryType atype, int avalue) : Entry(aname, CONST, atype), value(avalue) {}
	int getValue() { return value; }
};

class FuncEntry : public Entry {
private:
	vector<VarEntry*> paras;
	vector<Entry*> idenfrTable;
	map<IMItem, string> aVar2Reg;
	map<IMItem, string> sVar2Reg;
public:
	friend class SymbolTable;
	FuncEntry(string aname, EntryType atype) : Entry(aname, FUNC, atype) {}
	vector<VarEntry*> getParas() { return paras; }
	EntryType getRetType() { return this->getType(); }
	void insertFuncParas(VarEntry* varEntry) { paras.push_back(varEntry); }

	string getVarReg(IMItem item);
	void insertAVar2Reg(pair<IMItem, string> temp) { aVar2Reg.insert(temp); }
	map<IMItem, string> getAVar2RegMap() { return aVar2Reg; }
	void insertSVar2Reg(pair<IMItem, string> temp) { sVar2Reg.insert(temp); }
	map<IMItem, string> getSVar2RegMap() { return sVar2Reg; }
	
};
