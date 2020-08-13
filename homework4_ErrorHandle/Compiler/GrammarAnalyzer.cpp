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

GrammarAnalyzer& GrammarAnalyzer::initGrammarAnalyzer(LexicalAnalyzer& aLexicalAnalyzer, ofstream& fout, SymbolTable& aSymbolTable, ErrorHandler& aErrorHandler) {
	static GrammarAnalyzer singleton(aLexicalAnalyzer, fout, aSymbolTable, aErrorHandler);
	return singleton;
}

GrammarAnalyzer::GrammarAnalyzer(LexicalAnalyzer& aLexicalAnalyzer, ofstream& fout, SymbolTable& aSymbolTable, ErrorHandler& aErrorHandler) :
	lexicalAnalyzer(aLexicalAnalyzer), outputFile(fout), symbolTable(aSymbolTable), errorHandler(aErrorHandler){}


void GrammarAnalyzer::grammarAnalyze() {
	program();
	out_cnt = out_p;
#ifdef Grammar_STAGE
	for (int i = 0; i < out_cnt; i++) {
		outputFile << output[i];
	}
#endif // Grammar_STAGE
#ifdef ERROR_STAGE
	errorHandler.output();
#endif // ERROR_STAGE
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
	if (lexicalTable[sym_p].symbol != STRCON) {
		popReg();
		return 0;
	}
	lexicalOutput();
	output[out_p++] = "<字符串>\n";
	return 1;
	/*pushReg();
	if (lexicalTable[sym_p].symbol == STRCON) {
		lexicalOutput();
		output[out_p++] = "<字符串>\n";
		return 1;
	} else {
		popReg();
		return 0;
	}*/
}

