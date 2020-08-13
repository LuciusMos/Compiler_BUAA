#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include "IMCode.h"
using namespace std;

//中间代码
IMCode& IMCode::initIMCode(ofstream& fim) {
	static IMCode singleton(fim);
	return singleton;
}
IMCode::IMCode(ofstream& fim) : outputFile(fim) { }
void IMCode::insertIMCodeEntry(IMCodeEntry* aimcode) {
	IMCodeTable.push_back(aimcode);
}
void IMCode::output() {
	for (int i = 0; i < IMCodeTable.size(); i++) {
		outputFile << IMCodeTable[i]->toString();
	}
}

//四元式的操作数
IMItem::IMItem(string aname, IMItemKind akind, EntryType atype, int avalue) { 
	name = aname; 
	kind = akind; 
	type = atype;
	value = avalue;
}
string IMItem::toString() {
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

//四元式
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
	case FuncDefInt:
		result.append("func int ").append(item1->name).append("()\n");
		break;
	case FuncDefChar:
		result.append("func char ").append(item1->name).append("()\n");
		break;
	case FuncDefVoid:
		result.append("func void ").append(item1->name).append("()\n");
		break;
	case ParaInFuncDef:

		break;
	case ParaInFuncCall:
		result.append("push ").append(item1->toString()).append("\n");
		break;
	case FuncCall:
		result.append("call ").append(item2->toString()).append("\n");
		break;
	case FuncCallRet:
		result.append(item1->toString()).append(" = retValue").append("\n");
		break;
	case NonRetFuncReturn:
		result.append("NonRetreturn").append("\n");
		break;
	case RetFuncReturn:
		result.append("Retreturn  retValue:").append(item1->toString()).append("\n");
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