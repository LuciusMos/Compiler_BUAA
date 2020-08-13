#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include "GrammarAnalyzer.h"
using namespace std;

//LexicalTable lexicalTable[50000];
string output[50000]; //输出
int out_cnt;

int out_p = 0;
int sym_p = 0;

// map<string, int> function_table; //0 for non-return, 1 for return

EntryType funcRetType = VOID;
bool hasRetStatement = false;
int varOffset = 0;
FuncEntry* curFuncDefPtr = NULL;
int glbFlag = 1;

string printStringName; //stringGrammar()
int integerValue; //integer()

vector<IMItem*> expStack;
IMItem* popExpStack() {
	IMItem* result = expStack.back();
	expStack.pop_back();
	return result;
}
void pushExpStack(IMItem* temp) {
	expStack.push_back(temp);
}

string genTempVarName() {
	static int index = -1;
	index++;
	string result = "~" + to_string(index); //~ for tempVar
	return result;
}
string genGlbStringName() {
	static int index = -1;
	index++;
	string result = "string" + to_string(index); //str for GlbString
	return result;
}
string genIfLabelNum() {
	static int ifNum = -1;
	ifNum++;
	return to_string(ifNum);
}
string genWhileLabelNum() {
	static int whileNum = -1;
	whileNum++;
	return to_string(whileNum);
}
string genDoWhileLabelNum() {
	static int dowhileNum = -1;
	dowhileNum++;
	return to_string(dowhileNum);
}
string genForLabelNum() {
	static int forNum = -1;
	forNum++;
	return to_string(forNum);
}

IMOpType branchType;
map<symbolType, IMOpType> conditionMap = {
	{symbolType::LSS, IMOpType::Bge}, 
	{symbolType::LEQ, IMOpType::Bgt},
	{symbolType::GRE, IMOpType::Ble},
	{symbolType::GEQ, IMOpType::Blt},
	{symbolType::NEQ, IMOpType::Beq},
	{symbolType::EQL, IMOpType::Bne},
};


GrammarAnalyzer& GrammarAnalyzer::initGrammarAnalyzer(LexicalAnalyzer& aLexicalAnalyzer, ofstream& fout, SymbolTable& aSymbolTable, ErrorHandler& aErrorHandler, IMCode& aIMCode) {
	static GrammarAnalyzer singleton(aLexicalAnalyzer, fout, aSymbolTable, aErrorHandler, aIMCode);
	return singleton;
}
GrammarAnalyzer::GrammarAnalyzer(LexicalAnalyzer& aLexicalAnalyzer, ofstream& fout, SymbolTable& aSymbolTable, ErrorHandler& aErrorHandler, IMCode& aIMCode) :
	lexicalAnalyzer(aLexicalAnalyzer), outputFile(fout), symbolTable(aSymbolTable), errorHandler(aErrorHandler), imCode(aIMCode) {}
void GrammarAnalyzer::grammarAnalyze() {
	program();
	out_cnt = out_p;
#ifdef Grammar_STAGE
	for (int i = 0; i < out_cnt; i++) 
		outputFile << output[i];
#endif // Grammar_STAGE
#ifdef ERROR_STAGE
	errorHandler.output();
#endif // ERROR_STAGE
#ifdef IM_STAGE
	imCode.output();
#endif // IM_STAGE
}

void GrammarAnalyzer::lexicalOutput() {
	output[out_p++] = string(lexicalAnalyzer.reservedWordsOutput.find(lexicalTable[sym_p].symbol)->second).
		append(" ").append(lexicalTable[sym_p].token).append("\n");
	sym_p++;
}

vector<int> sym_p_stack;
vector<int> out_p_stack;

void GrammarAnalyzer::pushReg() {
	sym_p_stack.push_back(sym_p);
	out_p_stack.push_back(out_p);
}
void GrammarAnalyzer::popReg() {
	sym_p = sym_p_stack.back();
	out_p = out_p_stack.back();
	sym_p_stack.pop_back();
	out_p_stack.pop_back();
}

//＜字符串＞   ::=  "｛十进制编码为32,33,35-126的ASCII字符｝"
int GrammarAnalyzer::stringGrammar() {
	pushReg();
	if (lexicalTable[sym_p].symbol != symbolType::STRCON) {
		popReg();
		return 0;
	}
	printStringName = genGlbStringName();
	glbString temp;
	temp.name = printStringName;
	temp.value = lexicalTable[sym_p].token;
	imCode.pushGlbString(temp);
	lexicalOutput();
	output[out_p++] = "<字符串>\n";
	return 1;
}

//＜程序＞    ::= ［＜常量说明＞］［＜变量说明＞］{＜有返回值函数定义＞|＜无返回值函数定义＞}＜主函数＞
int GrammarAnalyzer::program() {
	pushReg();
	if (constDeclaration()) {}
	if (variableDeclaration()) {}
	symbolTable.setGlobalIdenfrTable();
	funcRetType = VOID;
	hasRetStatement = false;
	varOffset = 0;
	glbFlag = 0;
	while (returnFunctionDefinition() || nonReturnFunctionDefinition()) {
		funcRetType = VOID;
		hasRetStatement = false;
		varOffset = 0;
		symbolTable.clrLocalIdenfrTable(curFuncDefPtr);
	}
	if (!mainFunction()) {
		popReg();
		return 0;
	}
	imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::Label, new IMItem("end", IMItemKind::String, EntryType::STRING)));
	output[out_p++] = "<程序>\n";
	return 1;
}

//＜常量说明＞ ::=  const＜常量定义＞;{ const＜常量定义＞;}
int GrammarAnalyzer::constDeclaration() {
	pushReg();
	if (lexicalTable[sym_p].symbol == CONSTTK) {
		//sym_p++; 这里不需要nextSymbol
		while (lexicalTable[sym_p].symbol == CONSTTK) {
			lexicalOutput();
			if (!constDefinition()) {
				popReg();
				return 0;
			}
			if (lexicalTable[sym_p].symbol != SEMICN) {
				errorHandler.semicolon(lexicalTable[sym_p-1].lineNo); //sym_p - 1
				//popReg();
				//return 0;
			} else {
				lexicalOutput();
			}
			/*lexicalOutput();
			if (constDefinition()) {
				if (lexicalTable[sym_p].symbol == SEMICN) {
					lexicalOutput();
				} else {
					popReg();
					return 0;
				}
			} else {
				popReg();
				return 0;
			}*/
		}
		output[out_p++] =  "<常量说明>\n";
		return 1;
	} else {
		popReg();
		return 0;
	}
}

