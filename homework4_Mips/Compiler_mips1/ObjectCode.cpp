#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include "ObjectCode.h"
using namespace std;

#define DEBUG

ObjectCode& ObjectCode::initObjectCode(ofstream& fmips, IMCode& aimCode, SymbolTable& asymbolTable) {
	static ObjectCode singleton(fmips, aimCode, asymbolTable);
	return singleton;
}
ObjectCode::ObjectCode(ofstream& fmips, IMCode& aimCode, SymbolTable& asymbolTable) 
	: outputFile(fmips), imCode(aimCode), symbolTable(asymbolTable) {
	this->IMCodeTable = imCode.getIMCodeTable();
	/*
	vector<IMCodeEntry*>::iterator it = IMCodeTable.begin();
	//remove ConstDef
	while (it != IMCodeTable.end()) {
		if ((*it)->getOp() == IMOpType::ConstDefChar || (*it)->getOp() == IMOpType::ConstDefInt) {
			it = IMCodeTable.erase(it);
		} else {
			it++;
		}
	}*/
	this->glbStrings = imCode.getGlbString();
	//this->IMCodeTable.assign(imCode.getIMCodeTable().begin(), imCode.getIMCodeTable().end());
	//this->glbStrings.assign(imCode.getGlbString().begin(), imCode.getGlbString().end());
	//this->globalIdenfrTable.assign(symbolTable.getGlobalIdenfrTable().begin(), symbolTable.getGlobalIdenfrTable().end());
}

void ObjectCode::genString() {
	/*------Global String------*/
	outputFile << ".data" << endl;
	//	string0:	.asciiz "c = "
	for (int i = 0; i < glbStrings.size(); i++) {
		outputFile << "\t" << glbStrings[i].name << ":\t" 
			<< ".asciiz \"" << glbStrings[i].value << "\"" <<endl;
	}
	//	newline:	.asciiz "\n"
	outputFile << "\tnewline:\t.asciiz \"\\n\"" << endl;
}

int tempRegNo = -1;