//＜程序＞    ::= ［＜常量说明＞］［＜变量说明＞］{＜有返回值函数定义＞|＜无返回值函数定义＞}＜主函数＞
int GrammarAnalyzer::program() {
	pushReg();
	if (constDeclaration()) {}
	if (variableDeclaration()) {}
	symbolTable.setGlobalIdenfrTable();
	while (returnFunctionDefinition() || nonReturnFunctionDefinition()) {
		funcRetType = VOID;
		hasRetStatement = false;
		symbolTable.clrLocalIdenfrTable();
	}
	if (!mainFunction()) {
		popReg();
		return 0;
	}
	output[out_p++] = "<程序>\n";
	return 1;
	/*pushReg();
	if (constDeclaration()) {}
	if (variableDeclaration()) {}
	while (returnFunctionDefinition() || nonReturnFunctionDefinition()) {}
	if (mainFunction()) {
		output[out_p++] = "<程序>\n";
		return 1;
	} else {
		popReg();
		return 0;
	}*/
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
			value = stoi(lexicalTable[sym_p - 1].token);
			int dup = errorHandler.dupDefId(name, lexicalTable[sym_p].lineNo);
			if (!dup) {
				symbolTable.insertIdenfr(*(new ConstEntry(name, entryType, value)));
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
				value = stoi(lexicalTable[sym_p - 1].token);
				int dup = errorHandler.dupDefId(name, lexicalTable[sym_p].lineNo);
				if (!dup) {
					symbolTable.insertIdenfr(*(new ConstEntry(name, entryType, value)));
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
			value = (int)lexicalTable[sym_p].token[1];
			int dup = errorHandler.dupDefId(name, lexicalTable[sym_p].lineNo);
			if (!dup) {
				symbolTable.insertIdenfr(*(new ConstEntry(name, entryType, value)));
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
				value = (int)lexicalTable[sym_p].token[1];
				int dup = errorHandler.dupDefId(name, lexicalTable[sym_p].lineNo);
				if (!dup) {
					symbolTable.insertIdenfr(*(new ConstEntry(name, entryType, value)));
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
	lexicalOutput();
	output[out_p++] = "<无符号整数>\n";
	return 1;
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
	if (lexicalTable[sym_p].symbol == PLUS || lexicalTable[sym_p].symbol == MINU) {
		lexicalOutput();
	}
	if (!unsignedInteger()) {
		popReg();
		return 0;
	}
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
	/*
	pushReg();
	if (variableDefinition()) {
		//lexicalAnalyzer.nextSymbol(); 这里也不用nextSymbol
		if (lexicalAnalyzer.symbol == SEMICN) {
			sym_p++;
		} else {
			popReg();
			return 0;
		}
		while (variableDefinition()) {
			if (lexicalAnalyzer.symbol == SEMICN) {
				sym_p++;
			} else {
				popReg();
				return 0;
			}
		}
		output[out_p++] =  "<变量说明>\n";
	} else {
		popReg();
		return 0;
	}*/
}

//＜变量定义＞  ::= ＜类型标识符＞＜标识符＞['['＜无符号整数＞']']{, ＜标识符＞['['＜无符号整数＞']'] }  (无符号整数大于0)
int GrammarAnalyzer::variableDefinition() {
	pushReg();
	string name;
	EntryType entryType;
	int dim = 0;
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
	lexicalOutput();
	/*if (lexicalTable[sym_p].symbol == LPARENT) { //特判！区分<变量定义>与<有返回值函数定义>
		popReg();
		return 0;
	}*/
	if (lexicalTable[sym_p].symbol == LBRACK) {
		lexicalOutput();
		if (!unsignedInteger()) {
			popReg();
			return 0;
		}
		dim = 1;
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
		symbolTable.insertIdenfr(*(new VarEntry(name, entryType, dim)));
	}
	dim = 0;
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
			if (!unsignedInteger()) {
				popReg();
				return 0;
			}
			dim = 1;
			if (lexicalTable[sym_p].symbol != RBRACK) {
				errorHandler.rBracket(lexicalTable[sym_p].lineNo);
				//popReg();
				//return 0;
			}
			lexicalOutput();
		}
		int dup = errorHandler.dupDefId(name, lexicalTable[sym_p].lineNo);
		if (!dup) {
			symbolTable.insertIdenfr(*(new VarEntry(name, entryType, dim)));
		}
		dim = 0;
	}
	output[out_p++] = "<变量定义>\n";
	return 1;
	/*pushReg();
	if (lexicalTable[sym_p].symbol == INTTK || lexicalTable[sym_p].symbol == CHARTK) {
		lexicalOutput();
		if (lexicalTable[sym_p].symbol == IDENFR) {
			lexicalOutput();
			if (lexicalTable[sym_p].symbol == LBRACK) {
				lexicalOutput();
				if (unsignedInteger()) {
					if (lexicalTable[sym_p].symbol == RBRACK) {
						lexicalOutput();
					} else {
						popReg();
						return 0;
					}
				} else {
					popReg();
					return 0;
				}
			}
		}
	} else {
		popReg();
		return 0;
	}*/
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
	if (!parameterList()) {
		popReg();
		return 0;
	}
	int dup = errorHandler.dupDefFuncId(name, lexicalTable[sym_p].lineNo);
	if (!dup) {
		symbolTable.insertFunc(*(new FuncEntry(name, retType, true)));
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
	if (!parameterList()) {
		popReg();
		return 0;
	}
	if (!dup) {
		symbolTable.insertFunc(*(new FuncEntry(name, retType,false)));
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
	pushReg();
	EntryType entryType;
	string name;
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
	symbolTable.insertTempParas(*(new VarEntry(name, entryType, 0)), 1); //insertTempParas temp=1
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
		symbolTable.insertTempParas(*(new VarEntry(name, entryType, 0)), 1); //insertTempParas temp=1
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
	if (!compoundStatement()) {
		popReg();
		return 0;
	}
	if (lexicalTable[sym_p].symbol != RBRACE) {
		popReg();
		return 0;
	}
	lexicalOutput();
	output[out_p++] = "<主函数>\n";
	return 1;
}

//＜表达式＞    ::= ［＋｜－］＜项＞{＜加法运算符＞＜项＞}   //[+|-]只作用于第一个<项>
int GrammarAnalyzer::expression() {
	// 1 for int, 2 for char
	pushReg();
	int termCount = 0;
	int termRet;
	if (lexicalTable[sym_p].symbol == PLUS || lexicalTable[sym_p].symbol == MINU) {
		lexicalOutput(); //处理[+|-]
	}
	if ((termRet = term()) == 0) {
		popReg();
		return 0;
	}
	termCount++;
	while (lexicalTable[sym_p].symbol == PLUS || lexicalTable[sym_p].symbol == MINU) {
		lexicalOutput();
		if (!term()) {
			popReg();
			return 0;
		}
		termCount++;
	}
	output[out_p++] = "<表达式>\n";
	if (termCount > 1) return 1;
	else return termRet;
}

//＜项＞     :: = ＜因子＞{ ＜乘法运算符＞＜因子＞ }
int GrammarAnalyzer::term() {
	// 1 for int, 2 for char
	pushReg();
	int factorCount = 0;
	int factorRet;
	if ((factorRet = factor()) == 0) {
		popReg();
		return 0;
	}
	factorCount++;
	while (lexicalTable[sym_p].symbol == MULT || lexicalTable[sym_p].symbol == DIV) {
		lexicalOutput();
		if (!factor()) {
			popReg();
			return 0;
		}
		factorCount++;
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
	int expRet;
	if (lexicalTable[sym_p].symbol == IDENFR) {
		if ((ret = returnFunctionCall()) != 0) { //<有返回值函数调用语句>
			output[out_p++] = "<因子>\n";
			return ret;
		}
		errorHandler.undefId(lexicalTable[sym_p].token, lexicalTable[sym_p].lineNo);
		ret = symbolTable.getIdType(lexicalTable[sym_p].token);
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
		output[out_p++] = "<因子>\n";
		return 1;
	} else if (lexicalTable[sym_p].symbol == CHARCON) {
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
	if (lexicalTable[sym_p].symbol != IDENFR) {
		popReg();
		return 0;
	}
	name = lexicalTable[sym_p].token;
	errorHandler.undefId(name, lexicalTable[sym_p].lineNo);
	errorHandler.constChange(name, lexicalTable[sym_p].lineNo);
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
	output[out_p++] = "<赋值语句>\n";
	return 1;
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
		lexicalOutput();
		if (!statement()) {
			popReg();
			return 0;
		}
	}
	output[out_p++] = "<条件语句>\n";
	return 1;
}

//＜条件＞    ::=  ＜表达式＞[＜关系运算符＞＜表达式＞]
int GrammarAnalyzer::condition() {
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
		lexicalOutput();
		if ((expRet = expression()) == 0) {
			popReg();
			return 0;
		}
		if (expRet != 1) {
			errorHandler.illegalTypeInCondition(lexicalTable[sym_p].lineNo);
		}
	}
	output[out_p++] = "<条件>\n";
	return 1;
}

//＜循环语句＞   ::=  while '('＜条件＞')'＜语句＞| do＜语句＞while '('＜条件＞')' |
//for'('＜标识符＞＝＜表达式＞;＜条件＞;＜标识符＞＝＜标识符＞(+|-)＜步长＞')'＜语句＞
int GrammarAnalyzer::loopStatement() {
	pushReg();
	if (lexicalTable[sym_p].symbol == WHILETK) {
	//while '('＜条件＞')'＜语句＞
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
		output[out_p++] = "<循环语句>\n";
		return 1;
	} else if (lexicalTable[sym_p].symbol == DOTK) {
	//do＜语句＞while '('＜条件＞')' 
		lexicalOutput();
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
		if (lexicalTable[sym_p].symbol != IDENFR) {
			popReg();
			return 0;
		}
		errorHandler.undefId(lexicalTable[sym_p].token, lexicalTable[sym_p].lineNo);
		errorHandler.constChange(lexicalTable[sym_p].token, lexicalTable[sym_p].lineNo); //改变常量
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
		if (lexicalTable[sym_p].symbol != SEMICN) {
			errorHandler.semicolon(lexicalTable[sym_p].lineNo); //sym_p 不-1
			//popReg();
			//return 0;
		} else {
			lexicalOutput();
		}
		if (!condition()) {
			popReg();
			return 0;
		}
		if (lexicalTable[sym_p].symbol != SEMICN) {
			errorHandler.semicolon(lexicalTable[sym_p].lineNo); //sym_p 不-1
			//popReg();
			//return 0;
		} else {
			lexicalOutput();
		}
		if (lexicalTable[sym_p].symbol != IDENFR) {
			popReg();
			return 0;
		}
		errorHandler.undefId(lexicalTable[sym_p].token, lexicalTable[sym_p].lineNo);
		errorHandler.constChange(lexicalTable[sym_p].token, lexicalTable[sym_p].lineNo); //改变常量
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
		lexicalOutput();
		if (lexicalTable[sym_p].symbol != PLUS && lexicalTable[sym_p].symbol != MINU) {
			popReg();
			return 0;
		}
		lexicalOutput();
		if (!step()) {
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
		if (!statement()) {
			popReg();
			return 0;
		}
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
	if (!unsignedInteger()) {
		popReg();
		return 0;
	}
	output[out_p++] = "<步长>\n";
	return 1;
}

//＜有返回值函数调用语句＞ :: = ＜标识符＞'('＜值参数表＞')'
int GrammarAnalyzer::returnFunctionCall() {
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
	if (!symbolTable.hasFunc(name) || !symbolTable.isRetFunc(name)) {
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
	output[out_p++] = "<有返回值函数调用语句>\n";
	return 1;
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
	if (!symbolTable.hasFunc(name) || symbolTable.isRetFunc(name)) {
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
	output[out_p++] = "<无返回值函数调用语句>\n";
	return 1;
}

//＜值参数表＞   :: = ＜表达式＞{ ,＜表达式＞ }｜＜空＞
int GrammarAnalyzer::valueParameterList() {
	pushReg();
	EntryType entryType;
	string name = "hhhhhh";
	int expRet;
	// 可以为空的写法
	if ((expRet = expression()) == 0) {
		output[out_p++] = "<值参数表>\n";
		return 1;
	}
	entryType = (expRet == 1) ? INT : CHAR;
	symbolTable.insertTempParas(*(new VarEntry(name, entryType, 0)), 0); //insertTempParas type=0
	while (lexicalTable[sym_p].symbol == COMMA) {
		lexicalOutput();
		if ((expRet = expression()) == 0) {
			popReg();
			return 0;
		}
		entryType = (expRet == 1) ? INT : CHAR;
		symbolTable.insertTempParas(*(new VarEntry(name, entryType, 0)), 0); //insertTempParas type=0
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
	errorHandler.undefId(lexicalTable[sym_p].token, lexicalTable[sym_p].lineNo);
	errorHandler.constChange(lexicalTable[sym_p].token, lexicalTable[sym_p].lineNo); //改变常量
	lexicalOutput();
	while (lexicalTable[sym_p].symbol == COMMA) {
		lexicalOutput();
		if (lexicalTable[sym_p].symbol != IDENFR) {
			popReg();
			return 0;
		}
		errorHandler.undefId(lexicalTable[sym_p].token, lexicalTable[sym_p].lineNo);
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
		if (lexicalTable[sym_p].symbol == COMMA) {
			lexicalOutput();
			if (!expression()) {
				popReg();
				return 0;
			}
		}
	} else if (expression()) {
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
		if (funcRetType == VOID) { //无返回值函数：出现return
			errorHandler.nonretfuncReturnUnmatch(lexicalTable[sym_p].lineNo);
		}
		if ((expRet = expression()) == 0) {
			popReg();
			return 0;
		}
		EntryType realRetType = (expRet == 1) ? INT : CHAR;
		if (funcRetType != VOID && funcRetType != realRetType) { //有返回值函数：return(int)不匹配char
			errorHandler.retfuncReturnUnmatch(lexicalTable[sym_p].lineNo);
		}
		if (lexicalTable[sym_p].symbol != RPARENT) {
			errorHandler.rParent(lexicalTable[sym_p-1].lineNo); //sym_p - 1
			//popReg();
			//return 0;
		} else {
			lexicalOutput();
		}
	}
	hasRetStatement = true;
	output[out_p++] = "<返回语句>\n";
	return 1;
}