//＜常量定义＞   :: = int＜标识符＞＝＜整数＞{ ,＜标识符＞＝＜整数＞ }
//| char＜标识符＞＝＜字符＞{ ,＜标识符＞＝＜字符＞ }
int GrammarAnalyzer::constDefinition() {
	pushReg();
	string name;
	EntryType entryType;
	int value;
	if (lexicalTable[sym_p].symbol == INTTK) {
		entryType = INT;
		lexicalOutput();
		if (lexicalTable[sym_p].symbol != IDENFR) {
			popReg();
			return 0;
		}
		name = lexicalTable[sym_p].token;
		lexicalOutput();
		if (lexicalTable[sym_p].symbol != ASSIGN) {
			popReg();
			return 0;
		}
		lexicalOutput();
		if (!integer()) {
			errorHandler.intOrCharCon(lexicalTable[sym_p].lineNo);
			sym_p++;
			//popReg();
			//return 0;
		} else {
			value = integerValue; //从integer()的全局变量integerValue中获取值
			int dup = errorHandler.dupDefId(name, lexicalTable[sym_p].lineNo);
			if (!dup) {
				symbolTable.insertIdenfr(new ConstEntry(name, entryType, value));
				imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::ConstDefInt, 
					new IMItem(name, IMItemKind::Const, EntryType::INT, value)));
			}
		}
		while (lexicalTable[sym_p].symbol == COMMA) {
			lexicalOutput();
			if (lexicalTable[sym_p].symbol != IDENFR) {
				popReg();
				return 0;
			}
			name = lexicalTable[sym_p].token;
			lexicalOutput();
			if (lexicalTable[sym_p].symbol != ASSIGN) {
				popReg();
				return 0;
			}
			lexicalOutput();
			if (!integer()) {
				errorHandler.intOrCharCon(lexicalTable[sym_p].lineNo);
				sym_p++;
				//popReg();
				//return 0;
			} else {
				value = integerValue; //从integer()的全局变量integerValue中获取值
				int dup = errorHandler.dupDefId(name, lexicalTable[sym_p].lineNo);
				if (!dup) {
					symbolTable.insertIdenfr(new ConstEntry(name, entryType, value));
					imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::ConstDefInt,
						new IMItem(name, IMItemKind::Const, EntryType::INT, value)));
				}
			}
		}
		output[out_p++] = "<常量定义>\n";
		return 1;
	} else if (lexicalTable[sym_p].symbol == CHARTK) {
		lexicalOutput();
		entryType = CHAR;
		if (lexicalTable[sym_p].symbol != IDENFR) {
			popReg();
			return 0;
		}
		name = lexicalTable[sym_p].token;
		lexicalOutput();
		if (lexicalTable[sym_p].symbol != ASSIGN) {
			popReg();
			return 0;
		}
		lexicalOutput();
		if (lexicalTable[sym_p].symbol != CHARCON) { //int & char，是CHARCON不是CONSTTK
			errorHandler.intOrCharCon(lexicalTable[sym_p].lineNo);
			//popReg();
			//return 0;
		} else {
			value = int((lexicalTable[sym_p].token).at(0));
			int dup = errorHandler.dupDefId(name, lexicalTable[sym_p].lineNo);
			if (!dup) {
				symbolTable.insertIdenfr(new ConstEntry(name, entryType, value));
				imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::ConstDefChar,
					new IMItem(name, IMItemKind::Const, EntryType::CHAR, value)));
			}
		}
		lexicalOutput(); //int & char
		while (lexicalTable[sym_p].symbol == COMMA) {
			lexicalOutput();
			if (lexicalTable[sym_p].symbol != IDENFR) {
				popReg();
				return 0;
			}
			name = lexicalTable[sym_p].token;
			lexicalOutput();
			if (lexicalTable[sym_p].symbol != ASSIGN) {
				popReg();
				return 0;
			}
			lexicalOutput();
			if (lexicalTable[sym_p].symbol != CHARCON) { //int & char，是CHARCON不是CONSTTK
				errorHandler.intOrCharCon(lexicalTable[sym_p].lineNo);
				//popReg();
				//return 0;
			} else {
				value = int((lexicalTable[sym_p].token).at(0));
				int dup = errorHandler.dupDefId(name, lexicalTable[sym_p].lineNo);
				if (!dup) {
					symbolTable.insertIdenfr(new ConstEntry(name, entryType, value));
					imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::ConstDefChar,
						new IMItem(name, IMItemKind::Const, EntryType::CHAR, value)));
				}
				lexicalOutput(); //int & char
			}
		}
		output[out_p++] = "<常量定义>\n";
		return 1;
	} else {
		popReg();
		return 0;
	}
}

//＜无符号整数＞  :: = ＜非零数字＞｛＜数字＞｝ | 0
// 词法分析解决
int GrammarAnalyzer::unsignedInteger() {
	pushReg();
	if (lexicalTable[sym_p].symbol != INTCON) {
		popReg();
		return 0;
	}
	int value = stoi(lexicalTable[sym_p].token) + 1; //+1，即0->1, 1->2, ...
	lexicalOutput();
	output[out_p++] = "<无符号整数>\n";
	return value;
	/*pushReg();
	if (lexicalTable[sym_p].symbol == INTCON) {
		lexicalOutput();
		output[out_p++] = "<无符号整数>\n";
		return 1;
	} else {
		popReg();
		return 0;
	}*/
}

//＜整数＞        ::= ［＋｜－］＜无符号整数＞
int GrammarAnalyzer::integer() {
	pushReg();
	int negFlag = 1;
	int value;
	if (lexicalTable[sym_p].symbol == PLUS || lexicalTable[sym_p].symbol == MINU) {
		if (lexicalTable[sym_p].symbol == MINU) negFlag = -1;
		lexicalOutput();
	}
	if ((value = unsignedInteger()) == 0) {
		popReg();
		return 0;
	}
	integerValue = (value - 1) * negFlag;
	output[out_p++] = "<整数>\n";
	return 1;
	/*pushReg();
	if (lexicalTable[sym_p].symbol == PLUS || lexicalTable[sym_p].symbol == MINU) {
		lexicalOutput();
	}
	if (unsignedInteger()) {
		output[out_p++] = "<整数>\n";
		return 1;
	} else {
		popReg();
		return 0;
	}*/
}

//＜声明头部＞   ::=  int＜标识符＞ |char＜标识符＞
int GrammarAnalyzer::returnFunctionDefinitionHead() {
	// 1 for int, 2 for char
	pushReg();
	if (lexicalTable[sym_p].symbol != INTTK && lexicalTable[sym_p].symbol != CHARTK) {
		popReg();
		return 0;
	}
	int ret = (lexicalTable[sym_p].symbol == INTTK) ? 1 : 2;
	lexicalOutput();
	if (lexicalTable[sym_p].symbol != IDENFR) {
		popReg();
		return 0;
	}
	// int dup = errorHandler.dupDefFuncId(lexicalTable[sym_p].token);
	lexicalOutput();
	output[out_p++] = "<声明头部>\n";
	return ret;
}

//＜变量说明＞  ::= ＜变量定义＞;{＜变量定义＞;}
//<变量说明>与<有返回值函数定义>均以int|char开始
int GrammarAnalyzer::variableDeclaration() {
	pushReg();
	int count = 0;
	while (variableDefinition()) {
		count++;
		if (lexicalTable[sym_p].symbol != SEMICN) {
			if (lexicalTable[sym_p].symbol == LPARENT) { //是<有返回值函数定义>
				symbolTable.removeIdenfr();
				popReg();
				count--;
				break;
			} else { //错误处理：应为分号
				errorHandler.semicolon(lexicalTable[sym_p-1].lineNo); //sym_p - 1
			}
			//popReg();
			//break; //return 0;  是break而不是return 0;  像预读一样都需要特判
		} else {
			lexicalOutput();
		}
	}
	if (count == 0) {
		popReg();
		return 0;
	}
	output[out_p++] = "<变量说明>\n";
	return 1;
}

