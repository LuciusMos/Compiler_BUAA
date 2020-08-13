#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include "IMCode.h"
using namespace std;

//�м����
IMCode& IMCode::initIMCode(ofstream& fold, ofstream& fnew, SymbolTable& asymbolTable) {
	static IMCode singleton(fold, fnew, asymbolTable);
	return singleton;
}
IMCode::IMCode(ofstream& fold, ofstream& fnew, SymbolTable& asymbolTable) : oldIMFile(fold), newIMFile(fnew), symbolTable(asymbolTable) { }
void IMCode::insertIMCodeEntry(IMCodeEntry* aimcode) {
	IMCodeTable.push_back(aimcode);
}
void IMCode::outputBlock() {
	ofstream fblock("blocks.txt");
	for (int i = 0; i < blockTable.size(); i++) {
		Block* block = blockTable[i];
		vector<IMCodeEntry*> imCodes = block->getIMCodesInBlock();
		fblock << "----------Block " << block->getBlockNo() << "-----------\n";
		fblock << "---begin: " << block->getBegin() << endl;
		fblock << "---next:  " << block->getNext() << endl;
		fblock << "---DEF: " << block->toString(block->getDef()) << endl;
		fblock << "---USE: " << block->toString(block->getUse()) << endl;
		fblock << "---IN:  " << block->toString(block->getIn()) << endl;
		fblock << "---OUT: " << block->toString(block->getOut()) << endl;
		fblock << "---prev: " << block->toString(block->getPrevBlocksNo()) << endl;
		fblock << "---follow: " << block->toString(block->getFollowBlocksNo()) << endl;
		for (int j = 0; j < imCodes.size(); j++) {
			fblock << imCodes[j]->toString();
		}
		fblock << endl;
	}
	fblock.close();
	/*
	for (int i = 0; i < IMCodeTable.size(); i++) {
		outputFile << IMCodeTable[i]->toString();
	}*/
}
void IMCode::outputOld() {
	for (int i = 0; i < IMCodeTable.size(); i++) {
		oldIMFile << IMCodeTable[i]->toString();
	}
}
void IMCode::outputNew() {
	for (int i = 0; i < newIMCodeTable.size(); i++) {
		newIMFile << newIMCodeTable[i]->toString();
	}
}
void IMCode::genNewIMCodeTableFromBlock() {
	for (int i = 0; i < blockTable.size(); i++) {
		vector<IMCodeEntry*> imCodes = blockTable[i]->getIMCodesInBlock();
		for (int j = 0; j < imCodes.size(); j++) {
			newIMCodeTable.push_back(imCodes[j]);
		}
	}
}
void IMCode::genNewIMCodeTableFromIM() {
	for (int i = 0; i < IMCodeTable.size(); i++) {
		newIMCodeTable.push_back(IMCodeTable[i]);
	}
}
void IMCode::optimize() {
	insertProtectEnvOp();
	judgeLeafFunc();
	
	// ���ֻ����顢�����ͻͼ������ͻͼȾɫ������$s $t
	cutBlocks();
	genConflictGraph();
	colorizeConflictGraph();
	allocSTReg();
	
	// mod�Ż�
#ifdef FLOWER_ORIENTED
	IM_modDetect();
#endif // FLOWER_ORIENTED
	// ALU�Ż���i=i+1, imm
	IM_selfOp();
	IM_imm2Second();

	outputBlock();

	IM_eraseUseless();
	IM_inline();
	
	genNewIMCodeTableFromBlock();
	//genNewIMCodeTableFromIM();
}

map<string, bool> funcIsLeaf;
void IMCode::judgeLeafFunc() {
	string funcName;
	bool inFunc = false;
	bool isLeaf = false;
	for (int i = 0; i < IMCodeTable.size(); i++) {
		if (IMCodeTable[i]->getOp() == IMOpType::FuncCall) {
			isLeaf = false;
		} else if (IMCodeTable[i]->getOp() == IMOpType::FuncDef) {
			if (inFunc == false) {
				inFunc = true;
			} else {
				funcIsLeaf.insert(pair<string, bool>(funcName, isLeaf));
			}
			isLeaf = true;
			funcName = IMCodeTable[i]->getItem1()->getName();
		}
	}
	funcIsLeaf.insert(pair<string, bool>(funcName, isLeaf));
}
void IMCode::insertProtectEnvOp() {
	bool newFuncCall = true;
	vector<IMCodeEntry*>::iterator iter;
	for (iter = IMCodeTable.begin(); iter < IMCodeTable.end(); iter++) {
		if ((*iter)->getOp() == IMOpType::ParaInFuncCall && newFuncCall) {
			// vector insert
			iter = IMCodeTable.insert(iter, new IMCodeEntry(IMOpType::ProtectEnv));
			newFuncCall = false;
		} else if ((*iter)->getOp() == IMOpType::FuncCall) {
			newFuncCall = true;
		}
	}
}
string tBegin;
string tNext;
set<IMItem> tDef;
set<IMItem> tUse;
set<IMItem> tIn;
set<IMItem> tOut;
vector<IMCodeEntry*> tImCodes;
void tClear() {
	tBegin = "";
	tNext = "";
	tDef.clear();
	tUse.clear();
	tImCodes.clear();
}
vector<string> sRegPool = { "$s0", "$s1", "$s2", "$s3", "$s4", "$s5", "$s6", "$s7", "$k0", "$k1", "$v1", "$fp", "$t5", "$t6", "$t7" };
vector<string> tRegPool = { "$t0", "$t1", "$t2", "$t3", "$t4" };
int sRegNum = sRegPool.size();
int tRegNum = tRegPool.size();
map<IMItem, string> imSVar2Reg;
map<IMItem, string> imTVar2Reg;