void ObjectCode::genMips() {
	genString();
	//------Global Variable------
	outputFile << ".text" << endl;
	//outputFile << "\tmove\t$gp\t$sp" << endl;
	int i;
	bool hasVarDef = false;
	for (i = 0; i < IMCodeTable.size(); i++) {
		if (IMCodeTable[i]->getOp() != IMOpType::VarDefChar && IMCodeTable[i]->getOp() != IMOpType::VarDefInt) {
			break;
		}
		hasVarDef = true;
	}
	
	if (hasVarDef) {
		//outputFile << "\tsubi\t$sp\t$sp\t" << IMCodeTable[i - 1]->getItem1()->getValue() << endl;
	}
	//outputFile << "\tmove\t$fp\t$sp" << endl;
	outputFile << "\tjal\tmain" << endl;
	outputFile << "\tj\tend" << endl;

	//------After Global Const & Var------
	for (; i < IMCodeTable.size(); i++) {
		IMItem* item1 = IMCodeTable[i]->getItem1();
		IMItem* item2 = IMCodeTable[i]->getItem2();
		IMItem* item3 = IMCodeTable[i]->getItem3();
		IMOpType op = IMCodeTable[i]->getOp();
		tempRegNo = -1;
#ifdef DEBUG
		outputFile << "########\t" << IMCodeTable[i]->toString();
#endif // DEBUG
		switch (op)
		{
		case ConstDefInt:
			break;
		case ConstDefChar:
			break;
		case VarDefInt: 
		case VarDefChar: {
			bool hasVarDef = false;
			for (; i < IMCodeTable.size(); i++) {
				if (IMCodeTable[i]->getOp() != IMOpType::VarDefChar && IMCodeTable[i]->getOp() != IMOpType::VarDefInt) {
					break;
				}
				hasVarDef = true;
			}
			if (hasVarDef) {
				i--;
				//outputFile << "\tsubi\t$sp\t$sp\t" << IMCodeTable[i]->getItem1()->getValue() << endl;
			}
			break;
		}
		case FuncDefInt:
		case FuncDefChar:
		case FuncDefVoid:
			outputFile << item1->getName() << ":" << endl;
			outputFile << "\tsw\t$ra\t-4\t($sp)" << endl;
			break;
		case ParaInFuncDef:
			break;
		case ParaInFuncCall: {
			string reg = loadToReg(IMCodeTable[i]->getItem1(), "temp");
			storeToMem(IMCodeTable[i]->getItem2(), reg);
			break;
		}
		case FuncCall: {
			int size = IMCodeTable[i]->getItem1()->getValue();
			string name = IMCodeTable[i]->getItem2()->getName();
			outputFile << "\tsw\t$sp\t" << to_string(-(size+8)) << "\t($sp)" << endl;
			outputFile << "\tsubi\t$sp\t$sp\t" << to_string(size) << endl;
			outputFile << "\tjal\t" << name << endl;
			outputFile << "\tlw\t$sp\t-8\t($sp)" << endl;
			break;
		}
		case FuncCallRet:
			storeToMem(IMCodeTable[i]->getItem1(), "$v0");
			break;
		case NonRetFuncReturn:
			loadToReg(new IMItem("ra", IMItemKind::LcVar, EntryType::INT, 4), "$ra");
			outputFile << "\tjr\t$ra" << endl;
			break;
		case RetFuncReturn:
			loadToReg(new IMItem("ra", IMItemKind::LcVar, EntryType::INT, 4), "$ra");
			loadToReg(IMCodeTable[i]->getItem1(), "$v0");
			outputFile << "\tjr\t$ra" << endl;
			break;
		case Add:
		case Sub:
		case Mult:
		case Div: {
			//load item1&item2's value to srcReg1&srcReg2
			string src1 = loadToReg(item1, "temp");
			string src2 = loadToReg(item2, "temp");
			tempRegNo++;
			string dst = ("$t" + to_string(tempRegNo));
			//calculate and save result to dstReg
			switch (op)
			{
			case Add:
				outputFile << "\tadd\t" << dst << "\t" 
					<< src1 << "\t" << src2 << endl;
				break;
			case Sub:
				outputFile << "\tsub\t" << dst << "\t"
					<< src1 << "\t" << src2 << endl;
				break;
			case Mult:
				outputFile << "\tmult\t" << src1 << "\t" << src2 << endl;
				outputFile << "\tmflo\t" << dst << endl;
				break;
			case Div:
				outputFile << "\tdiv\t" << src1 << "\t" << src2 << endl;
				outputFile << "\tmflo\t" << dst << endl;
				break;
			default:
				break;
			}
			//save dst's value to item's address
			storeToMem(item3, dst);
			break;
		}
		case Assign: {
			string reg = loadToReg(item1, "temp");
			storeToMem(item2, reg);
			break;
		}
		case ArrayAssign: {
			string valueReg = loadToReg(item1, "temp");
			string indexReg = loadToReg(item2, "temp");
			outputFile << "\tsll\t" << indexReg << "\t" << indexReg << "\t2" << endl;
			string sp_gp;
			switch (item3->getKind())
			{
			case IMItemKind::GlbVar:
				sp_gp = "$gp";
				break;
			case IMItemKind::LcVar:
				sp_gp = "$sp";
				break;
			default:
				throw "illegal itemKind in ArrayAssign";
				break;
			}
			outputFile << "\tadd\t" << indexReg << "\t" << indexReg << "\t" << sp_gp << endl;
			int arrayOffset = item3->getValue();
			outputFile << "\tsw\t" << valueReg << "\t"
				<< to_string(-arrayOffset) << "\t(" << indexReg << ")" << endl;
			break;
		}
		case AssignArray: {
			string indexReg = loadToReg(item2, "temp");
			outputFile << "\tsll\t" << indexReg << "\t" << indexReg << "\t2" << endl;
			string sp_gp;
			switch (item1->getKind())
			{
			case IMItemKind::GlbVar:
				sp_gp = "$gp";
				break;
			case IMItemKind::LcVar:
				sp_gp = "$sp";
				break;
			default:
				throw "illegal itemKind in ArrayAssign";
				break;
			}
			outputFile << "\tadd\t" << indexReg << "\t" << indexReg << "\t" << sp_gp << endl;
			int arrayOffset = item1->getValue();
			tempRegNo++;
			string valueReg = "$t" + to_string(tempRegNo);
			outputFile << "\tlw\t" << valueReg << "\t"
				<< to_string(-arrayOffset) << "\t(" << indexReg << ")" << endl;
			storeToMem(item3, valueReg);
			break;
		}
		case Label:
			outputFile << item1->getName() << ":" << endl;
			if (item1->getName().compare("main") == 0) {
				outputFile << "\tsw\t$ra\t-4\t($sp)" << endl;
			}
			break;
		case Scanf: {
			int v0Para;
			EntryType entryType = item1->getType();
			switch (entryType)
			{
			case CHAR:
				v0Para = 12;
				break;
			case INT:
				v0Para = 5;
				break;
			default:
				throw "In ObjectCode(Scanf), read not char/int";
				break;
			}
			outputFile << "\tli\t$v0\t" << to_string(v0Para) << endl;
			outputFile << "\tsyscall" << endl;
			storeToMem(item1, "$v0");
			break;
		}
		case Printf: {
			int v0Para;
			EntryType entryType = item1->getType();
			switch (entryType)
			{
			case CHAR: {
				v0Para = 11;
				string reg = loadToReg(item1, "temp");
				outputFile << "\tmove\t$a0\t" << reg << endl;
				break;
			}
			case INT: {
				v0Para = 1;
				string reg = loadToReg(item1, "temp");
				outputFile << "\tmove\t$a0\t" << reg << endl;
				break;
			}
			case STRING: {
				v0Para = 4;
				outputFile << "\tla\t$a0\t" << item1->getName() << endl;
				break;
			}
			default:
				throw "In ObjectCode(Printf), read not char/int/string";
				break;
			}
			outputFile << "\tli\t$v0\t" << to_string(v0Para) << endl;
			outputFile << "\tsyscall" << endl;
			break;
		}
		case Bgt: {
			string reg1 = loadToReg(item1, "temp");
			string reg2 = loadToReg(item2, "temp");
			outputFile << "\tbgt\t" << reg1 << "\t" << reg2 << "\t" << item3->toString() << endl;
			break;
		}
		case Bge: {
			string reg1 = loadToReg(item1, "temp");
			string reg2 = loadToReg(item2, "temp");
			outputFile << "\tbge\t" << reg1 << "\t" << reg2 << "\t" << item3->toString() << endl;
			break;
		}
		case Blt: {
			string reg1 = loadToReg(item1, "temp");
			string reg2 = loadToReg(item2, "temp");
			outputFile << "\tblt\t" << reg1 << "\t" << reg2 << "\t" << item3->toString() << endl;
			break;
		}
		case Ble: {
			string reg1 = loadToReg(item1, "temp");
			string reg2 = loadToReg(item2, "temp");
			outputFile << "\tble\t" << reg1 << "\t" << reg2 << "\t" << item3->toString() << endl;
			break;
		}
		case Beq: {
			string reg1 = loadToReg(item1, "temp");
			string reg2 = loadToReg(item2, "temp");
			outputFile << "\tbeq\t" << reg1 << "\t" << reg2 << "\t" << item3->toString() << endl;
			break;
		}
		case Bne: {
			string reg1 = loadToReg(item1, "temp");
			string reg2 = loadToReg(item2, "temp");
			outputFile << "\tbne\t" << reg1 << "\t" << reg2 << "\t" << item3->toString() << endl;
			break;
		}
		case Jump:
			outputFile << "\tj\t" << item1->toString() << endl;
			break;
		default:
			break;
		}
	}
}