//＜变量定义＞  ::= ＜类型标识符＞＜标识符＞['['＜无符号整数＞']']{, ＜标识符＞['['＜无符号整数＞']'] }  (无符号整数大于0)
int GrammarAnalyzer::variableDefinition() {
	pushReg();
	string name;
	EntryType entryType;
	IMOpType imOpType;
	int arrSize = 1;
	if (lexicalTable[sym_p].symbol != INTTK && lexicalTable[sym_p].symbol != CHARTK) {
		popReg();
		return 0;
	}
	entryType = (lexicalTable[sym_p].symbol == INTTK) ? INT : CHAR;
	imOpType = (entryType == EntryType::CHAR) ? IMOpType::VarDefChar : IMOpType::VarDefInt;
	IMItemKind imItemKind = (glbFlag == 1) ? IMItemKind::GlbVar : IMItemKind::LcVar;
	lexicalOutput();
	if (lexicalTable[sym_p].symbol != IDENFR) {
		popReg();
		return 0;
	}
	name = lexicalTable[sym_p].token;
	lexicalOutput();
	/*if (lexicalTable[sym_p].symbol == LPARENT) { //特判！区分<变量定义>与<有返回值函数定义>
		popReg();
		return 0;
	}*/
	if (lexicalTable[sym_p].symbol == LBRACK) {
		lexicalOutput();
		if ((arrSize = unsignedInteger()) == 0) {
			popReg();
			return 0;
		}
		arrSize--;
		if (lexicalTable[sym_p].symbol != RBRACK) {
			errorHandler.rBracket(lexicalTable[sym_p].lineNo);
			//popReg();
			//return 0;
		} else {
			lexicalOutput();
		}
	}
	int dup = errorHandler.dupDefId(name, lexicalTable[sym_p].lineNo);
	if (!dup) {
		varOffset += 4 * arrSize;
		symbolTable.insertIdenfr(new VarEntry(name, entryType, arrSize, varOffset));
		
		imCode.insertIMCodeEntry(new IMCodeEntry(imOpType, new IMItem(name, imItemKind, entryType, varOffset)));
	}
	arrSize = 1;
	while (lexicalTable[sym_p].symbol == COMMA) {
		lexicalOutput();
		if (lexicalTable[sym_p].symbol != IDENFR) {
			popReg();
			return 0;
		}
		name = lexicalTable[sym_p].token;
		lexicalOutput();
		if (lexicalTable[sym_p].symbol == LBRACK) {
			lexicalOutput();
			if ((arrSize = unsignedInteger()) == 0) {
				popReg();
				return 0;
			}
			arrSize--;
			if (lexicalTable[sym_p].symbol != RBRACK) {
				errorHandler.rBracket(lexicalTable[sym_p].lineNo);
				//popReg();
				//return 0;
			}
			lexicalOutput();
		}
		int dup = errorHandler.dupDefId(name, lexicalTable[sym_p].lineNo);
		if (!dup) {
			varOffset += 4 * arrSize;
			symbolTable.insertIdenfr(new VarEntry(name, entryType, arrSize, varOffset));

			imCode.insertIMCodeEntry(new IMCodeEntry(imOpType, new IMItem(name, imItemKind, entryType, varOffset)));
		}
		arrSize = 1;
	}
	output[out_p++] = "<变量定义>\n";
	return 1;
}

//＜有返回值函数定义＞  :: = ＜声明头部＞'('＜参数表＞')' '{'＜复合语句＞'}'
int GrammarAnalyzer::returnFunctionDefinition() {
	pushReg();
	int retint;
	EntryType retType;
	string name;
	if ((retint = returnFunctionDefinitionHead()) == 0) { //!returnFunctionDefinitionHead()为1 <-> returnFunctionDefinitionHead()==0
		popReg();
		return 0;
	}
	retType = (retint == 1) ? INT : CHAR;
	funcRetType = retType;
	name = lexicalTable[sym_p - 1].token;
	//函数表，有返回值函数
	//function_table.insert(pair<string, int>(lexicalTable[sym_p - 1].token, 1)); // 1 for return
	if (lexicalTable[sym_p].symbol != LPARENT) {
		popReg();
		return 0;
	}
	lexicalOutput();
	if (retType == EntryType::INT) {
		imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::FuncDefInt, new IMItem(name, IMItemKind::String, EntryType::STRING)));
	} else {
		imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::FuncDefChar, new IMItem(name, IMItemKind::String, EntryType::STRING)));
	}
	varOffset += 8;//4 for ra, 4 for preSp
	if (!parameterList()) {
		popReg();
		return 0;
	}
	int dup = errorHandler.dupDefFuncId(name, lexicalTable[sym_p].lineNo);
	if (!dup) {
		symbolTable.insertFunc(new FuncEntry(name, retType));
		curFuncDefPtr = symbolTable.getCurFunDefPtr();
	}
	if (lexicalTable[sym_p].symbol != RPARENT) {
		errorHandler.rParent(lexicalTable[sym_p-1].lineNo); //sym_p - 1
		//popReg();
		//return 0;
	} else {
		lexicalOutput();
	}
	if (lexicalTable[sym_p].symbol != LBRACE) {
		popReg();
		return 0;
	}
	lexicalOutput();
	if (!compoundStatement()) {
		popReg();
		return 0;
	}
	if (lexicalTable[sym_p].symbol != RBRACE) {
		popReg();
		return 0;
	}
	/*
	EntryType realRetType;
	if (funcRet == 0) realRetType = VOID;
	else if (funcRet == 1) realRetType = INT;
	else realRetType = CHAR;
	if (retType != realRetType) {
		errorHandler.retfuncReturnUnmatch(lexicalTable[sym_p].lineNo);
	}*/
	if (hasRetStatement == false) {
		errorHandler.retfuncReturnUnmatch(lexicalTable[sym_p].lineNo);
	} // 在'}'的lexicalOutput()之前
	lexicalOutput();
	output[out_p++] = "<有返回值函数定义>\n";
	return 1;
}

//＜无返回值函数定义＞  :: = void＜标识符＞'('＜参数表＞')''{'＜复合语句＞'}'
int GrammarAnalyzer::nonReturnFunctionDefinition() {
	pushReg();
	EntryType retType = VOID;
	funcRetType = retType;
	string name;
	if (lexicalTable[sym_p].symbol != VOIDTK) {
		popReg();
		return 0;
	}
	lexicalOutput();
	if (lexicalTable[sym_p].symbol != IDENFR) {
		popReg();
		return 0;
	}
	name = lexicalTable[sym_p].token;
	int dup = errorHandler.dupDefFuncId(name, lexicalTable[sym_p].lineNo);
	lexicalOutput();
	//函数表，无返回值函数
	//function_table.insert(pair<string, int>(lexicalTable[sym_p - 1].token, 0)); // 0 for non-return
	if (lexicalTable[sym_p].symbol != LPARENT) {
		popReg();
		return 0;
	}
	lexicalOutput();
	imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::FuncDefVoid, new IMItem(name, IMItemKind::String, EntryType::STRING)));
	varOffset += 8;//4 for ra, 4 for preSp
	if (!parameterList()) {
		popReg();
		return 0;
	}
	if (!dup) {
		symbolTable.insertFunc(new FuncEntry(name, retType));
		curFuncDefPtr = symbolTable.getCurFunDefPtr();
	}
	if (lexicalTable[sym_p].symbol != RPARENT) {
		errorHandler.rParent(lexicalTable[sym_p-1].lineNo); //sym_p - 1
		//popReg();
		//return 0;
	} else {
		lexicalOutput();
	}
	if (lexicalTable[sym_p].symbol != LBRACE) {
		popReg();
		return 0;
	}
	lexicalOutput();
	
	if (!compoundStatement()) {
		popReg();
		return 0;
	}
	if (lexicalTable[sym_p].symbol != RBRACE) {
		popReg();
		return 0;
	}
	/*
	EntryType realRetType;
	if (funcRet == 0) realRetType = VOID;
	else if (funcRet == 1) realRetType = INT;
	else realRetType = CHAR;
	if (retType != realRetType) {
		errorHandler.nonretfuncReturnUnmatch(lexicalTable[sym_p].lineNo);
	}*/
	lexicalOutput();
	imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::NonRetFuncReturn));
	output[out_p++] = "<无返回值函数定义>\n";
	return 1;
}