vector<IMItem> vertexStack;
map<IMItem, int> vertex2Color;
set<IMItem> loopVar;
int colorUsed[100];
void clearUsedColor() {
	for (int i = 0; i < 100; i++) {
		colorUsed[i] = 0;
	}
}


void insertTDef(IMItem* item) {
	if (item->getKind() != IMItemKind::LcVar) {
		return;
	} else if (regParas.count(*item) == 1) {
		return;
	} else if (tUse.count(*item) == 0) {
		tDef.insert(*item);
	}
}
void insertTUse(IMItem* item) {
	if (item->getKind() != IMItemKind::LcVar) {
		return;
	} else if (regParas.count(*item) == 1) {
		return;
	} else if (tDef.count(*item) == 0) {
		tUse.insert(*item);
	}
}

void IMCode::cutBlocks() {
	// Cut Blocks
	int blockCnt = 0;
	for (int i = 0; i < IMCodeTable.size(); i++) {
		IMOpType op = IMCodeTable[i]->getOp();
		switch (op)
		{
		case Label: {
			// Label���ϳ�Ϊһ�������飬��Label��ʼ�����µĻ�����
			if (tImCodes.size() > 0) {
				Block* nowBlock = new Block(blockCnt++, tDef, tUse, tBegin, tNext, tImCodes);
				nowBlock->insertFollowBlocksNo(blockCnt); //��һ��
				blockTable.push_back(nowBlock);
			}
			tClear();
			tImCodes.push_back(IMCodeTable[i]);
			tBegin = IMCodeTable[i]->getItem1()->getName();
			break;
		}
		case Add: 
		case Sub: 
		case Mult: 
		case Div: 
			insertTUse(IMCodeTable[i]->getItem1());
			insertTUse(IMCodeTable[i]->getItem2());
			insertTDef(IMCodeTable[i]->getItem3());
			tImCodes.push_back(IMCodeTable[i]);
			break;
		case Scanf: //
			insertTDef(IMCodeTable[i]->getItem1());
			tImCodes.push_back(IMCodeTable[i]);
			break;
		case Printf: //
			insertTUse(IMCodeTable[i]->getItem1());
			tImCodes.push_back(IMCodeTable[i]);
			break;
		case Bgt:
		case Bge:
		case Blt:
		case Ble:
		case Beq:
		case Bne: {
			//��ֹ��branch����һ�������飬Ȼ��ʼ�µĻ�����
			insertTUse(IMCodeTable[i]->getItem1());
			insertTUse(IMCodeTable[i]->getItem2());
			tNext = IMCodeTable[i]->getItem3()->getName();
			tImCodes.push_back(IMCodeTable[i]);
			Block* nowBlock = new Block(blockCnt++, tDef, tUse, tBegin, tNext, tImCodes);
			nowBlock->insertFollowBlocksNo(blockCnt);
			blockTable.push_back(nowBlock);
			tClear();
			break;
		}
		case Assign:
			insertTUse(IMCodeTable[i]->getItem1());
			insertTDef(IMCodeTable[i]->getItem2());
			tImCodes.push_back(IMCodeTable[i]);
			break;
		case ArrayAssign:
			insertTUse(IMCodeTable[i]->getItem1());
			insertTUse(IMCodeTable[i]->getItem2());
			tImCodes.push_back(IMCodeTable[i]);
			break;
		case AssignArray:
			insertTUse(IMCodeTable[i]->getItem2());
			insertTDef(IMCodeTable[i]->getItem3());
			tImCodes.push_back(IMCodeTable[i]);
			break;
		case FuncDef: {
			if (tImCodes.size() > 0) {
				Block* nowBlock = new Block(blockCnt++, tDef, tUse, tBegin, tNext, tImCodes);
				//��Label��ͬ��followBlockû�е�ǰ�¿�
				blockTable.push_back(nowBlock);
			}
			tClear();
			tImCodes.push_back(IMCodeTable[i]);
			tBegin = IMCodeTable[i]->getItem1()->getName();
			break;
		}
		case ParaInFuncDef:
			insertTDef(IMCodeTable[i]->getItem1());
			tImCodes.push_back(IMCodeTable[i]);
			break;
		case FuncCall: {
			tNext = IMCodeTable[i]->getItem2()->getName();
			tImCodes.push_back(IMCodeTable[i]);
			Block* nowBlock = new Block(blockCnt++, tDef, tUse, tBegin, tNext, tImCodes);
			//��branch��ͬ��followBlockû���±����ڵĿ�
			blockTable.push_back(nowBlock);
			tClear();
			break;
		}	
		case ParaInFuncCall:
			insertTUse(IMCodeTable[i]->getItem1());
			tImCodes.push_back(IMCodeTable[i]);
			break;
		case NonRetFuncReturn:
		case RetFuncReturn: {
			tNext = "@" + IMCodeTable[i]->getItem1()->getName();
			tImCodes.push_back(IMCodeTable[i]);
			if (op == IMOpType::RetFuncReturn) {
				insertTUse(IMCodeTable[i]->getItem2());
			}
			Block* nowBlock = new Block(blockCnt++, tDef, tUse, tBegin, tNext, tImCodes);
			blockTable.push_back(nowBlock);
			tClear();
			break;
		}
		case FuncCallRet:
			insertTDef(IMCodeTable[i]->getItem1());
			tImCodes.push_back(IMCodeTable[i]);
			break;
		case Jump: {
			tNext = IMCodeTable[i]->getItem1()->getName();
			tImCodes.push_back(IMCodeTable[i]);
			Block* nowBlock = new Block(blockCnt++, tDef, tUse, tBegin, tNext, tImCodes);
			blockTable.push_back(nowBlock);
			tClear();
			break;
		}
		case ConstDefInt: case ConstDefChar:
		case VarDefInt: case VarDefChar:
			break;
		//case ProtectEnv:
		default:
			tImCodes.push_back(IMCodeTable[i]);
			break;
		}
	}
	// ����ÿ����ĺ��
	for (int i = 0; i < blockTable.size(); i++) {
		if (blockTable[i]->getNext() == "") continue;
		if (blockTable[i]->getNext()[0] != '@') {
			for (int j = 0; j < blockTable.size(); j++) {
				if (blockTable[i]->getNext() == blockTable[j]->getBegin()) {
					blockTable[i]->insertFollowBlocksNo(j);
				}
			}
		} else { //blockTable[i]->getNext() == "@...."
			for (int j = 0; j < blockTable.size(); j++) {
				if (blockTable[i]->getNext().substr(1) == blockTable[j]->getNext()) {
					blockTable[i]->insertFollowBlocksNo(j + 1);
				}
			}
		}
	}
	// ������
	blockTable.push_back(new Block(blockTable.size(), tDef, tUse, tBegin, tNext, tImCodes));
	tClear();
	// ����In��Out
	bool update = true;
	tIn.clear();
	tOut.clear();
	while (update) {
		update = false;
		for (int i = blockTable.size() - 2; i >= 0; i--) {
			// out = ���к�̵�in�Ĳ���
			set<int> tempFollow = blockTable[i]->getFollowBlocksNo();
			for (set<int>::iterator iter1 = tempFollow.begin(); iter1 != tempFollow.end(); iter1++) {
				set<IMItem> tempIn = blockTable[*iter1]->getIn();
				for (set<IMItem>::iterator iter2 = tempIn.begin(); iter2 != tempIn.end(); iter2++) {
					tOut.insert(*iter2);
				}
			}
			if (blockTable[i]->setOut(tOut)) update = true;
			tOut.clear();
			// in = use + (out - def)
			set<IMItem> tempUse = blockTable[i]->getUse();
			for (set<IMItem>::iterator iter = tempUse.begin(); iter != tempUse.end(); iter++) {
				tIn.insert(*iter);
			}
			set<IMItem> tempOut = blockTable[i]->getOut();
			set<IMItem> tempDef = blockTable[i]->getDef();
			for (set<IMItem>::iterator iter = tempOut.begin(); iter != tempOut.end(); iter++) {
				if (tempDef.count(*iter) == 0) {
					tIn.insert(*iter);
				}
			}
			if (blockTable[i]->setIn(tIn)) update = true;
			tIn.clear();
		}
	}
}
map<IMItem, set<IMItem>> conflictGraph;
map<IMItem, set<IMItem>> tConflictGraph;
void addEdge(set<IMItem>::iterator iter1, set<IMItem>::iterator iter2) {
	if (conflictGraph.count(*iter1) != 0) {
		(conflictGraph[*iter1]).insert(*iter2);
	} else {
		set<IMItem> value = { *iter2 };
		conflictGraph.insert(pair<IMItem, set<IMItem>>(*iter1, value));
	}
}
void updateTOut() {
	// ���� tOut = tUse + (tOut - tDef)
	for (set<IMItem>::iterator defIter = tDef.begin(); defIter != tDef.end(); defIter++) {
		tOut.erase(*defIter);
	}
	for (set<IMItem>::iterator useIter = tUse.begin(); useIter != tUse.end(); useIter++) {
		tOut.insert(*useIter);
	}
}
void updateConflictGraph() {
	for (set<IMItem>::iterator defIter = tDef.begin(); defIter != tDef.end(); defIter++) {
		for (set<IMItem>::iterator outIter = tOut.begin(); outIter != tOut.end(); outIter++) {
			addEdge(defIter, outIter);
			addEdge(outIter, defIter);
		}
	}
}
void IMCode::genConflictGraph() {
	tOut.clear();
	for (int i = 0; i < blockTable.size(); i++) {
		vector<IMCodeEntry*> tImCodes = blockTable[i]->getIMCodesInBlock();
		tOut.clear();
		tOut = blockTable[i]->getOut();
		for (int j = tImCodes.size() - 1; j >= 0; j--) {
			IMOpType op = tImCodes[j]->getOp();
			tUse.clear();
			tDef.clear();
			switch (op)
			{
			case ParaInFuncDef:
				insertTDef(tImCodes[j]->getItem1());
				break;
			case ParaInFuncCall:
				insertTUse(tImCodes[j]->getItem1());
				break;
			case FuncCallRet:
				insertTDef(tImCodes[j]->getItem1());
				break;
			case RetFuncReturn:
				insertTUse(tImCodes[j]->getItem2());
				break;
			case Add:
			case Sub:
			case Mult:
			case Div:
				insertTUse(tImCodes[j]->getItem1());
				insertTUse(tImCodes[j]->getItem2());
				insertTDef(tImCodes[j]->getItem3());
				break;
			case Assign:
				insertTUse(tImCodes[j]->getItem1());
				insertTDef(tImCodes[j]->getItem2());
				break;
			case ArrayAssign:
				insertTUse(tImCodes[j]->getItem1());
				insertTUse(tImCodes[j]->getItem2());
				break;
			case AssignArray:
				insertTUse(tImCodes[j]->getItem2());
				insertTDef(tImCodes[j]->getItem3());
				break;
			case Scanf:
				insertTDef(tImCodes[j]->getItem1());
				break;
			case Printf:
				insertTUse(tImCodes[j]->getItem1());
				break;
			case Bgt:
			case Bge:
			case Blt:
			case Ble:
			case Beq:
			case Bne:
				insertTUse(tImCodes[j]->getItem1());
				insertTUse(tImCodes[j]->getItem2());
				break;
			/*
			case ConstDefInt:
			case ConstDefChar:
			case VarDefInt:
			case VarDefChar:
			case FuncDef:
			case Label:
			case Jump:
			case ProtectEnv:
			case FuncCall:
			case NonRetFuncReturn:
				break;*/
			default:
				break;
			}
			updateConflictGraph();
			// ���� tOut = tUse + (tOut - tDef)
			updateTOut();
			/*
			for (set<IMItem>::iterator defIter = tDef.begin(); defIter != tDef.end(); defIter++) {
				tOut.erase(*defIter);
			}
			for (set<IMItem>::iterator useIter = tUse.begin(); useIter != tUse.end(); useIter++) {
				tOut.insert(*useIter);
			}*/
		}
	}
}