string ObjectCode::loadToReg(IMItem* item, string regName) {
	int varOffset = item->getValue();
	if (regName.compare("temp") == 0) {
		tempRegNo++;
		regName = "$t" + to_string(tempRegNo);
	}
	switch (item->getKind())
	{
	case IMItemKind::Const:
		outputFile << "\tli\t" << regName << "\t" << to_string(item->getValue()) << endl;
		break;
	case IMItemKind::GlbVar:
		outputFile << "\tlw\t" << regName << "\t" << to_string(-varOffset) << "\t($gp)" << endl;
		break;
	case IMItemKind::LcVar:
	case IMItemKind::TempVar:
		// lw  $t1 -8($sp)
		outputFile << "\tlw\t" << regName << "\t" << to_string(-varOffset) << "\t($sp)" << endl;
		break;
	case IMItemKind::String:
		throw "In ObjectCode::genMips(), In +-*/, Has string item";
		break;
	default:
		break;
	}
	return regName;
}

void ObjectCode::storeToMem(IMItem* item, string reg) {
	int varOffset = item->getValue();
	switch (item->getKind())
	{
	case IMItemKind::Const:
		throw "In ObjectCode::genMips(), store sth to a const memory";
		break;
	case IMItemKind::GlbVar:
		outputFile << "\tsw\t" << reg << "\t"
			<< to_string(-varOffset) << "\t($gp)" << endl;
		break;
	case IMItemKind::LcVar:
	case IMItemKind::TempVar:
		outputFile << "\tsw\t" << reg << "\t"
			<< to_string(-varOffset) << "\t($sp)" << endl;
		break;
	case IMItemKind::String:
		throw "In ObjectCode::genMips(), In +-*/, Has string item";
		break;
	default:
		break;
	}
}