//＜复合语句＞   ::=  ［＜常量说明＞］［＜变量说明＞］＜语句列＞
int GrammarAnalyzer::compoundStatement() {
	pushReg();
	if (constDeclaration()) {}
	if (variableDeclaration()) {}
	if (!statementsBlock()) {
		popReg();
		return 0;
	}
	output[out_p++] = "<复合语句>\n";
	return 1;
}

//＜参数表＞    ::=  ＜类型标识符＞＜标识符＞{,＜类型标识符＞＜标识符＞}| ＜空＞
int GrammarAnalyzer::parameterList() {
	// 0 for error, i for (i-1) paras (i!=0)
	pushReg();
	EntryType entryType;
	string name;
	//int offset = 0;
	// 可以为空，注意写法
	if (lexicalTable[sym_p].symbol != INTTK && lexicalTable[sym_p].symbol != CHARTK) {
		output[out_p++] = "<参数表>\n";
		return 1;
	}
	entryType = (lexicalTable[sym_p].symbol == INTTK) ? INT : CHAR;
	lexicalOutput(); //顺序可能有问题！！！
	if (lexicalTable[sym_p].symbol != IDENFR) {
		popReg();
		return 0;
	}
	name = lexicalTable[sym_p].token;
	varOffset += 4;
	symbolTable.insertTempParas(new VarEntry(name, entryType, 1, varOffset), 1); //insertTempParas temp=1
	lexicalOutput();
	while (lexicalTable[sym_p].symbol == COMMA) { //{} 0次至无穷次
		lexicalOutput();
		if (lexicalTable[sym_p].symbol != INTTK && lexicalTable[sym_p].symbol != CHARTK) {
			popReg();
			return 0;
		}
		entryType = (lexicalTable[sym_p].symbol == INTTK) ? INT : CHAR;
		lexicalOutput();
		if (lexicalTable[sym_p].symbol != IDENFR) {
			popReg();
			return 0;
		}
		name = lexicalTable[sym_p].token;
		varOffset += 4;
		symbolTable.insertTempParas(new VarEntry(name, entryType, 1, varOffset), 1); //insertTempParas temp=1
		lexicalOutput();
	}
	output[out_p++] = "<参数表>\n";
	return 1;
}

//＜主函数＞    ::= void main‘(’‘)’ ‘{’＜复合语句＞‘}’
int GrammarAnalyzer::mainFunction() {
	pushReg();
	if (lexicalTable[sym_p].symbol != VOIDTK) {
		popReg();
		return 0;
	}
	lexicalOutput();
	if (lexicalTable[sym_p].symbol != MAINTK) {
		popReg();
		return 0;
	}
	lexicalOutput();
	if (lexicalTable[sym_p].symbol != LPARENT) {
		popReg();
		return 0;
	}
	lexicalOutput();
	if (lexicalTable[sym_p].symbol != RPARENT) {
		errorHandler.rParent(lexicalTable[sym_p-1].lineNo); //sym_p - 1
		//popReg();
		//return 0;
	} else {
		lexicalOutput();
	}
	if (lexicalTable[sym_p].symbol != LBRACE) {
		popReg();
		return 0;
	}
	lexicalOutput();
	imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::Label, new IMItem("main", IMItemKind::String, EntryType::STRING)));
	varOffset += 8;//4 for ra, 4 for preSp
	if (!compoundStatement()) {
		popReg();
		return 0;
	}
	if (lexicalTable[sym_p].symbol != RBRACE) {
		popReg();
		return 0;
	}
	lexicalOutput();
	imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::NonRetFuncReturn, new IMItem("ra", IMItemKind::LcVar, EntryType::INT, 4)));
	output[out_p++] = "<主函数>\n";
	return 1;
}


//＜表达式＞    ::= ［＋｜－］＜项＞{＜加法运算符＞＜项＞}   //[+|-]只作用于第一个<项>
int GrammarAnalyzer::expression() {
	// 1 for int, 2 for char
	pushReg();
	int termCount = 0;
	int termRet;
	IMOpType imOpType = IMOpType::Add;
	if (lexicalTable[sym_p].symbol == PLUS || lexicalTable[sym_p].symbol == MINU) {
		imOpType = (lexicalTable[sym_p].symbol == PLUS) ? 
			IMOpType::Add : IMOpType::Sub;
		if (imOpType == IMOpType::Sub) {
			IMItem* item1 = new IMItem("0", IMItemKind::Const, EntryType::INT, 0);
			pushExpStack(item1);
		}
		lexicalOutput(); //处理[+|-]
	}
	if ((termRet = term()) == 0) {
		popReg();
		return 0;
	}
	termCount++;
	if (imOpType == IMOpType::Sub) {
		genExpIMCode(imOpType);
	}
	while (lexicalTable[sym_p].symbol == PLUS || lexicalTable[sym_p].symbol == MINU) {
		imOpType = (lexicalTable[sym_p].symbol == PLUS) ?
			IMOpType::Add : IMOpType::Sub;
		lexicalOutput();
		if (!term()) {
			popReg();
			return 0;
		}
		termCount++;
		genExpIMCode(imOpType);
	}
	output[out_p++] = "<表达式>\n";
	if (termCount > 1) return 1;
	else return termRet;
}

void GrammarAnalyzer::genExpIMCode(IMOpType imOpType) {
	IMItem* item2 = popExpStack();
	IMItem* item1 = popExpStack();
	IMItem* item3;
	if (item2->getKind() == IMItemKind::Const && item1->getKind() == IMItemKind::Const) {
		// 常量优化
		int value1 = item1->getValue();
		int value2 = item2->getValue();
		int value;
		switch (imOpType)
		{
		case IMOpType::Add:
			value = value1 + value2;
			break;
		case IMOpType::Sub:
			value = value1 - value2;
			break;
		case IMOpType::Mult:
			value = value1 * value2;
			break;
		case IMOpType::Div:
			value = value1 / value2;
			break;
		default:
			throw "In expression(), const ? const";
			break;
		}
		item3 = new IMItem(to_string(value), IMItemKind::Const, EntryType::INT, value);
	} else {
		// 含有变量
		if (item1->getKind() == IMItemKind::TempVar) {
			item3 = item1;
		} else if (item2->getKind() == IMItemKind::TempVar) {
			item3 = item2;
		} else {
			varOffset += 4;
			item3 = new IMItem(genTempVarName(), IMItemKind::TempVar, EntryType::INT, varOffset);
		}
		imCode.insertIMCodeEntry(new IMCodeEntry(imOpType, item1, item2, item3));
	}
	pushExpStack(item3);
}

//＜项＞     :: = ＜因子＞{ ＜乘法运算符＞＜因子＞ }
int GrammarAnalyzer::term() {
	// 1 for int, 2 for char
	pushReg();
	int factorCount = 0;
	int factorRet;
	IMOpType imOpType = IMOpType::Mult;
	if ((factorRet = factor()) == 0) {
		popReg();
		return 0;
	}
	factorCount++;
	while (lexicalTable[sym_p].symbol == MULT || lexicalTable[sym_p].symbol == DIV) {
		imOpType = (lexicalTable[sym_p].symbol == MULT) ?
			IMOpType::Mult : IMOpType::Div;
		lexicalOutput();
		if (!factor()) {
			popReg();
			return 0;
		}
		factorCount++;
		genExpIMCode(imOpType);
	}
	output[out_p++] = "<项>\n";
	if (factorCount > 1) return 1;
	else return factorRet;
}