void removeSatVertex() {
	bool canRemove = true;
	while (canRemove) {
		canRemove = false;
		map<IMItem, set<IMItem>>::iterator iter = tConflictGraph.begin();
		while (iter != tConflictGraph.end()) {
			/*if (iter->second.size() == 0) {
				canRemove = true;
				vertexStack.push_back(iter->first);
				tConflictGraph.erase(iter);
			} else */
			if (iter->second.size() < sRegNum) {
				canRemove = true;
				vertexStack.push_back(iter->first);
				for (map<IMItem, set<IMItem>>::iterator valueIter = tConflictGraph.begin(); valueIter != tConflictGraph.end(); valueIter++) {
					valueIter->second.erase(iter->first);
				}
				tConflictGraph.erase(iter++);
			} else ++iter;
		}
	}
}
int allocColor(IMItem vertex);
void IMCode::colorizeConflictGraph() {
	// ����ʽɾ��
	tConflictGraph = conflictGraph;
	removeSatVertex();
	while (tConflictGraph.size() > 0) {
		map<IMItem, set<IMItem>>::iterator first = tConflictGraph.begin();
		vertex2Color[first->first] = -1;
		for (map<IMItem, set<IMItem>>::iterator valueIter = tConflictGraph.begin(); valueIter != tConflictGraph.end(); valueIter++) {
			valueIter->second.erase(first->first);
		}
		tConflictGraph.erase(first);
		removeSatVertex();
		/*
		for (map<IMItem, set<IMItem>>::iterator iter = tConflictGraph.begin(); iter != tConflictGraph.end(); iter++) {
			vertex2Color[iter->first] = -1;
			for (map<IMItem, set<IMItem>>::iterator valueIter = tConflictGraph.begin(); valueIter != tConflictGraph.end(); valueIter++) {
				valueIter->second.erase(iter->first);
			}
			tConflictGraph.erase(iter);
		}*/
	}
	// ��ɾȥ�ĵ�����ӻأ�Ȼ��Ⱦɫ
	for (int i = vertexStack.size() - 1; i >= 0; i--) {
		IMItem nowVertex = vertexStack[i];
		
		if (vertex2Color.count(nowVertex) == 0) { // nowVertex��δȾɫ
			int color = allocColor(nowVertex);
			vertex2Color[nowVertex] = color;
			colorUsed[color] = 1;
		} else { // nowVertex�Ѿ�Ⱦɫ/����ҪȾɫ
			if (vertex2Color[nowVertex] == -1) {
				clearUsedColor();
				continue;
			}
			colorUsed[vertex2Color[nowVertex]] = 1;
		}
		set<IMItem> adjVertex = conflictGraph[nowVertex];
		// �����ڵĽ��Ⱦɫ
		for (set<IMItem>::iterator vertexIter = adjVertex.begin(); vertexIter != adjVertex.end(); vertexIter++) {
			if (vertex2Color.count(*vertexIter) == 0) {
				vertex2Color[*vertexIter] = allocColor(*vertexIter);
			}
		}
		clearUsedColor();
	}
}
void IMCode::allocSTReg() {
	// ����Ⱦɫͼ����$s
	for (map<IMItem, int>::iterator mapIter = vertex2Color.begin(); mapIter != vertex2Color.end(); mapIter++) {
		if (mapIter->second != -1) {
			string regName = sRegPool[mapIter->second];
			imSVar2Reg.insert(pair<IMItem, string>(mapIter->first, regName));
		}
	}
	
}
int allocColor(IMItem vertex) {
	set<IMItem> adjVertex = conflictGraph[vertex];
	int needDecolor[100] = { 0 };
	// �������ڽ�㣬ȷ����ǰ������õ���ɫ
	for (set<IMItem>::iterator iter = adjVertex.begin(); iter != adjVertex.end(); iter++) {
		if (vertex2Color.count(*iter) > 0) { //���ڽ���Ѿ���Ⱦɫ/����ҪȾɫ
			if (vertex2Color[*iter] == -1) continue; //���ڽ�㲻��ҪȾɫ
			int color = vertex2Color[*iter];
			colorUsed[color] = 1;
			needDecolor[color] = 1;
		}
	}
	// �ҵ�һ�����õ���ɫ
	for (int i = 0; i < sRegNum; i++) {
		if (colorUsed[i] == 0) { //��ǰ��ɫi����
			for (int j = 0; j < sRegNum; j++) {
				if (needDecolor[j] == 1) {
					colorUsed[j] = 0;
				}
			}
			return i;
		}
	}
	throw "in IMCode's allocColor, no color can be allocated";
	return -1;
}
void IMCode::IM_modDetect() {
	for (int i = 0; i < blockTable.size(); i++) {
		blockTable[i]->Block_modDetect();
	}
}
void IMCode::IM_selfOp() {
	for (int i = 0; i < blockTable.size(); i++) {
		blockTable[i]->Block_selfOp();
	}
}
void IMCode::IM_imm2Second() {
	for (int i = 0; i < blockTable.size(); i++) {
		blockTable[i]->Block_imm2Second();
	}
}
void IMCode::IM_eraseUseless() {
	for (int i = 0; i < blockTable.size(); i++) {
		blockTable[i]->Block_eraseUseless();
	}
}
map<string, Block*> inlinableFuncName2Block;
void IMCode::IM_inline() {
	for (int i = 0; i < blockTable.size(); i++) {
		string begin = blockTable[i]->getBegin();
		string next = blockTable[i]->getNext();
		if (begin != "" && next != "" && begin == next.substr(1)) {
			if ((blockTable[i]->getIMCodesInBlock())[0]->getOp() != IMOpType::FuncDef) {
				throw "in IMCode::IM_inline, an inlinable block is not FuncDef";
			}
			string funcName = blockTable[i]->getBegin();
			inlinableFuncName2Block.insert(pair<string, Block*>(funcName, blockTable[i]));
			blockTable[i]->Block_inline_jr();
		}
	}
	for (int i = 0; i < blockTable.size(); i++) {
		blockTable[i]->Block_inline();
	}
}

