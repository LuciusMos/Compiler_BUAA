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
bool errMsgCmp(errMsg t1, errMsg t2) {
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
	errMsgs[errCount].errLine = lineNo;
	errMsgs[errCount].errOut = string().append(to_string(lineNo)).append(" ").append(string(1, errNo)).append("\n");
	// int->string: to_string(int)
	// char_string: string(1, char)
	errCount++;
}
int ErrorHandler::output() {
	// 0 for no error, 1~inf for have errors
	if (errCount != 0) {
		sort(errMsgs, errMsgs + errCount, errMsgCmp);
		for (int i = 0; i < errCount; i++) {
			errorFile << errMsgs[i].errOut;
		}
	}
	return errCount;
}

void ErrorHandler::lexical(int lineNo) {
	errOutput('a', lineNo);
	errorFlag = true;
}
int ErrorHandler::dupDefId(string token, int lineNo) {
	int dup;
	if ((dup = symbolTable.checkDupDefId(token)) == 1) {
		errOutput('b', lineNo);
		errorFlag = true;
	}
	return dup; //0 for no dup, 1 for dup
}
int ErrorHandler::dupDefFuncId(string token, int lineNo) {
	int dup;
	if ((dup = symbolTable.checkDupDefFuncId(token)) == 1) {
		errOutput('b', lineNo);
		errorFlag = true;
	}
	return dup; //0 for no dup, 1 for dup
}
int ErrorHandler::undefId(string token, int lineNo) {
	int undef;
	if ((undef = symbolTable.checkUndefId(token)) == 1) {
		errOutput('c', lineNo);
		errorFlag = true;
	}
	return undef;
}
int ErrorHandler::undefFuncId(string token, int lineNo) {
	int undef;
	if ((undef = symbolTable.checkUndefFuncId(token)) == 1) {
		errOutput('c', lineNo);
		errorFlag = true;
	}
	return undef; //0 for no undef, 1 for undef
}
void ErrorHandler::paraUnmatch(string token, int lineNo, vector<VarEntry*>* valueParas) {
	int paraRet = symbolTable.checkParaUnmatch(token, valueParas);
	if (paraRet == 1) {
		errOutput('d', lineNo); //个数不匹配
		errorFlag = true;
	}
	else if (paraRet == 2) {
		errOutput('e', lineNo); //类型不匹配
		errorFlag = true;
	}
}
void ErrorHandler::illegalTypeInCondition(int lineNo) {
	errOutput('f', lineNo);
	errorFlag = true;
}
void ErrorHandler::nonretfuncReturnUnmatch(int lineNo) {
	errOutput('g', lineNo);
	errorFlag = true;
}
void ErrorHandler::retfuncReturnUnmatch(int lineNo) {
	errOutput('h', lineNo);
	errorFlag = true;
}
void ErrorHandler::arrayIndexInt(int lineNo) {
	errOutput('i', lineNo);
	errorFlag = true;
}
int ErrorHandler::constChange(string token, int lineNo) {
	int conchange;
	if ((conchange = symbolTable.checkConstChange(token)) == 1) {
		errOutput('j', lineNo);
		errorFlag = true;
	}
	return conchange;
}
void ErrorHandler::semicolon(int lineNo) {
	errOutput('k', lineNo);
	errorFlag = true;
}
void ErrorHandler::rParent(int lineNo) {
	errOutput('l', lineNo);
	errorFlag = true;
}
void ErrorHandler::rBracket(int lineNo) {
	errOutput('m', lineNo);
	errorFlag = true;
}
void ErrorHandler::lackWhileInDowhile(int lineNo) {
	errOutput('n', lineNo);
	errorFlag = true;
}
void ErrorHandler::intOrCharCon(int lineNo) {
	errOutput('o', lineNo);
	errorFlag = true;
}

