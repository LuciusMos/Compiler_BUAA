#pragma once
#include <string>
#include <vector>
#include <fstream>
#include <map>
#include <set>
#include "type.h"
using namespace std;

#define FLOWER_ORIENTED

class IMCode;
class IMCodeEntry;
class IMItem;
class Block;
class SymbolTable;
class Entry;
class VarEntry;
class ConstEntry;
class FuncEntry;

extern set<IMItem> regParas;
extern map<IMItem, string> imSVar2Reg;
extern map<IMItem, string> imTVar2Reg;
extern int sRegNum;
extern int tRegNum;
extern vector<string> sRegPool;
extern vector<string> tRegPool;

extern map<IMOpType, IMOpType> inverseBranchOpMap;
extern map<IMOpType, IMOpType> BranchOpConstMap;

extern map<string, Block*> inlinableFuncName2Block;

struct glbString {
	string name;
	string value;
};

// 优化
extern map<string, bool> funcIsLeaf;

//中间代码
class IMCode
{
private:
	IMCode(ofstream& fold, ofstream& fnew, SymbolTable& asymbolTable);
	vector<IMCodeEntry*> IMCodeTable;
	vector<IMCodeEntry*> newIMCodeTable;
	vector<Block*> blockTable;
	ofstream& oldIMFile;
	ofstream& newIMFile;
	SymbolTable& symbolTable;
	vector<glbString> glbStrings;
	void judgeLeafFunc();
	void insertProtectEnvOp();
	void cutBlocks();
	void genConflictGraph();
	void colorizeConflictGraph();
	void allocSTReg();
	void IM_modDetect();
	void IM_selfOp();
	void IM_imm2Second();
	void IM_eraseUseless();
	void IM_inline();
	void genNewIMCodeTableFromBlock();
	void genNewIMCodeTableFromIM();
public:
	static IMCode& initIMCode(ofstream& fold, ofstream& fnew, SymbolTable& asymbolTable);
	void insertIMCodeEntry(IMCodeEntry* aimoced);
	void outputBlock();
	void outputOld();
	void outputNew();
	vector<IMCodeEntry*> getIMCodeTable() { return IMCodeTable; }
	vector<IMCodeEntry*> getNewIMCodeTable() { return newIMCodeTable; }
	vector<Block*> getBlockTable() { return blockTable; }
	void pushGlbString(glbString temp) { glbStrings.push_back(temp); }
	vector<glbString> getGlbString() { return glbStrings; }
	void optimize();

};

//四元式的操作数
class IMItem
{
private:
	string name;
	IMItemKind kind; //Const, GlbVar, LcVar, TempVar, Func, String
	int value; //Const:值, Var:偏移, TempVar:偏移
	EntryType type;
	string funcName;
public:
	friend class IMCodeEntry;
	friend class IMItemComparator;
	IMItem() : name("emm"), kind(IMItemKind::String), value(0), type(EntryType::STRING), funcName("666") {}
	IMItem(string aname, IMItemKind akind, EntryType atype, int avalue = 0, string afuncName = "--NotVar--");
	IMItem(const IMItem& newItem) : name(newItem.name), kind(newItem.kind), value(newItem.value), type(newItem.type), funcName(newItem.funcName) {}
	string toString() const;
	IMItemKind getKind() const { return kind; }
	int getValue() { return value; }
	string getName() { return name; }
	EntryType getType() { return type; }
	string getFuncName() const { return funcName; }
	void setType(EntryType newType) { type = newType; }
	bool operator < (const IMItem& cmp) const {
		/*
		if (this->name.compare(cmp.name) < 0) {
			return true;
		} else if (this->name.compare(cmp.name) == 0 && this->kind < cmp.kind) {
			return true;
		} else if (this->name.compare(cmp.name) == 0 && this->kind == cmp.kind 
			&& this->value < cmp.value) {
			return true;
		} else if (this->name.compare(cmp.name) == 0 && this->kind == cmp.kind
			&& this->value == cmp.value && this->type < cmp.type){
			return true;
		} else if (this->name.compare(cmp.name) == 0 && this->kind == cmp.kind
			&& this->value == cmp.value && this->type == cmp.type
			&& this->funcName.compare(cmp.funcName) < 0) {
			return true;
		}
		return false;
		*/
		if (this->name != cmp.name) 
			return (this->name < cmp.name);
		if (this->kind != cmp.kind)
			return (this->kind < cmp.kind);
		if (this->value != cmp.value)
			return (this->value < cmp.value);
		if (this->type != cmp.type)
			return (this->type < cmp.type);
		if (this->funcName != cmp.funcName)
			return (this->funcName < cmp.funcName);
		return false;
	}
	bool equalsTo(IMItem anItem) {
		if (this->name.compare(anItem.name) == 0 && this->kind == anItem.kind
			&& this->value == anItem.value && this->type == anItem.type
			&& this->funcName.compare(anItem.funcName) == 0) {
			return true;
		} else {
			return false;
		}
		/*
		if (*this < anItem == false && anItem < *this == false) {
			return true;
		} else {
			return false;
		}*/
	}
};
/*
class IMItemComparator {
public:
	bool operator()(const IMItem& item1, const IMItem& item2) const {
		if (item1.name.compare(item2.name) < 0) {
			return true;
		} else if (item1.name.compare(item2.name) == 0 && item1.kind < item2.kind) {
			return true;
		} else if (item1.name.compare(item2.name) == 0 && item1.kind == item2.kind 
			&& item1.value < item2.value) {
			return true;
		} else if (item1.name.compare(item2.name) == 0 && item1.kind == item2.kind 
			&& item1.value == item2.value && item1.type < item2.type) {
			return true;
		} else if (item1.name.compare(item2.name) == 0 && item1.kind == item2.kind
			&& item1.value == item2.value && item1.type == item2.type
			&& item1.funcName.compare(item2.funcName) < 0) {
			return true;
		}
		return false;
	}
};*/