//��Ԫʽ�Ĳ�����
IMItem::IMItem(string aname, IMItemKind akind, EntryType atype, int avalue, string afuncName) {
	name = aname; 
	kind = akind; 
	type = atype;
	funcName = afuncName;
	value = avalue;
}
string IMItem::toString() const {
	//Const, GlbVar, LcVar, TempVar, String
	if (kind == IMItemKind::Const) {
		if (type == EntryType::CHAR) {
			return ("'" + string(1, char(value)) + "'");
		} else {
			return to_string(value);
		}
	} else {
		return name;
	}
}

//��Ԫʽ
IMCodeEntry::IMCodeEntry(IMOpType aop) { op = aop; }
IMCodeEntry::IMCodeEntry(IMOpType aop, IMItem* aitem1) { op = aop; item1 = aitem1; }
IMCodeEntry::IMCodeEntry(IMOpType aop, IMItem* aitem1, IMItem* aitem2) { op = aop; item1 = aitem1; item2 = aitem2; }
IMCodeEntry::IMCodeEntry(IMOpType aop, IMItem* aitem1, IMItem* aitem2, IMItem* aitem3) { op = aop; item1 = aitem1; item2 = aitem2; item3 = aitem3; }
string IMCodeEntry::toString() {
	string result;
	switch (op)
	{
	case ConstDefInt:
		result.append("const int ").append(item1->name).append(" = ").append(item1->toString()).append("\n");
		break;
	case ConstDefChar:
		result.append("const char ").append(item1->name).append(" = ").append(item1->toString()).append("\n");
		break;
	case VarDefInt:
		result.append("var int ").append(item1->name).append("\n");
		break;
	case VarDefChar:
		result.append("var char ").append(item1->name).append("\n");
		break;
	case FuncDef:
		result.append("func ").append(item1->name).append("()\n");
		break;
	case ParaInFuncDef:
		result.append("para in func: ").append(item1->name).append("\n");
		break;
	case ParaInFuncCall:
		result.append("push ").append(item1->toString()).append("\n");
		break;
	case ProtectEnv:
		result.append("protect env\n");
		break;
	case FuncCall:
		result.append("call ").append(item2->toString()).append("\n");
		break;
	case FuncCallRet:
		result.append(item1->toString()).append(" = retValue").append("\n");
		break;
	case NonRetFuncReturn:
		result.append("func ").append(item1->toString()).append(" -> NonRetreturn").append("\n");
		break;
	case RetFuncReturn:
		result.append("func ").append(item1->toString()).append(" -> Retreturn  retValue:").append(item2->toString()).append("\n");
		break;
	case Add: //
		result.append("+\t\t").append(item1->toString()).append("\t\t").append(item2->toString()).append("\t\t").append(item3->toString()).append("\n");
		break;
	case Sub: //
		result.append("-\t\t").append(item1->toString()).append("\t\t").append(item2->toString()).append("\t\t").append(item3->toString()).append("\n");
		break;
	case Mult: //
		result.append("*\t\t").append(item1->toString()).append("\t\t").append(item2->toString()).append("\t\t").append(item3->toString()).append("\n");
		break;
	case Div: //
		result.append("/\t\t").append(item1->toString()).append("\t\t").append(item2->toString()).append("\t\t").append(item3->toString()).append("\n");
		break;
	case Mod: //
		result.append("%\t\t").append(item1->toString()).append("\t\t").append(item2->toString()).append("\t\t").append(item3->toString()).append("\n");
		break;
	case Assign: //
		result.append("=\t\t").append(item1->toString()).append("\t\t").append(item2->toString()).append("\n");
		break;
	case ArrayAssign: //
		result.append("[]=\t\t").append(item1->toString()).append("\t\t").append(item2->toString()).append("\t\t").append(item3->toString()).append("\n");
		break;
	case AssignArray: //
		result.append("=[]\t\t").append(item1->toString()).append("\t\t").append(item2->toString()).append("\t\t").append(item3->toString()).append("\n");
		break;
	case Label:
		result.append("Label ").append(item1->toString()).append("\n");
		break;
	case Scanf: //
		result.append("scanf ").append(item1->toString()).append("\n");
		break;
	case Printf: //
		result.append("printf ").append(item1->toString()).append("\n");
		break;
	case Bgt:
		result.append("bgt\t\t").append(item1->toString()).append("\t\t").append(item2->toString()).append("\t\t").append(item3->toString()).append("\n");
		break;
	case Bge:
		result.append("bge\t\t").append(item1->toString()).append("\t\t").append(item2->toString()).append("\t\t").append(item3->toString()).append("\n");
		break;
	case Blt:
		result.append("blt\t\t").append(item1->toString()).append("\t\t").append(item2->toString()).append("\t\t").append(item3->toString()).append("\n");
		break;
	case Ble:
		result.append("ble\t\t").append(item1->toString()).append("\t\t").append(item2->toString()).append("\t\t").append(item3->toString()).append("\n");
		break;
	case Beq:
		result.append("beq\t\t").append(item1->toString()).append("\t\t").append(item2->toString()).append("\t\t").append(item3->toString()).append("\n");
		break;
	case Bne:
		result.append("bne\t\t").append(item1->toString()).append("\t\t").append(item2->toString()).append("\t\t").append(item3->toString()).append("\n");
		break;
	case Jump:
		result.append("j ").append(item1->toString()).append("\n");
		break;
	default:
		break;
	}
	return result;
}