//＜因子＞    :: = ＜标识符＞['['＜表达式＞']'] | '('＜表达式＞')'｜＜整数＞ | ＜字符＞｜＜有返回值函数调用语句＞
//<有返回值函数调用语句>和<标识符>均以<标识符>开始
int GrammarAnalyzer::factor() {
	// 1 for int, 2 for char
	pushReg();
	int ret;
	IMItem* funcRetItem;
	int expRet;
	if (lexicalTable[sym_p].symbol == IDENFR) {
		if ((funcRetItem = returnFunctionCall()) != 0) { //<有返回值函数调用语句>
			ret = (funcRetItem->getType() == EntryType::INT) ? 1 : 2;
			pushExpStack(funcRetItem);
			output[out_p++] = "<因子>\n";
			return ret;
		}
		string name = lexicalTable[sym_p].token;
		int undef = errorHandler.undefId(name, lexicalTable[sym_p].lineNo);
		ret = symbolTable.getIdType(name); // 1 for int, 2 for char
		if (!undef) {
			IMItem* item = symbolTable.findIMItem(name);
			pushExpStack(item);
		}
		lexicalOutput();
		if (lexicalTable[sym_p].symbol == LBRACK) {
			lexicalOutput();
			if ((expRet = expression()) == 0) {
				popReg();
				return 0;
			}
			if (expRet != 1) {
				errorHandler.arrayIndexInt(lexicalTable[sym_p].lineNo);
			}
			genExpIMCode(IMOpType::AssignArray);
			if (lexicalTable[sym_p].symbol != RBRACK) {
				errorHandler.rBracket(lexicalTable[sym_p].lineNo);
				//popReg();
				//return 0;
			} else {
				lexicalOutput();
			}
		}
		output[out_p++] = "<因子>\n";
		return ret;
	} else if (lexicalTable[sym_p].symbol == LPARENT) {
		lexicalOutput();
		if (!expression()) {
			popReg();
			return 0;
		}
		if (lexicalTable[sym_p].symbol != RPARENT) {
			errorHandler.rParent(lexicalTable[sym_p-1].lineNo); //sym_p - 1
			//popReg();
			//return 0;
		} else {
			lexicalOutput();
		}
		output[out_p++] = "<因子>\n";
		return 1;
	} else if (integer()) {
		IMItem* imItem = new IMItem(to_string(integerValue), IMItemKind::Const, EntryType::INT, integerValue);
		pushExpStack(imItem);
		output[out_p++] = "<因子>\n";
		return 1;
	} else if (lexicalTable[sym_p].symbol == CHARCON) {
		int value = int(lexicalTable[sym_p].token[0]);
		IMItem* imItem = new IMItem(to_string(value), IMItemKind::Const, EntryType::CHAR, value);
		pushExpStack(imItem);
		lexicalOutput();
		output[out_p++] = "<因子>\n";
		return 2;
	} else {
		popReg();
		return 0;
	}
}

//＜语句＞    :: = ＜条件语句＞｜＜循环语句＞ | '{'＜语句列＞'}' | ＜有返回值函数调用语句＞;
// |＜无返回值函数调用语句＞;｜＜赋值语句＞;｜＜读语句＞;｜＜写语句＞; |＜返回语句＞;｜＜空＞;
int GrammarAnalyzer::statement() {
	if (lexicalTable[sym_p].symbol == RBRACE) { //特判，复合语句中的语句列为空
		return 0;
	}
	pushReg();
	if (conditionStatement()) {
		output[out_p++] = "<语句>\n";
		return 1;
	} else if (loopStatement()) {
		output[out_p++] = "<语句>\n";
		return 1;
	} else if (lexicalTable[sym_p].symbol == LBRACE) {
		lexicalOutput();
		if (!statementsBlock()) {
			popReg();
			return 0;
		}
		if (lexicalTable[sym_p].symbol != RBRACE) {
			popReg();
			return 0;
		}
		lexicalOutput();
		output[out_p++] = "<语句>\n";
		return 1;
	} else {
		if (returnFunctionCall()) {
		} else if (nonReturnFunctionCall()) {
		} else if (assignStatement()) {
		} else if (readStatement()) {
		} else if (writeStatement()) {
		} else if (returnStatement()) {
		} else {
		}
		if (lexicalTable[sym_p].symbol != SEMICN) {
			errorHandler.semicolon(lexicalTable[sym_p-1].lineNo); //sym_p - 1
			//popReg();
			//return 0;
		} else {
			lexicalOutput();
		}
		output[out_p++] = "<语句>\n";
		return 1;
	}
}

//＜赋值语句＞   ::=  ＜标识符＞['['＜表达式＞']']＝＜表达式＞
int GrammarAnalyzer::assignStatement() {
	pushReg();
	string name;
	int expRet;
	IMOpType imOpType = IMOpType::Assign;
	if (lexicalTable[sym_p].symbol != IDENFR) {
		popReg();
		return 0;
	}
	name = lexicalTable[sym_p].token;
	int undef = errorHandler.undefId(name, lexicalTable[sym_p].lineNo);
	int conchange = errorHandler.constChange(name, lexicalTable[sym_p].lineNo);
	if (!undef && !conchange) {
		IMItem* imItem = symbolTable.findIMItem(name);
		pushExpStack(imItem);
	}
	lexicalOutput();
	if (lexicalTable[sym_p].symbol == LBRACK) {
		lexicalOutput();
		if ((expRet = expression()) == 0) {
			popReg();
			return 0;
		}
		if (expRet != 1) {
			errorHandler.arrayIndexInt(lexicalTable[sym_p].lineNo);
		}
		if (lexicalTable[sym_p].symbol != RBRACK) {
			errorHandler.rBracket(lexicalTable[sym_p].lineNo);
			//popReg();
			//return 0;
		} else {
			lexicalOutput();
			imOpType = IMOpType::ArrayAssign;
		}
	}
	if (lexicalTable[sym_p].symbol != ASSIGN) {
		popReg();
		return 0;
	}
	lexicalOutput();
	if (!expression()) {
		popReg();
		return 0;
	}
	genAssignIMCode(imOpType);
	output[out_p++] = "<赋值语句>\n";
	return 1;
}

void GrammarAnalyzer::genAssignIMCode(IMOpType imOpType) {
	IMItem* item1 = popExpStack();
	IMItem* item2 = popExpStack();
	if (imOpType == IMOpType::Assign) {
		imCode.insertIMCodeEntry(new IMCodeEntry(imOpType, item1, item2));
	} else if (imOpType == IMOpType::ArrayAssign) {
		IMItem* item3 = popExpStack();
		imCode.insertIMCodeEntry(new IMCodeEntry(imOpType, item1, item2, item3));
	}
}

//＜条件语句＞  ::= if '('＜条件＞')'＜语句＞［else＜语句＞］
int GrammarAnalyzer::conditionStatement() {
	pushReg();
	if (lexicalTable[sym_p].symbol != IFTK) {
		popReg();
		return 0;
	}
	lexicalOutput();
	if (lexicalTable[sym_p].symbol != LPARENT) {
		popReg();
		return 0;
	}
	lexicalOutput();
	if (!condition()) {
		popReg();
		return 0;
	}
	string ifNum = genIfLabelNum();
	//genBranchIMCode(LabelType::If, ifNum);
	string if_end = "if_" + ifNum + "_end";
	IMItem* item2 = popExpStack();
	IMItem* item1 = popExpStack();
	imCode.insertIMCodeEntry(new IMCodeEntry(branchType, item1, item2, new IMItem(if_end, IMItemKind::String, EntryType::STRING)));
	if (lexicalTable[sym_p].symbol != RPARENT) {
		errorHandler.rParent(lexicalTable[sym_p-1].lineNo); //sym_p - 1
		//popReg();
		//return 0;
	} else {
		lexicalOutput();
	}
	if (!statement()) {
		popReg();
		return 0;
	}
	if (lexicalTable[sym_p].symbol == ELSETK) {
		string else_end = "else_" + ifNum + "_end";
		imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::Jump, new IMItem(else_end, IMItemKind::String, EntryType::STRING)));
		imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::Label, new IMItem(if_end, IMItemKind::String, EntryType::STRING))); //顺序
		lexicalOutput();
		if (!statement()) {
			popReg();
			return 0;
		}
		imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::Label, new IMItem(else_end, IMItemKind::String, EntryType::STRING)));
	} else {
		imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::Label, new IMItem(if_end, IMItemKind::String, EntryType::STRING))); //else中生成IMCode
	}
	output[out_p++] = "<条件语句>\n";
	return 1;
}