//四元式
class IMCodeEntry
{
private:
	IMOpType op;
	IMItem* item1 = NULL;
	IMItem* item2 = NULL;
	IMItem* item3 = NULL;
	bool isInline = false;
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
	void setItem2(IMItem* newItem) { item2 = newItem; }
	void swapItem12() {
		IMItem* temp = item1;
		item1 = item2;
		item2 = temp;
	}
	void setOp(IMOpType newOp) { op = newOp; }
	void setItem3(IMItem* newItem) { item3 = newItem; }
	void setIsInline(bool temp) { isInline = temp; }
	bool getIsInline() { return isInline; }
};

//基本块
class Block {
private:
	int blockNo;
	string begin;
	string next;
	set<int> prevBlocksNo;
	set<int> followBlocksNo;
	set<IMItem> def;
	set<IMItem> use;
	set<IMItem> in;
	set<IMItem> out;
	vector<IMCodeEntry*> imCodesInBlock;
	
public:
	Block() {}
	Block(int aNo) : blockNo(aNo) {}
	Block(int aNo, set<IMItem> adef, set<IMItem> ause, string abegin, string anext, vector<IMCodeEntry*> ims) {
		blockNo = aNo;
		def = move(adef);
		use = move(ause);
		begin = abegin;
		next = anext;
		imCodesInBlock = move(ims);
	}
	void insertPrevBlocksNo(int no) { prevBlocksNo.insert(no); }
	void insertFollowBlocksNo(int no) { followBlocksNo.insert(no); }
	void setBegin(string be) { begin = be; }
	void setNext(string ne) { next = ne; }
	void setIMCodesInBlock(vector<IMCodeEntry*> ims) { imCodesInBlock = move(ims); }
	int getBlockNo() { return blockNo; }
	string getBegin() { return begin; }
	string getNext() { return next; }
	set<int> getPrevBlocksNo() { return prevBlocksNo; }
	set<int> getFollowBlocksNo() { return followBlocksNo; }
	set<IMItem> getDef() { return def; }
	set<IMItem> getUse() { return use; }
	set<IMItem> getIn() { return in; }
	set<IMItem> getOut() { return out; }
	vector<IMCodeEntry*> getIMCodesInBlock() { return imCodesInBlock; }
	// setOut & setIn return: In, Out是否发生改变
	bool setOut(set<IMItem> newOut) {
		if (out.size() < newOut.size()) {
			out = move(newOut);
			return true;
		} else if (out.size() == newOut.size()) {
			return false;
		} else {
			throw "in Block::setOut(), newOut is smaller than out";
		}
	}
	bool setIn(set<IMItem> newIn) {
		if (in.size() < newIn.size()) {
			in = move(newIn);
			return true;
		} else if (in.size() == newIn.size()) {
			return false;
		} else {
			throw "in Block::setIn(), newIn is smaller than in";
		}
	}
	string toString(set<IMItem> temp);
	string toString(set<int> temp);
	void Block_modDetect();
	void Block_selfOp();
	void Block_imm2Second();
	void Block_eraseUseless();
	void Block_inline_jr();
	void Block_inline();
};




