#include <iostream>
#include <string>
#include <fstream>
#include <algorithm>
#include "ErrorHandler.h"
#include "LexicalAnalyzer.h"
using namespace std;

struct errMsg {
	int errLine;
	string errOut;
}errMsgs[10000];
bool cmp(errMsg t1, errMsg t2) {
	return (t1.errLine < t2.errLine);
}
int errCount = 0;

ErrorHandler::ErrorHandler(/*LexicalAnalyzer& aLexicalAnalyzer,*/SymbolTable& aSymbolTable, ofstream& ferr) :
	/*lexicalAnalyzer(aLexicalAnalyzer),*/symbolTable(aSymbolTable), errorFile(ferr) {}
ErrorHandler& ErrorHandler::initErrorHandler(/*LexicalAnalyzer& aLexicalAnalyzer,*/SymbolTable& aSymbolTable, ofstream& ferr) {
	static ErrorHandler singleton(/*aLexicalAnalyzer,*/aSymbolTable, ferr);
	return singleton;
}

void ErrorHandler::errOutput(char errNo, int lineNo) {
	/*if (errNo == 'k') {
		lineNo--; //应为分号';'时，行号-1
	}*/
	errMsgs[errCount].errLine = lineNo;
	errMsgs[errCount].errOut = string().append(to_string(lineNo)).append(" ").append(string(1, errNo)).append("\n");
	// errMsgs[errCount].errOut = string("a");
	// int->string: to_string(int)
	// char_string: string(1, char)
	errCount++;
	//errorFile << lineNo << " " << errNo << endl;
}
void ErrorHandler::output() {
	sort(errMsgs, errMsgs + errCount, cmp);
	for (int i = 0; i < errCount; i++) {
		errorFile << errMsgs[i].errOut;
	}
}

void ErrorHandler::lexical(int lineNo) {
	errOutput('a', lineNo);
}
int ErrorHandler::dupDefId(string token, int lineNo) {
	int dup;
	if ((dup = symbolTable.checkDupDefId(token)) == 1) {
		errOutput('b', lineNo);
	}
	return dup; //0 for no dup, 1 for dup
}
int ErrorHandler::dupDefFuncId(string token, int lineNo) {
	int dup;
	if ((dup = symbolTable.checkDupDefFuncId(token)) == 1) {
		errOutput('b', lineNo);
	}
	return dup; //0 for no dup, 1 for dup
}
void ErrorHandler::undefId(string token, int lineNo) {
	int undef;
	if ((undef = symbolTable.checkUndefId(token)) == 1) {
		errOutput('c', lineNo);
	}
}
int ErrorHandler::undefFuncId(string token, int lineNo) {
	int undef;
	if ((undef = symbolTable.checkUndefFuncId(token)) == 1) {
		errOutput('c', lineNo);
	}
	return undef; //0 for no undef, 1 for undef
}
void ErrorHandler::paraNoUnmatch(int lineNo) {
	errOutput('d', lineNo);
}
void ErrorHandler::paraTypeUnmatch(int lineNo) {
	errOutput('e', lineNo);
}
void ErrorHandler::paraUnmatch(string token, int lineNo) {
	int paraRet = symbolTable.checkParaUnmatch(token);
	if (paraRet == 1) errOutput('d', lineNo); //个数不匹配
	else if (paraRet == 2) errOutput('e', lineNo); //类型不匹配
}
void ErrorHandler::illegalTypeInCondition(int lineNo) {
	errOutput('f', lineNo);
}
void ErrorHandler::nonretfuncReturnUnmatch(int lineNo) {
	errOutput('g', lineNo);
}
void ErrorHandler::retfuncReturnUnmatch(int lineNo) {
	errOutput('h', lineNo);
}
void ErrorHandler::arrayIndexInt(int lineNo) {
	errOutput('i', lineNo);
}
void ErrorHandler::constChange(string token, int lineNo) {
	int conchange;
	if ((conchange = symbolTable.checkConstChange(token)) == 1) {
		errOutput('j', lineNo);
	}
}
void ErrorHandler::semicolon(int lineNo) {
	errOutput('k', lineNo);
}
void ErrorHandler::rParent(int lineNo) {
	errOutput('l', lineNo);
}
void ErrorHandler::rBracket(int lineNo) {
	errOutput('m', lineNo);
}
void ErrorHandler::lackWhileInDowhile(int lineNo) {
	errOutput('n', lineNo);
}
void ErrorHandler::intOrCharCon(int lineNo) {
	errOutput('o', lineNo);
}