//＜条件＞    ::=  ＜表达式＞[＜关系运算符＞＜表达式＞]
int GrammarAnalyzer::condition() {
	//1 for ＜表达式＞, 2 for ＜表达式＞＜关系运算符＞＜表达式＞
	pushReg();
	int expRet;
	if ((expRet = expression()) == 0) {
		popReg();
		return 0;
	}
	if (expRet != 1) {
		errorHandler.illegalTypeInCondition(lexicalTable[sym_p].lineNo);
	}
	//＜关系运算符＞  :: = <｜ <= ｜>｜ >= ｜ != ｜ ==
	if (lexicalTable[sym_p].symbol == LSS || lexicalTable[sym_p].symbol == LEQ ||
		lexicalTable[sym_p].symbol == GRE || lexicalTable[sym_p].symbol == GEQ ||
		lexicalTable[sym_p].symbol == NEQ || lexicalTable[sym_p].symbol == EQL) {
		branchType = conditionMap.find(lexicalTable[sym_p].symbol)->second; //IMCode: branchType
		lexicalOutput();
		if ((expRet = expression()) == 0) {
			popReg();
			return 0;
		}
		if (expRet != 1) {
			errorHandler.illegalTypeInCondition(lexicalTable[sym_p].lineNo);
		}
		output[out_p++] = "<条件>\n";
		return 2;
	}
	branchType = IMOpType::Beq;
	IMItem* imItem_int0 = new IMItem("0", IMItemKind::Const, EntryType::INT, 0);
	pushExpStack(imItem_int0);
	output[out_p++] = "<条件>\n";
	return 1;
}

//＜循环语句＞   ::=  while '('＜条件＞')'＜语句＞| do＜语句＞while '('＜条件＞')' |
//for'('＜标识符＞＝＜表达式＞;＜条件＞;＜标识符＞＝＜标识符＞(+|-)＜步长＞')'＜语句＞
int GrammarAnalyzer::loopStatement() {
	pushReg();
	if (lexicalTable[sym_p].symbol == WHILETK) {
	//while '('＜条件＞')'＜语句＞
		string whileNum = genWhileLabelNum();
		string while_begin = "while_" + whileNum + "_begin";
		imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::Label, new IMItem(while_begin, IMItemKind::String, EntryType::STRING)));
		lexicalOutput();
		if (lexicalTable[sym_p].symbol != LPARENT) {
			popReg();
			return 0;
		}
		lexicalOutput();
		if (!condition()) {
			popReg();
			return 0;
		}
		string while_end = "while_" + whileNum + "_end";
		IMItem* item2 = popExpStack();
		IMItem* item1 = popExpStack();
		imCode.insertIMCodeEntry(new IMCodeEntry(branchType, item1, item2, new IMItem(while_end, IMItemKind::String, EntryType::STRING)));
		if (lexicalTable[sym_p].symbol != RPARENT) {
			errorHandler.rParent(lexicalTable[sym_p-1].lineNo); //sym_p - 1
			//popReg();
			//return 0;
		} else {
			lexicalOutput();
		}
		if (!statement()) {
			popReg();
			return 0;
		}
		imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::Jump, new IMItem(while_begin, IMItemKind::String, EntryType::STRING)));
		imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::Label, new IMItem(while_end, IMItemKind::String, EntryType::STRING)));
		output[out_p++] = "<循环语句>\n";
		return 1;
	} else if (lexicalTable[sym_p].symbol == DOTK) {
	//do＜语句＞while '('＜条件＞')' 
		lexicalOutput();
		string dowhileNum = genDoWhileLabelNum();
		string dowhile_begin = "dowhile_" + dowhileNum + "_begin";
		imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::Label, new IMItem(dowhile_begin, IMItemKind::String, EntryType::STRING)));
		if (!statement()) {
			popReg();
			return 0;
		}
		if (lexicalTable[sym_p].symbol != WHILETK) {
			errorHandler.lackWhileInDowhile(lexicalTable[sym_p].lineNo);
			//popReg();
			//return 0;
		} else {
			lexicalOutput();
		}
		if (lexicalTable[sym_p].symbol != LPARENT) {
			popReg();
			return 0;
		}
		lexicalOutput();
		if (!condition()) {
			popReg();
			return 0;
		}
		string dowhile_end = "dowhile_" + dowhileNum + "_end";
		IMItem* item2 = popExpStack();
		IMItem* item1 = popExpStack();
		imCode.insertIMCodeEntry(new IMCodeEntry(branchType, item1, item2, new IMItem(dowhile_end, IMItemKind::String, EntryType::STRING)));
		imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::Jump, new IMItem(dowhile_begin, IMItemKind::String, EntryType::STRING)));
		imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::Label, new IMItem(dowhile_end, IMItemKind::String, EntryType::STRING)));
		if (lexicalTable[sym_p].symbol != RPARENT) {
			errorHandler.rParent(lexicalTable[sym_p-1].lineNo); //sym_p - 1
			//popReg();
			//return 0;
		} else {
			lexicalOutput();
		}
		output[out_p++] = "<循环语句>\n";
		return 1;
	} else if (lexicalTable[sym_p].symbol == FORTK) {
	//for'('＜标识符＞＝＜表达式＞; ＜条件＞; ＜标识符＞＝＜标识符＞(+| -)＜步长＞')'＜语句＞
		lexicalOutput();
		if (lexicalTable[sym_p].symbol != LPARENT) {
			popReg();
			return 0;
		}
		lexicalOutput();
		//＜标识符＞＝＜表达式＞;
		if (lexicalTable[sym_p].symbol != IDENFR) {
			popReg();
			return 0;
		}
		string name = lexicalTable[sym_p].token;
		int undef = errorHandler.undefId(name, lexicalTable[sym_p].lineNo);
		int conchange = errorHandler.constChange(name, lexicalTable[sym_p].lineNo); //改变常量
		if (!undef && !conchange) {
			IMItem* item = symbolTable.findIMItem(name);
			pushExpStack(item);
		}
		lexicalOutput();
		if (lexicalTable[sym_p].symbol != ASSIGN) {
			popReg();
			return 0;
		}
		lexicalOutput();
		if (!expression()) {
			popReg();
			return 0;
		}
		genAssignIMCode(IMOpType::Assign);
		if (lexicalTable[sym_p].symbol != SEMICN) {
			errorHandler.semicolon(lexicalTable[sym_p].lineNo); //sym_p 不-1
			//popReg();
			//return 0;
		} else {
			lexicalOutput();
		}
		//＜条件＞;
		string forNum = genForLabelNum();
		string for_begin = "for_" + forNum + "_begin";
		imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::Label, new IMItem(for_begin, IMItemKind::String, EntryType::STRING)));
		if (!condition()) {
			popReg();
			return 0;
		}
		string for_end = "for_" + forNum + "_end";
		IMItem* condition_item2 = popExpStack();
		IMItem* condition_item1 = popExpStack();
		imCode.insertIMCodeEntry(new IMCodeEntry(branchType, condition_item1, condition_item2, new IMItem(for_end, IMItemKind::String, EntryType::STRING)));
		if (lexicalTable[sym_p].symbol != SEMICN) {
			errorHandler.semicolon(lexicalTable[sym_p].lineNo); //sym_p 不-1
			//popReg();
			//return 0;
		} else {
			lexicalOutput();
		}
		//＜标识符＞＝＜标识符＞(+| -)＜步长＞
		IMItem* item1; // 标识符1
		IMItem* item2; // 标识符2
		IMItem* item3; // 步长
		IMOpType imOpType; // +|-
		if (lexicalTable[sym_p].symbol != IDENFR) {
			popReg();
			return 0;
		}
		string name1 = lexicalTable[sym_p].token;
		int undef1 = errorHandler.undefId(name1, lexicalTable[sym_p].lineNo);
		int conchange1 = errorHandler.constChange(name1, lexicalTable[sym_p].lineNo); //改变常量
		if (!undef1 && !conchange1) {
			item1 = symbolTable.findIMItem(name1);
			//pushExpStack(item1);
		} //<标识符1>
		lexicalOutput();
		if (lexicalTable[sym_p].symbol != ASSIGN) {
			popReg();
			return 0;
		}
		lexicalOutput();
		if (lexicalTable[sym_p].symbol != IDENFR) {
			popReg();
			return 0;
		}
		string name2 = lexicalTable[sym_p].token;
		int undef2 = errorHandler.undefId(name1, lexicalTable[sym_p].lineNo);
		if (!undef2) {
			item2 = symbolTable.findIMItem(name2);
			//pushExpStack(item2);
		} //<标识符1>
		lexicalOutput();
		if (lexicalTable[sym_p].symbol != PLUS && lexicalTable[sym_p].symbol != MINU) {
			popReg();
			return 0;
		}
		imOpType = (lexicalTable[sym_p].symbol == PLUS) ? IMOpType::Add : IMOpType::Sub;
		lexicalOutput();
		int stepRet;
		if ((stepRet = step()) == 0) {
			popReg();
			return 0;
		}
		stepRet--;
		item3 = new IMItem(to_string(stepRet), IMItemKind::Const, EntryType::INT, stepRet);
		//pushExpStack(item3);
		if (lexicalTable[sym_p].symbol != RPARENT) {
			errorHandler.rParent(lexicalTable[sym_p-1].lineNo); //sym_p - 1
			//popReg();
			//return 0;
		} else {
			lexicalOutput();
		}
		if (!statement()) {
			popReg();
			return 0;
		}
		if (!undef1 && !conchange1 && !undef2) {
			pushExpStack(item1);
			pushExpStack(item2);
			pushExpStack(item3);
			genExpIMCode(imOpType);
			genAssignIMCode(IMOpType::Assign);
		}
		imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::Jump, new IMItem(for_begin, IMItemKind::String, EntryType::STRING)));
		imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::Label, new IMItem(for_end, IMItemKind::String, EntryType::STRING)));
		output[out_p++] = "<循环语句>\n";
		return 1;
	} else {
		popReg();
		return 0;
	}
}