// Block
string Block::toString(set<IMItem> temp) {
	string ret;
	for (set<IMItem>::iterator iter = temp.begin(); iter != temp.end(); iter++) {
		ret.append(iter->toString()).append(", ");
	}
	return ret;
}
string Block::toString(set<int> temp) {
	string ret;
	for (set<int>::iterator iter = temp.begin(); iter != temp.end(); iter++) {
		ret.append(to_string(*iter)).append(", ");
	}
	return ret;
}
void Block::Block_modDetect() {
	if (imCodesInBlock.size() <= 2) return;
	for (vector<IMCodeEntry*>::iterator modIter = imCodesInBlock.begin(); modIter < imCodesInBlock.end() - 2; modIter++) {
		IMCodeEntry* entry1 = *modIter;
		IMCodeEntry* entry2 = *(modIter + 1);
		IMCodeEntry* entry3 = *(modIter + 2);
		if (entry1->getOp() == IMOpType::Div && entry2->getOp() == IMOpType::Mult && entry3->getOp() == IMOpType::Sub
			&& entry2->getItem1()->equalsTo(*entry1->getItem3()) && entry2->getItem3()->equalsTo(*entry1->getItem3())
			&& entry3->getItem2()->equalsTo(*entry2->getItem1()) && entry3->getItem3()->equalsTo(*entry2->getItem1())
			&& entry3->getItem1()->equalsTo(*entry1->getItem1())
			&& entry2->getItem2()->equalsTo(*entry1->getItem2())) {
			IMCodeEntry* modEntry = new IMCodeEntry(IMOpType::Mod, entry1->getItem1(), entry1->getItem2(), entry1->getItem3());
			modIter = imCodesInBlock.erase(modIter, modIter + 3);
			modIter = imCodesInBlock.insert(modIter, modEntry);
			if (modIter == imCodesInBlock.end()) break;
		}
	}
}
void Block::Block_selfOp() {
	if (imCodesInBlock.size() <= 1) return;
	bool canIter = true;
	while (canIter) {
		canIter = false;
		for (vector<IMCodeEntry*>::iterator selfIter = imCodesInBlock.begin(); selfIter < imCodesInBlock.end() - 1; selfIter++) {
			IMCodeEntry* entry1 = *selfIter;
			IMCodeEntry* entry2 = *(selfIter + 1);
			if ((entry1->getOp() == IMOpType::Add || entry1->getOp() == IMOpType::Sub || entry1->getOp() == IMOpType::Mult ||
				entry1->getOp() == IMOpType::Div || entry1->getOp() == IMOpType::Mod) && entry2->getOp() == IMOpType::Assign
				/*&& (entry2->getItem2()->equalsTo(*entry1->getItem1()) || entry2->getItem2()->equalsTo(*entry1->getItem2()))*/
				&& entry2->getItem1()->equalsTo(*entry1->getItem3()) && entry2->getItem1()->getKind() == IMItemKind::TempVar) {
				canIter = true;
				IMCodeEntry* selfOpEntry = new IMCodeEntry(entry1->getOp(), entry1->getItem1(), entry1->getItem2(), entry2->getItem2());
				selfIter = imCodesInBlock.erase(selfIter, selfIter + 2);
				selfIter = imCodesInBlock.insert(selfIter, selfOpEntry);
				//++selfIter;
				if (selfIter == imCodesInBlock.end()) break;
			}
		}
	}
}
void Block::Block_imm2Second() {
	for (vector<IMCodeEntry*>::iterator immIter = imCodesInBlock.begin(); immIter < imCodesInBlock.end(); immIter++) {
		IMOpType op = (*immIter)->getOp();
		switch (op)
		{
		case Add:
			if ((*immIter)->getItem1()->getKind() == IMItemKind::Const) {
				(*immIter)->swapItem12();
			}
			break;
		/*
		case Assign:
			break;
		case ArrayAssign:
			break;
		case AssignArray:
			break;*/
		case Bgt:
		case Bge:
		case Blt:
		case Ble:
		case Beq:
		case Bne:
			if ((*immIter)->getItem1()->getKind() == IMItemKind::Const) {
				(*immIter)->setOp(BranchOpConstMap[op]);
				(*immIter)->swapItem12();
			}
			break;
		default:
			break;
		}
		
	}
}
set<IMItem> tempDefInErase;
set<IMItem> tempUseInErase;
void insertTempDefInErase(IMItem* item) {
	if (item->getKind() == IMItemKind::TempVar) {
		tempDefInErase.insert(*item);
	}
}
void insertTempUseInErase(IMItem* item) {
	if (item->getKind() == IMItemKind::TempVar && tempDefInErase.count(*item) == 0) {
		tempUseInErase.insert(*item);
	}
}
void Block::Block_eraseUseless() {
	set<IMItem> tempCanBeErased; //���tempDef�����У����������ɾ��
	tOut.clear();
	tOut = out;
	for (vector<IMCodeEntry*>::reverse_iterator eraseIter = imCodesInBlock.rbegin(); eraseIter < imCodesInBlock.rend(); ) { //����
		IMOpType op = (*eraseIter)->getOp();
		tUse.clear(); //local
		tDef.clear(); //local
		tempUseInErase.clear(); //global
		tempDefInErase.clear(); //global
		switch (op)
		{
			//��def��use
		case ParaInFuncDef:
			insertTDef((*eraseIter)->getItem1());
			insertTempDefInErase((*eraseIter)->getItem1());
			break;
		case ParaInFuncCall:
			insertTUse((*eraseIter)->getItem1());
			insertTempUseInErase((*eraseIter)->getItem1());
			break;
		case FuncCallRet:
			insertTDef((*eraseIter)->getItem1());
			insertTempDefInErase((*eraseIter)->getItem1());
			break;
		case RetFuncReturn:
			insertTUse((*eraseIter)->getItem2());
			insertTempUseInErase((*eraseIter)->getItem2());
			break;
		case Add:
		case Sub:
		case Mult:
		case Div:
			insertTUse((*eraseIter)->getItem1());
			insertTempUseInErase((*eraseIter)->getItem1());
			insertTUse((*eraseIter)->getItem2());
			insertTempUseInErase((*eraseIter)->getItem2());
			insertTDef((*eraseIter)->getItem3());
			insertTempDefInErase((*eraseIter)->getItem3());
			break;
		case Assign:
			insertTUse((*eraseIter)->getItem1());
			insertTempUseInErase((*eraseIter)->getItem1());
			insertTDef((*eraseIter)->getItem2());
			insertTempDefInErase((*eraseIter)->getItem2());
			break;
		case ArrayAssign:
			insertTUse((*eraseIter)->getItem1());
			insertTempUseInErase((*eraseIter)->getItem1());
			insertTUse((*eraseIter)->getItem2());
			insertTempUseInErase((*eraseIter)->getItem2());
			break;
		case AssignArray:
			
			insertTUse((*eraseIter)->getItem2());
			insertTempUseInErase((*eraseIter)->getItem2());
			insertTDef((*eraseIter)->getItem3());
			insertTempDefInErase((*eraseIter)->getItem3());
			break;
		case Scanf:
			insertTDef((*eraseIter)->getItem1());
			insertTempDefInErase((*eraseIter)->getItem1());
			break;
		case Printf:
			insertTUse((*eraseIter)->getItem1());
			insertTempUseInErase((*eraseIter)->getItem1());
			break;
		case Bgt:
		case Bge:
		case Blt:
		case Ble:
		case Beq:
		case Bne:
			insertTUse((*eraseIter)->getItem1());
			insertTempUseInErase((*eraseIter)->getItem1());
			insertTUse((*eraseIter)->getItem2());
			insertTempUseInErase((*eraseIter)->getItem2());
			break;
		case ConstDefInt:
		case ConstDefChar:
		case VarDefInt:
		case VarDefChar:
		case FuncDef:
		case Label:
		case Jump:
		case ProtectEnv:
		case FuncCall:
		case NonRetFuncReturn:
			break;
		default:
			break;
		}
		if (op == IMOpType::Assign && (*eraseIter)->getItem2()->getKind() == IMItemKind::GlbVar) {
			updateTOut();
			eraseIter++;
			continue;
		} //�޸�ȫ�ֱ���������ɾ
		/*
		if (((*eraseIter)->getItem1() != NULL && (*eraseIter)->getItem1()->getKind() == IMItemKind::GlbVar) ||
			((*eraseIter)->getItem2() != NULL && (*eraseIter)->getItem2()->getKind() == IMItemKind::GlbVar) ||
			((*eraseIter)->getItem3() != NULL && (*eraseIter)->getItem3()->getKind() == IMItemKind::GlbVar)) {
			eraseIter++;
			continue;
		} //�޸�ȫ�ֱ���������ɾ
		*/
		if (op == IMOpType::Scanf || op == IMOpType::ArrayAssign) {
			updateTOut();
			eraseIter++;
			continue;
		} //��scanf��Ϊ���鸳ֵ������ɾ
		if (tDef.size() != 0) { //��def
			IMItem defItem = *tDef.begin();
			if (tOut.count(defItem) == 0) { //out�в����е�ǰ����def��������ɾȥ�����
				eraseIter = vector<IMCodeEntry*>::reverse_iterator(imCodesInBlock.erase((++eraseIter).base()));
				for (set<IMItem>::iterator useIter = tempUseInErase.begin(); useIter != tempUseInErase.end(); useIter++) {
					if ((*useIter).getKind() == IMItemKind::TempVar) {
						tempCanBeErased.insert(*useIter);
					}
				}
				continue;
			}
		}
		if (tempDefInErase.size() != 0) { //��ǰ����def��temp
			IMItem defTemp = *tempDefInErase.begin();
			if (tempCanBeErased.count(defTemp) != 0) { //��ǰtempDef�ڱ��Ƴ������У�����ɾȥ�����
				eraseIter = vector<IMCodeEntry*>::reverse_iterator(imCodesInBlock.erase((++eraseIter).base()));
				for (set<IMItem>::iterator useIter = tempUseInErase.begin(); useIter != tempUseInErase.end(); useIter++) {
					if ((*useIter).getKind() == IMItemKind::TempVar) {
						tempCanBeErased.insert(*useIter);
					}
				}
				continue;
			}
		}
		// ���� tOut = tUse + (tOut - tDef)
		updateTOut();
		
		eraseIter++;
	}
}

