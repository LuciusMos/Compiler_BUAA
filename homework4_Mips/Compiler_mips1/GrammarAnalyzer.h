#pragma once
#include <fstream>
#include "LexicalAnalyzer.h"
#include "SymbolTable.h"
#include "ErrorHandler.h"
#include "IMCode.h"

class GrammarAnalyzer
{
public:
	static GrammarAnalyzer& initGrammarAnalyzer(LexicalAnalyzer& aLexicalAnalyzer, ofstream& fout, SymbolTable& aSymbolTable, ErrorHandler& aErrorHandler, IMCode& aIMCode);
	void grammarAnalyze();
private:
	GrammarAnalyzer(LexicalAnalyzer& aLexicalAnalyzer, ofstream& fout, SymbolTable& aSymbolTable, ErrorHandler& aErrorHandler, IMCode& aIMCode);
	LexicalAnalyzer& lexicalAnalyzer;
	ofstream& outputFile;
	SymbolTable& symbolTable;
	ErrorHandler& errorHandler;
	IMCode& imCode;
	void lexicalOutput();
	void pushReg();
	void popReg();
	void genExpIMCode(IMOpType imOpType);
	void genAssignIMCode(IMOpType imOpType);
	int stringGrammar();
	int program();
	int constDeclaration(); //＜常量说明＞ ::=  const＜常量定义＞;{ const＜常量定义＞;}
	int constDefinition(); //＜常量定义＞   ::=   int＜标识符＞＝＜整数＞{,＜标识符＞＝＜整数＞}| char＜标识符＞＝＜字符＞{ ,＜标识符＞＝＜字符＞ }
	int unsignedInteger();
	int integer();
	int returnFunctionDefinitionHead(); //(用于有返回值函数)＜声明头部＞   ::=  int＜标识符＞ |char＜标识符＞
	int variableDeclaration(); //＜变量说明＞  ::= ＜变量定义＞;{＜变量定义＞;}
	int variableDefinition(); //＜变量定义＞  ::= ＜类型标识符＞＜标识符＞['['＜无符号整数＞']']{, ＜标识符＞['['＜无符号整数＞']'] } (无符号整数大于0)
	int returnFunctionDefinition();
	int nonReturnFunctionDefinition();
	int compoundStatement();
	int parameterList(); //(用于函数定义语句)＜值参数表＞   ::= ＜表达式＞{,＜表达式＞}｜＜空＞
	int mainFunction();
	int expression();
	int term();
	int factor();
	int statement();
	int assignStatement();
	int conditionStatement();
	int condition();
	int loopStatement();
	int step();
	IMItem* returnFunctionCall();
	int nonReturnFunctionCall();
	int valueParameterList(); //值参数表，用于函数调用语句
	int statementsBlock(); //＜语句列＞   ::= ｛＜语句＞｝
	int readStatement();
	int writeStatement();
	int returnStatement();
};

