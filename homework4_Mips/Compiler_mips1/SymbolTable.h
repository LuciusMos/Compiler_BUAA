#pragma once
#include <string>
#include <vector>
#include "type.h"
#include "IMCode.h"
using namespace std;

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
	vector<VarEntry*> getTempParas();
	void insertIdenfr(Entry* entry);
	void insertFunc(FuncEntry* funcEntry);
	void insertTempParas(VarEntry* varEntry, int type);
	void removeIdenfr();
	void setGlobalIdenfrTable();
	int checkDupDefId(string token);
	int checkDupDefFuncId(string token);
	int checkUndefId(string token);
	int checkUndefFuncId(string token);
	int checkConstChange(string token);
	int getIdType(string token);
	void clrLocalIdenfrTable(FuncEntry* curFuncDefPtr);
	int checkParaUnmatch(string token);
	void clrTempParas();
	//void setErrorHandler(ErrorHandler aErrorHander);
	bool hasFunc(string name);
	int getVarOffset(string name, bool varIsGlb); //false:local, true:global
	bool isVarGlobal(string name);
	FuncEntry* getCurFunDefPtr();
	IMItem* findIMItem(string name);
	vector<Entry*> getGlobalIdenfrTable() { return globalIdenfrTable; }
	EntryType findFuncRetType(string name);
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
	//virtual int getVarOffset();
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
	ConstEntry(string aname, EntryType atype, int value);
	int getValue();
};

class FuncEntry : public Entry {
private:
	vector<VarEntry*> paras;
	vector<Entry*> idenfrTable;
public:
	friend class SymbolTable;
	FuncEntry(string aname, EntryType atype);
	vector<VarEntry*> getParas();
	EntryType getRetType();
};