void Block::Block_inline() {
	for (vector<IMCodeEntry*>::iterator inlineIter = imCodesInBlock.begin(); inlineIter < imCodesInBlock.end(); inlineIter++) {
		if ((*inlineIter)->getOp() == IMOpType::FuncCall) {
			string funcName = (*inlineIter)->getItem2()->getName();
			if (inlinableFuncName2Block.count(funcName) != 0) {
				vector<IMCodeEntry*> funcIMCodes = inlinableFuncName2Block[funcName]->getIMCodesInBlock();
				for (vector<IMCodeEntry*>::iterator imIter = funcIMCodes.begin(); imIter < funcIMCodes.end(); imIter++) {
					(*imIter)->setIsInline(true);
				}
				(*inlineIter)->setItem3(new IMItem("NoJal", IMItemKind::String, EntryType::STRING));
				/*inlineIter = */imCodesInBlock.insert(inlineIter + 1, funcIMCodes.begin(), funcIMCodes.end()); //ȫ��������funcDef���л�curFuncPtr����
				break;
			}
		}
	}
}
void Block::Block_inline_jr() {
	for (vector<IMCodeEntry*>::iterator jrIter = imCodesInBlock.begin(); jrIter < imCodesInBlock.end(); jrIter++) {
		if ((*jrIter)->getOp() == IMOpType::RetFuncReturn || (*jrIter)->getOp() == IMOpType::NonRetFuncReturn) {
			(*jrIter)->setItem3(new IMItem("NoJr", IMItemKind::String, EntryType::STRING));
		}
	}
}