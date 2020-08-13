#include <iostream>
#include <string>
#include <vector>
#include "SymbolTable.h"

using namespace std;

SymbolTable::SymbolTable() {}
SymbolTable& SymbolTable::initSymbolTable() {
	static SymbolTable singleton; //不能有()  ????
	return singleton;
}
void SymbolTable::insertIdenfr(Entry entry) {
	localIdenfrTable.push_back(entry);
}
void SymbolTable::removeIdenfr() {
	localIdenfrTable.pop_back();
}
void SymbolTable::insertFunc(FuncEntry funcEntry) {
	//funcEntry.getParas() = move(tempParas);
	funcTable.push_back(funcEntry);
	funcTable.back().paras = move(tempParas);
}
void SymbolTable::insertTempParas(VarEntry varEntry ,int type) {
	//type: 1 for paraList, 0 for valueParaList
	tempParas.push_back(varEntry);
	if (type) {
		localIdenfrTable.push_back(varEntry); // 将参数表的变量存入局部变量表
	}	
}
vector<VarEntry> SymbolTable::getTempParas() { return tempParas; }

void SymbolTable::setGlobalIdenfrTable() {
	globalIdenfrTable = move(localIdenfrTable);
}
int SymbolTable::checkDupDefId(string token) {
	for (int i = 0; i < localIdenfrTable.size(); i++) {
		if (localIdenfrTable[i].getName().compare(token) == 0) {
			return 1; //有重名
		}
	}
	return 0; //无重名
}
int SymbolTable::checkDupDefFuncId(string token) {
	for (int i = 0; i < funcTable.size(); i++) {
		if (funcTable[i].getName().compare(token) == 0) {
			return 1; //有重名
		}
	}
	return 0; //无重名
}
int SymbolTable::checkUndefId(string token) {
	for (int i = 0; i < localIdenfrTable.size(); i++) {
		if (localIdenfrTable[i].getName().compare(token) == 0) {
			return 0; //找到定义
		}
	}
	for (int i = 0; i < globalIdenfrTable.size(); i++) {
		if (globalIdenfrTable[i].getName().compare(token) == 0) {
			return 0; //找到定义
		}
	}
	return 1; //未定义
}
int SymbolTable::checkUndefFuncId(string token) {
	for (int i = 0; i < funcTable.size(); i++) {
		if (funcTable[i].getName().compare(token) == 0) {
			return 0; //找到定义
		}
	}
	return 1; //未定义
}
int SymbolTable::checkConstChange(string token) {
	for (int i = 0; i < localIdenfrTable.size(); i++) {
		if (localIdenfrTable[i].getName().compare(token) == 0 
			&& localIdenfrTable[i].getKind() == CONST) {
			return 1; //对常量赋值
		}
	}
	for (int i = 0; i < globalIdenfrTable.size(); i++) {
		if (globalIdenfrTable[i].getName().compare(token) == 0 
			&& globalIdenfrTable[i].getKind() == CONST) {
			return 1; //对常量赋值
		}
	}
	return 0; //对变量赋值
}
int SymbolTable::getIdType(string token) {
	// 1 for int, 2 for char
	int found = 0;
	EntryType type = INT;
	for (int i = 0; i < localIdenfrTable.size(); i++) {
		if (localIdenfrTable[i].getName().compare(token) == 0) {
			type = localIdenfrTable[i].getType();
			found = 1;
			break;
		}
	} // 在局部变量中查询
	if (!found) {
		for (int i = 0; i < globalIdenfrTable.size(); i++) {
			if (globalIdenfrTable[i].getName().compare(token) == 0) {
				type = globalIdenfrTable[i].getType();
				found = 1;
				break;
			}
		}
	} // 在全局变量中查询
	return (type == INT) ? 1 : 2;
}
void SymbolTable::clrLocalIdenfrTable() {
	vector<Entry>().swap(localIdenfrTable);
}
int SymbolTable::checkParaUnmatch(string token) {
	// 1 for NoUnmatch, 2 for TypeUnmatch, 0 for verygood!
	int i;
	for (i = 0; i < funcTable.size(); i++) {
		if (funcTable[i].getName().compare(token) == 0) {
			break;
		}
	}
	int size1 = funcTable[i].getParas().size();
	int size2 = tempParas.size();
	if (size1 != size2) {
		return 1;
	}
	for (int j = 0; j < size1; j++) {
		if ((funcTable[i].getParas())[j].getType() != tempParas[j].getType()) {
			return 2;
		}
	}
	return 0;
}
void SymbolTable::clrTempParas() {
	vector<VarEntry>().swap(tempParas);
}
bool SymbolTable::hasFunc(string name) {
	for (int i = 0; i < funcTable.size(); i++) {
		if (funcTable[i].getName().compare(name) == 0) {
			return true;
		}
	}
	return false;
}
bool SymbolTable::isRetFunc(string name) {
	int i;
	for (i = 0; i < funcTable.size(); i++) {
		if (funcTable[i].getName().compare(name) == 0) {
			break;
		}
	}
	return funcTable[i].getRet();
}


// Entry
Entry::Entry(string aname, EntryKind akind, EntryType atype) {
	name = aname;
	kind = akind; //CONST, VAR, FUNC
	type = atype; //VOID, CHAR, INT, STRING
}
EntryType Entry::getType() { return type; }
EntryKind Entry::getKind() { return kind; }
string Entry::getName() { return name; }

// Variable Entry
VarEntry::VarEntry(string aname, EntryType atype, int adim) : Entry(aname, VAR, atype) {
	dim = adim;
	offset = 0;
}
int VarEntry::getDim() { return dim; }
bool VarEntry::isArray() { return (dim != 0); }
void VarEntry::setOffset(int aoffset) { offset = aoffset; }

// Const Entry
ConstEntry::ConstEntry(string aname, EntryType atype, int avalue) : Entry(aname, CONST, atype) {
	value = avalue;
}
int ConstEntry::getValue() { return value; }


// Function Entry
FuncEntry::FuncEntry(string aname, EntryType atype, bool aret) : Entry(aname, FUNC, atype) {
	ret = aret;
}
vector<VarEntry> FuncEntry::getParas() { return paras; }
bool FuncEntry::getRet() { return ret; }