//＜步长＞::= ＜无符号整数＞  
int GrammarAnalyzer::step() {
	pushReg();
	int uintRet;
	if ((uintRet = unsignedInteger()) == 0) {
		popReg();
		return 0;
	}
	output[out_p++] = "<步长>\n";
	return uintRet; //1->0, 2->1...
}

//＜有返回值函数调用语句＞ :: = ＜标识符＞'('＜值参数表＞')'
IMItem* GrammarAnalyzer::returnFunctionCall() {
	pushReg();
	string name;
	if (lexicalTable[sym_p].symbol != IDENFR) {
		popReg();
		return 0;
	}
	name = lexicalTable[sym_p].token;
	
	// 判断是否是 有返回值函数，插在输出<标识符>之前
	/*
	if (function_table.count(lexicalTable[sym_p].token) != 0 && 
		function_table.find(lexicalTable[sym_p].token)->second == 0) { //是 无返回值函数
		popReg();
		return 0;
	}*/
	if (!symbolTable.hasFunc(name) || symbolTable.findFuncRetType(name) == EntryType::VOID) {
		popReg();
		return 0;
	}
	lexicalOutput();
	if (lexicalTable[sym_p].symbol != LPARENT) {
		popReg();
		return 0;
	}
	lexicalOutput();
	int undef = errorHandler.undefFuncId(name, lexicalTable[sym_p].lineNo); //在'('之后判断
	

	if (!valueParameterList()) {
		popReg();
		return 0;
	}
	if (lexicalTable[sym_p].symbol != RPARENT) {
		errorHandler.rParent(lexicalTable[sym_p-1].lineNo); //sym_p - 1
		//popReg();
		//return 0;
	} else {
		lexicalOutput();
	}
	if (!undef) {
		errorHandler.paraUnmatch(name, lexicalTable[sym_p].lineNo);
	}
	symbolTable.clrTempParas();

	imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::FuncCall, 
		new IMItem("varOffset", IMItemKind::Const, EntryType::INT, varOffset), //const but whose name is not "1"
		new IMItem(name, IMItemKind::String, EntryType::STRING)));

	varOffset += 4;
	EntryType funcRetType = symbolTable.findFuncRetType(name);
	IMItem* funcRetItem = new IMItem(genTempVarName(), IMItemKind::TempVar, funcRetType, varOffset);
	imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::FuncCallRet, funcRetItem));

	output[out_p++] = "<有返回值函数调用语句>\n";
	return funcRetItem;
}

//＜无返回值函数调用语句＞ :: = ＜标识符＞'('＜值参数表＞')'
int GrammarAnalyzer::nonReturnFunctionCall() {
	pushReg();
	string name;
	if (lexicalTable[sym_p].symbol != IDENFR) {
		popReg();
		return 0;
	}
	name = lexicalTable[sym_p].token;
	// 判断是否是 无返回值函数，插在输出<标识符>之前
	/*
	if (function_table.count(lexicalTable[sym_p].token) != 0 && 
		function_table.find(lexicalTable[sym_p].token)->second == 1) { //是 有返回值函数
		popReg();
		return 0;
	}*/
	if (!symbolTable.hasFunc(name) || symbolTable.findFuncRetType(name) != EntryType::VOID) {
		popReg();
		return 0;
	}
	lexicalOutput();
	if (lexicalTable[sym_p].symbol != LPARENT) {
		popReg();
		return 0;
	}
	lexicalOutput();
	int undef = errorHandler.undefFuncId(name, lexicalTable[sym_p].lineNo); //在'('之后判断
	if (!valueParameterList()) {
		popReg();
		return 0;
	}
	if (lexicalTable[sym_p].symbol != RPARENT) {
		errorHandler.rParent(lexicalTable[sym_p-1].lineNo); //sym_p - 1
		//popReg();
		//return 0;
	} else {
		lexicalOutput();
	}
	if (!undef) {
		errorHandler.paraUnmatch(name, lexicalTable[sym_p].lineNo);
	}
	symbolTable.clrTempParas();

	imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::FuncCall,
		new IMItem("varOffset", IMItemKind::Const, EntryType::INT, varOffset), //const but whose name is not "1"
		new IMItem(name, IMItemKind::String, EntryType::STRING)));

	output[out_p++] = "<无返回值函数调用语句>\n";
	return 1;
}

