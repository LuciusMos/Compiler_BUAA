#include <iostream>
#include <string>
#include <vector>
#include "SymbolTable.h"

using namespace std;

SymbolTable::SymbolTable() {
}
SymbolTable& SymbolTable::initSymbolTable() {
	static SymbolTable singleton; //不能有()  ????
	return singleton;
}
void SymbolTable::insertIdenfr(Entry* entry) {
	localIdenfrTable.push_back(entry);
}
void SymbolTable::removeIdenfr() {
	localIdenfrTable.pop_back();
}
void SymbolTable::insertFunc(FuncEntry* funcEntry) {
	funcTable.push_back(funcEntry);
	//funcTable.back()->paras = move(tempParas);
}
/*
void SymbolTable::insertTempParas(VarEntry* varEntry, int type) {
	//type: 1 for paraList, 0 for valueParaList
	tempParas.push_back(varEntry);
	if (type) {
		localIdenfrTable.push_back(varEntry); // 将参数表的变量存入局部变量表
	}	
}*/
void SymbolTable::setGlobalIdenfrTable() {
	globalIdenfrTable = move(localIdenfrTable);
}
int SymbolTable::checkDupDefId(string token) {
	for (int i = 0; i < localIdenfrTable.size(); i++) {
		if (localIdenfrTable[i]->getName().compare(token) == 0) {
			return 1; //有重名
		}
	}
	return 0; //无重名
}
int SymbolTable::checkDupDefFuncId(string token) {
	for (int i = 0; i < funcTable.size(); i++) {
		if (funcTable[i]->getName().compare(token) == 0) {
			return 1; //有重名
		}
	}
	return 0; //无重名
}
int SymbolTable::checkUndefId(string token) {
	for (int i = 0; i < localIdenfrTable.size(); i++) {
		if (localIdenfrTable[i]->getName().compare(token) == 0) {
			return 0; //找到定义
		}
	}
	for (int i = 0; i < globalIdenfrTable.size(); i++) {
		if (globalIdenfrTable[i]->getName().compare(token) == 0) {
			return 0; //找到定义
		}
	}
	return 1; //未定义
}
int SymbolTable::checkUndefFuncId(string token) {
	for (int i = 0; i < funcTable.size(); i++) {
		if (funcTable[i]->getName().compare(token) == 0) {
			return 0; //找到定义
		}
	}
	return 1; //未定义
}
int SymbolTable::checkConstChange(string token) {
	for (int i = 0; i < localIdenfrTable.size(); i++) {
		if (localIdenfrTable[i]->getName().compare(token) == 0) {
			if (localIdenfrTable[i]->getKind() == CONST) {
				return 1;
			} else {
				return 0;
			}
		}
	}
	for (int i = 0; i < globalIdenfrTable.size(); i++) {
		if (globalIdenfrTable[i]->getName().compare(token) == 0) {
			if (globalIdenfrTable[i]->getKind() == CONST) {
				return 1;
			} else {
				return 0;
			}
		}
	}
	return 0; //对变量赋值
}
int SymbolTable::getIdType(string token) {
	// 1 for int, 2 for char
	int found = 0;
	EntryType type = INT;
	for (int i = 0; i < localIdenfrTable.size(); i++) {
		if (localIdenfrTable[i]->getName().compare(token) == 0) {
			type = localIdenfrTable[i]->getType();
			found = 1;
			break;
		}
	} // 在局部变量中查询
	if (!found) {
		for (int i = 0; i < globalIdenfrTable.size(); i++) {
			if (globalIdenfrTable[i]->getName().compare(token) == 0) {
				type = globalIdenfrTable[i]->getType();
				found = 1;
				break;
			}
		}
	} // 在全局变量中查询
	return (type == INT) ? 1 : 2;
}
void SymbolTable::clrLocalIdenfrTable(FuncEntry* curFuncDefPtr) {
	vector<Entry*> funcLocalIdenfr = move(localIdenfrTable);
	(curFuncDefPtr->idenfrTable).insert((curFuncDefPtr->idenfrTable).end(), 
		funcLocalIdenfr.begin(), funcLocalIdenfr.end());
}
int SymbolTable::checkParaUnmatch(string token, vector<VarEntry*>* valueParas) {
	// 1 for NoUnmatch, 2 for TypeUnmatch, 0 for verygood!
	int i;
	for (i = 0; i < funcTable.size(); i++) {
		if (funcTable[i]->getName().compare(token) == 0) {
			break;
		}
	}
	int size1 = funcTable[i]->getParas().size();
	int size2 = valueParas->size();
	if (size1 != size2) {
		return 1;
	}
	for (int j = 0; j < size1; j++) {
		if ((funcTable[i]->getParas())[j]->getType() != (*valueParas)[j]->getType()) {
			return 2;
		}
	}
	return 0;
}
/*
void SymbolTable::clrTempParas() {
	vector<VarEntry*>().swap(tempParas);
}*/
bool SymbolTable::hasFunc(string name) {
	for (int i = 0; i < funcTable.size(); i++) {
		if (funcTable[i]->getName().compare(name) == 0) {
			return true;
		}
	}
	return false;
}

