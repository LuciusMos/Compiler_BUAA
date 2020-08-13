#pragma once
#include <fstream>
#include "IMCode.h"
#include "SymbolTable.h"
using namespace std;

class ObjectCode
{
public:
	static ObjectCode& initObjectCode(ofstream& fmips, IMCode& aimcode, SymbolTable& asymbolTable);
	void genMips();
	
private:
	ofstream& outputFile;
	IMCode& imCode;
	SymbolTable& symbolTable;
	vector<IMCodeEntry*> IMCodeTable;
	vector<glbString> glbStrings;
	ObjectCode(ofstream& fmips, IMCode& aimcode, SymbolTable& asymbolTable);
	void genString();
	string loadToReg(IMItem* item, string regName);
	void storeToMem(IMItem* item, string reg);
};