//＜值参数表＞   :: = ＜表达式＞{ ,＜表达式＞ }｜＜空＞
int GrammarAnalyzer::valueParameterList() {
	pushReg();
	EntryType entryType;
	string name = "hhhhhh";
	int expRet;
	int paraCount = 0;
	// 可以为空的写法
	if ((expRet = expression()) == 0) {
		output[out_p++] = "<值参数表>\n";
		return 1;
	}
	entryType = (expRet == 1) ? INT : CHAR;
	symbolTable.insertTempParas(new VarEntry(name, entryType, 1, 0), 0); //insertTempParas type=0
	paraCount++;
	while (lexicalTable[sym_p].symbol == COMMA) {
		lexicalOutput();
		if ((expRet = expression()) == 0) {
			popReg();
			return 0;
		}
		entryType = (expRet == 1) ? INT : CHAR;
		symbolTable.insertTempParas(new VarEntry(name, entryType, 1, 0), 0); //insertTempParas type=0
		paraCount++;
	}
	vector<IMItem*> paraItems;
	IMItem* paraItem;
	for (int i = 0; i < paraCount; i++) {
		paraItems.push_back(popExpStack());
	}
	for (int i = 0; i < paraCount; i++) {
		paraItem = paraItems.back();
		imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::ParaInFuncCall, paraItem, 
			new IMItem("pos", IMItemKind::LcVar, paraItem->getType(), varOffset + 12 + i*4)));
		paraItems.pop_back();
	}
	output[out_p++] = "<值参数表>\n";
	return 1;
}

//＜语句列＞   :: = ｛＜语句＞｝
int GrammarAnalyzer::statementsBlock() {
	//pushReg(); //这里需要push嘛
	while (statement()) {}
	output[out_p++] = "<语句列>\n";
	return 1;
}

//＜读语句＞    :: = scanf '('＜标识符＞{ ,＜标识符＞ }')'
int GrammarAnalyzer::readStatement() {
	pushReg();
	bool varIsGlb;
	IMItemKind imItemKind;
	EntryType entryType;
	if (lexicalTable[sym_p].symbol != SCANFTK) {
		popReg();
		return 0;
	}
	lexicalOutput();
	if (lexicalTable[sym_p].symbol != LPARENT) {
		popReg();
		return 0;
	}
	lexicalOutput();
	if (lexicalTable[sym_p].symbol != IDENFR) {
		popReg();
		return 0;
	}
	string name = lexicalTable[sym_p].token;
	int undef = errorHandler.undefId(name, lexicalTable[sym_p].lineNo);
	int conchange = errorHandler.constChange(name, lexicalTable[sym_p].lineNo); //改变常量
	if (!undef && !conchange) {
		varIsGlb = symbolTable.isVarGlobal(name);
		int offset = symbolTable.getVarOffset(name, varIsGlb);
		imItemKind = varIsGlb ? IMItemKind::GlbVar : IMItemKind::LcVar;
		entryType = (symbolTable.getIdType(name) == 1) ? EntryType::INT : EntryType::CHAR; // 1 for int, 2 for char
		imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::Scanf, new IMItem(name, imItemKind, entryType, offset)));
	}
	lexicalOutput();
	
	while (lexicalTable[sym_p].symbol == COMMA) {
		lexicalOutput();
		if (lexicalTable[sym_p].symbol != IDENFR) {
			popReg();
			return 0;
		}
		string name = lexicalTable[sym_p].token;
		int undef = errorHandler.undefId(name, lexicalTable[sym_p].lineNo);
		int conchange = errorHandler.constChange(name, lexicalTable[sym_p].lineNo); //改变常量
		if (!undef && !conchange) {
			varIsGlb = symbolTable.isVarGlobal(name);
			int offset = symbolTable.getVarOffset(name, varIsGlb);
			imItemKind = varIsGlb ? IMItemKind::GlbVar : IMItemKind::LcVar;
			entryType = (symbolTable.getIdType(name) == 1) ? EntryType::INT : EntryType::CHAR; // 1 for int, 2 for char
			imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::Scanf, new IMItem(name, imItemKind, entryType, offset)));
		}
		lexicalOutput();
	}
	if (lexicalTable[sym_p].symbol != RPARENT) {
		errorHandler.rParent(lexicalTable[sym_p-1].lineNo); //sym_p - 1
		//popReg();
		//return 0;
	} else {
		lexicalOutput();
	}
	output[out_p++] = "<读语句>\n";
	return 1;
}

//＜写语句＞    :: = printf '(' (＜字符串＞[, ＜表达式＞] | ＜表达式＞) ')'
int GrammarAnalyzer::writeStatement() {
	pushReg();
	if (lexicalTable[sym_p].symbol != PRINTFTK) {
		popReg();
		return 0;
	}
	lexicalOutput();
	if (lexicalTable[sym_p].symbol != LPARENT) {
		popReg();
		return 0;
	}
	lexicalOutput();
	if (stringGrammar()) {
		imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::Printf, new IMItem(printStringName, IMItemKind::String, EntryType::STRING)));
		if (lexicalTable[sym_p].symbol == COMMA) {
			lexicalOutput();
			if (!expression()) {
				popReg();
				return 0;
			}
			IMItem* item;
			try {
				item = expStack.back();
			} catch (...) {
				throw "In writeStatement(), in expression()";
			}
			imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::Printf, item));
		}
	} else if (expression()) {
		IMItem* item;
		try {
			item = expStack.back();
		} catch (...) {
			throw "In writeStatement(), in expression()";
		}
		imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::Printf, item));
	} else {
		popReg();
		return 0;
	}
	if (lexicalTable[sym_p].symbol != RPARENT) {
		errorHandler.rParent(lexicalTable[sym_p-1].lineNo); //sym_p - 1
		//popReg();
		//return 0;
	} else {
		lexicalOutput();
	}
	imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::Printf, new IMItem("newline", IMItemKind::String, EntryType::STRING)));
	output[out_p++] = "<写语句>\n";
	return 1;
}

//＜返回语句＞   :: = return['('＜表达式＞')']
int GrammarAnalyzer::returnStatement() {
	pushReg();
	int expRet;
	if (lexicalTable[sym_p].symbol != RETURNTK) {
		popReg();
		return 0;
	}
	lexicalOutput();
	if (lexicalTable[sym_p].symbol == LPARENT) {
		lexicalOutput();
		if (funcRetType != VOID && lexicalTable[sym_p].symbol == RPARENT) { //有返回值函数：return()不匹配
			errorHandler.retfuncReturnUnmatch(lexicalTable[sym_p].lineNo);
		}
		if (funcRetType == VOID) { //无返回值函数：出现return(<表达式>)
			errorHandler.nonretfuncReturnUnmatch(lexicalTable[sym_p].lineNo);
		}
		if ((expRet = expression()) == 0) {
			popReg();
			return 0;
		}
		EntryType realRetType = (expRet == 1) ? INT : CHAR;
		if (funcRetType != VOID && funcRetType != realRetType) { //有返回值函数：return(int)不匹配char 或 return(char)不匹配int
			errorHandler.retfuncReturnUnmatch(lexicalTable[sym_p].lineNo);
		}
		if (lexicalTable[sym_p].symbol != RPARENT) {
			errorHandler.rParent(lexicalTable[sym_p-1].lineNo); //sym_p - 1
			//popReg();
			//return 0;
		} else {
			lexicalOutput();
		}
		IMItem* retItem = popExpStack();
		imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::RetFuncReturn, retItem));
	} else {
		imCode.insertIMCodeEntry(new IMCodeEntry(IMOpType::NonRetFuncReturn));
	}
	hasRetStatement = true;
	output[out_p++] = "<返回语句>\n";
	return 1;
}