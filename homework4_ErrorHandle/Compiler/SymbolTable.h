#pragma once
#include <iostream>
#include <string>
#include <vector>
#include "type.h"
//#include "ErrorHandler.h"
//#include "LexicalAnalyzer.h"
using namespace std;

class Entry;
class VarEntry;
class ConstEntry;
class FuncEntry;

/*
extern vector<FuncEntry> funcTable;
extern vector<Entry> localIdenfrTable;
extern vector<Entry> globalIdenfrTable;
*/

class SymbolTable
{
private:
	vector<FuncEntry> funcTable;
	vector<VarEntry> tempParas;
	vector<Entry> localIdenfrTable;
	vector<Entry> globalIdenfrTable;
	//ErrorHandler& errorHandler;
public:
	SymbolTable();
	static SymbolTable& initSymbolTable();
	vector<VarEntry> getTempParas();
	void insertIdenfr(Entry entry);
	void insertFunc(FuncEntry funcEntry);
	void insertTempParas(VarEntry varEntry, int type);
	void removeIdenfr();
	void setGlobalIdenfrTable();
	int checkDupDefId(string token);
	int checkDupDefFuncId(string token);
	int checkUndefId(string token);
	int checkUndefFuncId(string token);
	int checkConstChange(string token);
	int getIdType(string token);
	void clrLocalIdenfrTable();
	int checkParaUnmatch(string token);
	void clrTempParas();
	//void setErrorHandler(ErrorHandler aErrorHander);
	bool hasFunc(string name);
	bool isRetFunc(string name);
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
};

class VarEntry : public Entry {
private:
	int dim;
	int offset;
public:
	friend class SymbolTable;
	VarEntry(string aname, EntryType atype, int adim);
	int getDim();
	bool isArray();
	void setOffset(int aoffset);
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
	bool ret; //true for return, false for non-return
	vector<VarEntry> paras;
public:
	friend class SymbolTable;
	FuncEntry(string aname, EntryType atype, bool ret);
	vector<VarEntry> getParas();
	bool getRet();
};
