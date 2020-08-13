#pragma once
//#include "LexicalAnalyzer.h"
#include "SymbolTable.h"
using namespace std;

class ErrorHandler
{
public:
	static ErrorHandler& initErrorHandler(/*LexicalAnalyzer& aLexicalAnalyzer,*/ SymbolTable& aSymbolTable, ofstream& ferr);
	// 0 for good, 1 for error
	void lexical(int lineNo); //非法符号或不符合词法 a
	int dupDefId(string token, int lineNo); //名字重定义（变量） b：常量定义4，变量定义2
	int dupDefFuncId(string token, int lineNo); //名字重定义（函数） b：声明头部（有返回），无返回值函数定义
	int undefId(string token, int lineNo); //未定义的名字（变量） c：因子，赋值语句，循环语句for，读语句
	int undefFuncId(string token, int lineNo); //未定义的名字（函数） c：函数调用2
	void paraUnmatch(string token, int lineNo, vector<VarEntry*>* valueParas); //函数参数个数不匹配 d：   函数参数类型不匹配 e：
	void illegalTypeInCondition(int lineNo); //条件判断中出现不合法的类型 f：条件
	void nonretfuncReturnUnmatch(int lineNo); //无返回值的函数存在不匹配的return语句 g：无返回值函数定义，返回语句
	void retfuncReturnUnmatch(int lineNo); //有返回值的函数缺少return语句或存在不匹配的return语句 h：有返回值函数定义，返回语句
	void arrayIndexInt(int lineNo); //数组元素的下标只能是整型表达式 i：因子，赋值语句
	int constChange(string token, int lineNo); //不能改变常量的值 j：赋值语句，for，scanf
	void semicolon(int lineNo); //应为分号 k：常量说明，变量说明，语句，循环语句for
	void rParent(int lineNo); //应为右小括号’)’ l：函数定义2，主函数，因子，条件语句，循环语句3，函数调用语句2，读语句，写语句，返回语句
	void rBracket(int lineNo); //应为右中括号’]’ m：变量定义，因子，赋值语句
	void lackWhileInDowhile(int lineNo); //do-while应为语句中缺少while n
	void intOrCharCon(int lineNo); //常量定义中=后面只能是整型或字符型常量 o
	int output();
private:
	//LexicalAnalyzer& lexicalAnalyzer;
	SymbolTable& symbolTable;
	ofstream& errorFile;
	ErrorHandler(/*LexicalAnalyzer& aLexicalAnalyzer,*/ SymbolTable& aSymbolTable, ofstream& ferr);
	void errOutput(char errNo, int lineNo);
	//void jumpToLineEnd();
};