int SymbolTable::getVarOffset(string name, bool varIsGlb) { //false:local, true:global
	if (varIsGlb == false) {
		for (int i = 0; i < localIdenfrTable.size(); i++) {
			if (localIdenfrTable[i]->getName().compare(name) == 0) {
				VarEntry* varEntryPtr = dynamic_cast<VarEntry*>(localIdenfrTable[i]);
				return varEntryPtr->offset;
			}
		}
	} else if (varIsGlb == true) {
		for (int i = 0; i < globalIdenfrTable.size(); i++) {
			if (globalIdenfrTable[i]->getName().compare(name) == 0) {
				VarEntry* varEntryPtr = dynamic_cast<VarEntry*>(globalIdenfrTable[i]);
				return varEntryPtr->offset;
			}
		}
	}
}
bool SymbolTable::isVarGlobal(string name) {
	for (int i = 0; i < localIdenfrTable.size(); i++) {
		if (localIdenfrTable[i]->getName().compare(name) == 0) {
			return false;
		}
	}
	for (int i = 0; i < globalIdenfrTable.size(); i++) {
		if (globalIdenfrTable[i]->getName().compare(name) == 0) {
			return true;
		}
	}
}
FuncEntry* SymbolTable::getFuncPtr(string name) {
	if (funcTable.back()->getName().compare(name) == 0) {
		return funcTable.back();
	}
	for (int i = 0; i < funcTable.size(); i++) {
		if (funcTable[i]->getName().compare(name) == 0) {
			return funcTable[i];
		}
	}
	throw "in SymbolTable::getCurFunDefPtr(string), no func called name";
	//return funcTable.back();
}
IMItem* SymbolTable::findIMItem(string name, FuncEntry* curFuncDefPtr) {
	EntryType type;
	EntryKind kind;
	IMItemKind itemKind;
	for (int i = 0; i < localIdenfrTable.size(); i++) {
		if (localIdenfrTable[i]->getName().compare(name) == 0) {
			type = localIdenfrTable[i]->getType();
			kind = localIdenfrTable[i]->getKind();
			if (kind == EntryKind::CONST) { 
				itemKind = IMItemKind::Const;
				ConstEntry* constEntryPtr = dynamic_cast<ConstEntry*>(localIdenfrTable[i]);
				int value = constEntryPtr->value;
				return (new IMItem(to_string(value), itemKind, type, value));
			} else { 
				itemKind = IMItemKind::LcVar;
				VarEntry* varEntryPtr = dynamic_cast<VarEntry*>(localIdenfrTable[i]);
				int offset = varEntryPtr->offset;
				return (new IMItem(name, itemKind, type, offset, curFuncDefPtr->getName()));
			}
		}
	} // 在局部变量中查询
	for (int i = 0; i < globalIdenfrTable.size(); i++) {
		if (globalIdenfrTable[i]->getName().compare(name) == 0) {
			type = globalIdenfrTable[i]->getType();
			kind = globalIdenfrTable[i]->getKind();
			if (kind == EntryKind::CONST) {
				itemKind = IMItemKind::Const;
				ConstEntry* constEntryPtr = dynamic_cast<ConstEntry*>(globalIdenfrTable[i]);
				int value = constEntryPtr->value;
				return (new IMItem(to_string(value), itemKind, type, value));
			} else {
				itemKind = IMItemKind::GlbVar;
				VarEntry* varEntryPtr = dynamic_cast<VarEntry*>(globalIdenfrTable[i]);
				int offset = varEntryPtr->offset;
				return (new IMItem(name, itemKind, type, offset));
			}
		}
	}// 在全局变量中查询
}
EntryType SymbolTable::findFuncRetType(string name) {
	int i;
	for (i = 0; i < funcTable.size(); i++) {
		if (funcTable[i]->getName().compare(name) == 0) {
			break;
		}
	}
	return funcTable[i]->getRetType();
}
set<IMItem> SymbolTable::getRegParas() {
	set<IMItem> temp;
	map<IMItem, string> var2Reg;
	map<IMItem, string>::iterator iter;
	for (int i = 0; i < funcTable.size(); i++) {
		var2Reg = funcTable[i]->getAVar2RegMap();
		for (iter = var2Reg.begin(); iter != var2Reg.end(); iter++) {
			temp.insert(iter->first);
		}
	}
	return temp;
}
void SymbolTable::insertSVar2RegIntoFuncTable() {
	for (map<IMItem, string>::iterator iter = imSVar2Reg.begin(); iter != imSVar2Reg.end(); iter++) {
		string funcName = (iter->first).getFuncName();
		FuncEntry* funcPtr = getFuncPtr(funcName);
		funcPtr->insertSVar2Reg(*iter);
	}
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
void Entry::print() { cout << "Entry" << endl; }

// Variable Entry
VarEntry::VarEntry(string aname, EntryType atype, int asize, int aoffset) : Entry(aname, VAR, atype) {
	arrSize = asize;
	dim = (arrSize == 1) ? 0 : 1;
	offset = aoffset;
}
int VarEntry::getDim() { return dim; }
bool VarEntry::isArray() { return (dim != 0); }
void VarEntry::setOffset(int aoffset) { offset = aoffset; }
int VarEntry::getVarOffset() { return offset; }

// Const Entry


// Function Entry
string FuncEntry::getVarReg(IMItem item) {
	if (aVar2Reg.count(item) != 0) {
		return aVar2Reg[item];
	} else if (sVar2Reg.count(item) != 0) {
		return sVar2Reg[item];
	} else if (imTVar2Reg.count(item) != 0){
		return imTVar2Reg[item];
	} else {
		return "NULL";
	}
	/*
	if (var2Reg.count(item) > 0) {
		return var2Reg[item];
	} else {
		return "NULL";
	}*/
}