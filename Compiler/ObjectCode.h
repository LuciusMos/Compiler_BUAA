#pragma once
#include <fstream>
//#include "IMCode.h"
#include "SymbolTable.h"
using namespace std;

class ObjectCode
{
public:
	static ObjectCode& initObjectCode(ofstream& fmips, IMCode& aimcode, SymbolTable& asymbolTable);
	void genMips();
	void sReg_paraInFuncCall();
private:
	ofstream& outputFile;
	IMCode& imCode;
	SymbolTable& symbolTable;
	vector<IMCodeEntry*> IMCodeTable;
	//vector<Block*> blockTable;
	vector<glbString> glbStrings;
	ObjectCode(ofstream& fmips, IMCode& aimcode, SymbolTable& asymbolTable);
	void genString();
	//string loadToReg(IMItem* item, string regName, bool mustLoad);
	//void storeToMem(IMItem* item, string reg, bool mustStore);
	string loadToReg(IMItem item, string regName, bool mustFromMem, bool mustToReg);
	void storeToMem(IMItem item, string reg, bool mustToReg, bool mustToMem);
	map<IMOpType, string> branch_Op2String = {
		{IMOpType::Beq, "beq"}, {IMOpType::Bne, "bne"},
		{IMOpType::Bge, "bge"}, {IMOpType::Bgt, "bgt"},
		{IMOpType::Ble, "ble"}, {IMOpType::Blt, "blt"}
	};
	void replacedIMItemJudge(IMItem replacedItem, string replacedReg, int j);
};

