#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include "ObjectCode.h"
using namespace std;

#define DEBUG

FuncEntry* curFuncPtr = NULL;
string inline_addi_sp;
FuncEntry* inline_old_func_ptr = NULL;
set<string> inline_funcDef_already_printed;

ObjectCode& ObjectCode::initObjectCode(ofstream& fmips, IMCode& aimCode, SymbolTable& asymbolTable) {
	static ObjectCode singleton(fmips, aimCode, asymbolTable);
	return singleton;
}
ObjectCode::ObjectCode(ofstream& fmips, IMCode& aimCode, SymbolTable& asymbolTable) 
	: outputFile(fmips), imCode(aimCode), symbolTable(asymbolTable) {
	this->IMCodeTable = imCode.getNewIMCodeTable();
	//this->blockTable = imCode.getBlockTable();
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

void ObjectCode::sReg_paraInFuncCall() {
	// 将paraInFuncCall的IMItem更新（查找s寄存器中是否有）
	int paraNo = 0;
	for (int i = 0; i < IMCodeTable.size(); i++) {
		if (IMCodeTable[i]->getOp() == IMOpType::ParaInFuncCall) {
			paraNo++;
			if (IMCodeTable[i]->getItem2()->getKind() != IMItemKind::ValueParaReg) { //不是前三个参数，没分配$a
				string funcName = IMCodeTable[i]->getItem3()->getName();
				FuncEntry* funcPtr = symbolTable.getFuncPtr(funcName);
				VarEntry* paraEntry = (funcPtr->getParas())[paraNo - 1];
				IMItem* paraItem = new IMItem(paraEntry->getName(), IMItemKind::LcVar, paraEntry->getType(), paraEntry->getVarOffset(), funcName);
				if (imSVar2Reg.count(*paraItem) != 0) { //且分配了$s
					IMItem* newItem2 = new IMItem(imSVar2Reg[*paraItem], IMItemKind::ValueParaReg, paraItem->getType());
					IMCodeTable[i]->setItem2(newItem2);
				}
			}
		} else {
			paraNo = 0;
		}
	}
}

set<IMItem> notTRgeAnymore;
void ObjectCode::replacedIMItemJudge(IMItem replacedItem, string replacedReg, int j) {
	j++;
	for (; j < IMCodeTable.size(); j++) {
		if (IMCodeTable[j]->getIsInline() == true) {
			continue;
		}
		IMItem* item1 = IMCodeTable[j]->getItem1();
		IMItem* item2 = IMCodeTable[j]->getItem2();
		IMItem* item3 = IMCodeTable[j]->getItem3();
		IMItem* items[3] = { item1, item2, item3 };
		for (int k = 0; k < 3; k++) {
			if (items[k] != NULL && (*items[k]).equalsTo(replacedItem)) {
				storeToMem(replacedItem, replacedReg, false, true);
				notTRgeAnymore.insert(replacedItem);
				break;
			}
		}
	}
}
void ObjectCode::genMips() {
	genString();

	outputFile << ".text" << endl;
	outputFile << "\tjal\tmain" << endl;
	outputFile << "\tj\tend" << endl;
	int tIndex = 0;
	set<string> usedTRegs;
	for (int i = 0; i < IMCodeTable.size(); i++) {
		IMItem* item1 = IMCodeTable[i]->getItem1();
		IMItem* item2 = IMCodeTable[i]->getItem2();
		IMItem* item3 = IMCodeTable[i]->getItem3();
		IMOpType op = IMCodeTable[i]->getOp();
		
#ifdef DEBUG
		outputFile << "\t\t\t\t\t\t\t########\t" << IMCodeTable[i]->toString();
#endif // DEBUG
		
		// 生成时为临时变量分配$t
		IMItem* items[3] = { item1, item2, item3 };
		for (int k = 0; k < 3; k++) {
			if (items[k] != NULL) {
				//分配寄存器
				if (items[k]->getKind() == IMItemKind::TempVar && // 临时变量
					imTVar2Reg.count(*items[k]) == 0 && // 尚未分配$t
					notTRgeAnymore.count(*items[k]) == 0) { // 不是重复使用的第二次及以后
					string regName = tRegPool[tIndex];
//#ifndef FLOWER_ORIENTED
					if (usedTRegs.count(regName) != 0) { //该$t之前分配过，需要找到被分配的临时变量，判断是否需要存回内存
						//找到被分配当前$t的临时变量
						IMItem replacedItem;
						for (map<IMItem, string>::iterator tRegMapIter = imTVar2Reg.begin(); tRegMapIter != imTVar2Reg.end(); tRegMapIter++) {
							if (tRegMapIter->second == regName) {
								replacedItem = tRegMapIter->first;
								//storeToMem(tRegMapIter->first, regName, false, true);
								imTVar2Reg.erase(replacedItem);
								break;
							}
						}
						//判断是否需要存回内存
						replacedIMItemJudge(replacedItem, regName, i);
						
					}
//#endif // !FLOWER_ORIENTED
					tIndex = (tIndex + 1) % tRegNum;
					imTVar2Reg[*items[k]] = regName;
					usedTRegs.insert(regName);
				}
			}
		}

		switch (op)
		{
		case ConstDefInt:
			break;
		case ConstDefChar:
			break;
		case VarDefInt:
			break;
		case VarDefChar:
			break;
		case FuncDef: {
			curFuncPtr = symbolTable.getFuncPtr(item1->getName());
			string funcName = item1->getName();
			if (inlinableFuncName2Block.count(funcName) == 0) { //不是可内联函数
				outputFile << funcName << ":" << endl;
			} else { //是可内联函数
				if (inline_funcDef_already_printed.count(funcName) == 0) { //函数声明中，需要打印label，并加到已打印名单中
					outputFile << funcName << ":" << endl;
					inline_funcDef_already_printed.insert(funcName);
				}
			}
			bool isLeaf = funcIsLeaf.find(funcName)->second;
			if (!isLeaf) {
				outputFile << "\tsw\t$ra\t-4\t($sp)" << endl;
			}
			break;
		}
		case ParaInFuncDef:
			break;
		case ParaInFuncCall: {
			if (item2->getKind() == IMItemKind::ValueParaReg) {
				loadToReg(*item1, item2->getName(), false, true);
			} else {
				string reg = "$t8";
				reg = loadToReg(*item1, reg, false, false);
				storeToMem(*item2, reg, false, true);
			}
			/*
			string calledFuncName = item3->getName();
			FuncEntry* calledFuncPtr = symbolTable.getFuncPtr(calledFuncName);
			IMItem* paraItem = item1;
			string reg = calledFuncPtr->getVarReg(*paraItem);
			if (reg.compare("NULL") != 0) {
				loadToReg(IMCodeTable[i]->getItem1(), reg, true);
			} else {
				reg = "$t8";
				loadToReg(IMCodeTable[i]->getItem1(), reg, true);
				storeToMem(*IMCodeTable[i]->getItem2(), reg, true);
			}*/
			break;
		}
		case ProtectEnv: { //store $a
			map<IMItem, string> var2Reg = curFuncPtr->getAVar2RegMap();
			map<IMItem, string>::iterator iter;
			// store
			for (iter = var2Reg.begin(); iter != var2Reg.end(); iter++) {
				storeToMem(iter->first, iter->second, false, true);
			}
			break;
		}
		case FuncCall: {
			int size = item1->getValue();
			string jalFuncName = item2->getName();
			string nowFuncName = curFuncPtr->getName();
			map<IMItem, string> aVar2Reg = curFuncPtr->getAVar2RegMap();
			map<IMItem, string> sVar2Reg = curFuncPtr->getSVar2RegMap();
			map<IMItem, string>::iterator iter;

			//store $s
			if (jalFuncName == nowFuncName) { //递归调用
				for (iter = sVar2Reg.begin(); iter != sVar2Reg.end(); iter++) {
					storeToMem(iter->first, iter->second, false, true);
				}
			}

			outputFile << "\taddi\t$sp\t$sp\t" << to_string(-size) << endl; //subi -> addi
			if (item3 != NULL) { //调用的是可以内联的函数，保存：1）恢复栈指令 2）当前函数的指针
				if (item3->getName() != "NoJal") throw "in ObjectCode::genMips's FuncCall, item3 not NULL but not \"NoJal\"";
				inline_addi_sp = "\taddi\t$sp\t$sp\t" + to_string(size);
				inline_old_func_ptr = curFuncPtr;
			} else { //调用的是不可内联的函数
				outputFile << "\tjal\t" << jalFuncName << endl;
				outputFile << "\taddi\t$sp\t$sp\t" << to_string(size) << endl;
			}

			//load $a
			for (iter = aVar2Reg.begin(); iter != aVar2Reg.end(); iter++) { //$a
				loadToReg(iter->first, iter->second, true, true);
			}
			//load $s
			if (jalFuncName == nowFuncName) { //递归调用
				for (iter = sVar2Reg.begin(); iter != sVar2Reg.end(); iter++) { //$s
					loadToReg(iter->first, iter->second, true, true);
				}
			}
			break;
		}
		case FuncCallRet:
			storeToMem(*item1, "$v0", true, false);
			break;
		case NonRetFuncReturn:
		case RetFuncReturn: {
			string funcName = item1->getName();
			bool isLeaf = funcIsLeaf.find(funcName)->second;
			if (!isLeaf) {
				loadToReg(*(new IMItem("ra", IMItemKind::LcVar, EntryType::INT, 4)), "$ra", false, true);
			}
			if (op == IMOpType::RetFuncReturn) {
				loadToReg(*item2, "$v0", false, true);
				//error
			}
			if (item3 != NULL) {
				if (item3->getName() != "NoJr") throw "in ObjectCode::genMips's two FuncReturn, item3 not NULL but not \"NoJr\"";
				outputFile << inline_addi_sp << endl;
				curFuncPtr = inline_old_func_ptr;
			} else {
				outputFile << "\tjr\t$ra" << endl;
			}

			break;
		}

		case Add:
		case Sub:
		case Mult:
		case Div:
		case Mod: {
			if ((op == IMOpType::Add || op == IMOpType::Sub) && item2->getKind() == IMItemKind::Const) {
				// 可借助addi subi优化
				string src1 = "$t8";
				src1 = loadToReg(*item1, src1, false, false);
				string constValue = item2->getName();
				string dst = "$t8";
				string retReg = curFuncPtr->getVarReg(*item3);
				if (retReg.compare("NULL") != 0) {
					dst = retReg;
				}
				switch (op)
				{
				case Add:
					outputFile << "\taddi\t" << dst << "\t" << src1 << "\t" << constValue << endl;
					break;
				case Sub: {
					int subNum = stoi(constValue);
					subNum *= -1;
					outputFile << "\taddi\t" << dst << "\t" << src1 << "\t" << to_string(subNum) << endl;
					//outputFile << "\tsubi\t" << dst << "\t" << src1 << "\t" << constValue << endl;
					break;
				}
				default:
					throw "in ObjectCode::genMips, case Op, addi and subi but not add or sub";
					break;
				}
				if (retReg.compare("NULL") == 0) {
					storeToMem(*item3, dst, false, false);
				}
				break;
			} else {
				//load item1's & item2's value to srcReg1 & srcReg2
				string src1 = "$t8";
				string src2 = "$t9";
				src1 = loadToReg(*item1, src1, false, false);
				src2 = loadToReg(*item2, src2, false, false);
				string dst = "$t8";
				string retReg = curFuncPtr->getVarReg(*item3);
				if (retReg.compare("NULL") != 0) {
					dst = retReg;
				}
				//calculate and save result to dstReg
				switch (op)
				{
				case Add:
					outputFile << "\tadd\t" << dst << "\t" << src1 << "\t" << src2 << endl;
					break;
				case Sub:
					outputFile << "\tsub\t" << dst << "\t" << src1 << "\t" << src2 << endl;
					break;
				case Mult:
					outputFile << "\tmult\t" << src1 << "\t" << src2 << endl;
					outputFile << "\tmflo\t" << dst << endl;
					break;
				case Div:
					outputFile << "\tdiv \t" << src1 << "\t" << src2 << endl;
					outputFile << "\tmflo\t" << dst << endl;
					break;
				case Mod:
					outputFile << "\tdiv \t" << src1 << "\t" << src2 << endl;
					outputFile << "\tmfhi\t" << dst << endl;
					break;
				default:
					break;
				}
				//save dst's value to item's address
				if (retReg.compare("NULL") == 0) {
					storeToMem(*item3, dst, false, false);
				}
				break;
			}
		}
		case Assign: {
			string dstReg = curFuncPtr->getVarReg(*item2);
			bool mem = dstReg.compare("NULL") == 0;
			if (item1->getKind() == IMItemKind::Const && !mem) {
				outputFile << "\tli\t" << dstReg << "\t" << item1->getName() << endl;
			} else {
				string reg = "$t8";
				reg = loadToReg(*item1, reg, false, false);
				storeToMem(*item2, reg, true, false);
			}
			break;
		}
		case ArrayAssign: {
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
			if (item2->getKind() == IMItemKind::Const) {
				int arrayOffset = -1 * item3->getValue();
				int indexOffset = item2->getValue() * 4;
				int offset = arrayOffset + indexOffset;
				string valueReg = "$t8";
				valueReg = loadToReg(*item1, valueReg, false, false);
				outputFile << "\tsw\t" << valueReg << "\t"
					<< to_string(offset) << "\t(" << sp_gp << ")" << endl;
			} else {
				string valueReg = "$t8";
				valueReg = loadToReg(*item1, valueReg, false, false);
				string indexReg = "$t9";
				string srcReg = curFuncPtr->getVarReg(*item2);
				bool reg = (srcReg == "NULL"); //本身没有分配寄存器，必须读到寄存器中
				if (reg) {
					loadToReg(*item2, indexReg, false, true);
					outputFile << "\tsll\t" << indexReg << "\t" << indexReg << "\t2" << endl;
				} else {
					outputFile << "\tsll\t" << indexReg << "\t" << srcReg << "\t2" << endl;
				}
				outputFile << "\tadd\t" << indexReg << "\t" << indexReg << "\t" << sp_gp << endl;
				int arrayOffset = item3->getValue();
				outputFile << "\tsw\t" << valueReg << "\t"
					<< to_string(-arrayOffset) << "\t(" << indexReg << ")" << endl;
			}
			break;
		}
		case AssignArray: {
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
			if (item2->getKind() == IMItemKind::Const) {
				int arrayOffset = -1 * item1->getValue();
				int indexOffset = item2->getValue() * 4;
				int offset = arrayOffset + indexOffset;
				string valueReg = "$t9";
				string retReg = curFuncPtr->getVarReg(*item3);
				if (retReg.compare("NULL") != 0) {
					outputFile << "\tlw\t" << retReg << "\t"
						<< to_string(offset) << "\t(" << sp_gp << ")" << endl;
				} else {
					outputFile << "\tlw\t" << valueReg << "\t"
						<< to_string(offset) << "\t(" << sp_gp << ")" << endl;
					storeToMem(*item3, valueReg, true, false);
				}
			} else {
				string indexReg = "$t8";
				string srcReg = curFuncPtr->getVarReg(*item2);
				bool reg = (srcReg == "NULL"); //本身没有分配寄存器，必须读到寄存器中
				if (reg) {
					loadToReg(*item2, indexReg, false, true);
					outputFile << "\tsll\t" << indexReg << "\t" << indexReg << "\t2" << endl;
				} else {
					outputFile << "\tsll\t" << indexReg << "\t" << srcReg << "\t2" << endl;
				}
				
				outputFile << "\tadd\t" << indexReg << "\t" << indexReg << "\t" << sp_gp << endl;
				int arrayOffset = item1->getValue();
				string valueReg = "$t9";
				string retReg = curFuncPtr->getVarReg(*item3);
				if (retReg.compare("NULL") != 0) {
					outputFile << "\tlw\t" << retReg << "\t"
						<< to_string(-arrayOffset) << "\t(" << indexReg << ")" << endl;
				} else {
					outputFile << "\tlw\t" << valueReg << "\t"
						<< to_string(-arrayOffset) << "\t(" << indexReg << ")" << endl;
					storeToMem(*item3, valueReg, true, false);
				}
			}
			break;
		}
		case Label:
			outputFile << item1->getName() << ":" << endl;
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
			storeToMem(*item1, "$v0", true, false);
			break;
		}
		case Printf: {
			int v0Para;
			EntryType entryType = item1->getType();
			switch (entryType)
			{
			case CHAR: {
				v0Para = 11;
				loadToReg(*item1, "$a0", false, true);
				break;
			}
			case INT: {
				v0Para = 1;
				loadToReg(*item1, "$a0", false, true);
				/*
				string reg = "$t8";
				reg = loadToReg(*item1, reg, false);
				outputFile << "\tmove\t$a0\t" << reg << endl;*/
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
		case Bgt:
		case Bge:
		case Blt:
		case Ble:
		case Beq:
		case Bne: {
			// 利用branch指令：第二个操作数可以为imm，进行优化
			string reg1 = "$t8";
			string reg2;
			reg1 = loadToReg(*item1, reg1, false, false);
			if (item2->getKind() == IMItemKind::Const) {
				reg2 = item2->getName();
			} else {
				reg2 = "$t9";
				reg2 = loadToReg(*item2, reg2, false, false);
			}
			outputFile << "\t" << branch_Op2String[op] << "\t" << reg1 << "\t" << reg2 << "\t" << item3->toString() << endl;
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

string ObjectCode::loadToReg(IMItem item, string regName, bool mustFromMem, bool mustToReg) {
	string srcReg = curFuncPtr->getVarReg(item);
	bool mem = srcReg.compare("NULL") == 0;
	if (mustFromMem || mem) {
		int varOffset = item.getValue();
		switch (item.getKind())
		{
		case IMItemKind::Const:
			outputFile << "\tli\t" << regName << "\t" << to_string(item.getValue()) << endl;
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
			throw "In ObjectCode::genMips(), In *+-/, Has string item";
			break;
		default:
			break;
		}
		return regName;
	} else if (mustToReg) {
		if (regName != srcReg) {
			outputFile << "\tmove\t" << regName << "\t" << srcReg << endl;
		}
		return regName;
	} else {
		return srcReg;
	}
}

void ObjectCode::storeToMem(IMItem item, string reg, bool mustToReg, bool mustToMem) {
	string dstReg = curFuncPtr->getVarReg(item);
	bool mem = dstReg.compare("NULL") == 0;
	if (mustToMem || mem) {
		int varOffset = item.getValue();
		switch (item.getKind())
		{
		case IMItemKind::Const:
			throw "In ObjectCode::genMips(), store sth to a const memory";
			break;
		case IMItemKind::GlbVar:
			outputFile << "\tsw\t" << reg << "\t" << to_string(-varOffset) << "\t($gp)" << endl;
			break;
		case IMItemKind::LcVar:
		case IMItemKind::TempVar:
			outputFile << "\tsw\t" << reg << "\t" << to_string(-varOffset) << "\t($sp)" << endl;
			break;
		case IMItemKind::String:
			throw "In ObjectCode::genMips(), In *+-/, Has string item";
			break;
		default:
			break;
		}
	} else if (mustToReg) {
		if (dstReg != reg) {
			outputFile << "\tmove\t" << dstReg << "\t" << reg << endl;
		}
	}
}

/*
string ObjectCode::loadToReg(IMItem* item, string regName, bool mustLoad) {
	string retReg = curFuncPtr->getVarReg(*item);
	if (retReg.compare("NULL") == 0 || mustLoad) {
		int varOffset = item->getValue();
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
			throw "In ObjectCode::genMips(), In *+-/, Has string item";
			break;
		default:
			break;
		}
		return regName;
	} else {
		return retReg;
	}
}*/
/*
void ObjectCode::storeToMem(IMItem* item, string reg, bool mustStore) {
	string retReg = curFuncPtr->getVarReg(*item);
	if (retReg.compare("NULL") == 0 || mustStore) {
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
			throw "In ObjectCode::genMips(), In *+-/, Has string item";
			break;
		default:
			break;
		}
	} else {
		outputFile << "\tmove\t" << retReg << "\t" << reg << endl;
	}
}*/

