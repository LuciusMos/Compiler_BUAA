#include <iostream>
#include <fstream>
#include <string>
//#include "type.h"
//#include "LexicalAnalyzer.h"
#include "GrammarAnalyzer.h"
//#include "ErrorHandler.h"
//#include "SymbolTable.h"
#include "IMCode.h"
#include "ObjectCode.h"
#define OPTIMIZATION
using namespace std;

extern string output[50000]; //输出
extern int out_cnt;

set<IMItem> regParas;

int main()
{
	string inputFile = "testfile.txt";
	string outputFile = "output.txt";
	string errorFile = "error.txt";
	string mipsFile = "mips.txt";
	string oldIMFile = "old_im.txt";
	string newIMFile = "new_im.txt";
	ifstream fin(inputFile);
	if (!fin.is_open()) {
		cerr << "ERROR: cannot open file: " << inputFile << endl;
		return 0;
	}
	ofstream fout(outputFile);
	ofstream ferr(errorFile);
	ofstream fmips(mipsFile);
	ofstream fold(oldIMFile);
	ofstream fnew(newIMFile);
	// 符号表
	SymbolTable& symbolTable = SymbolTable::initSymbolTable();
	// 错误处理
	ErrorHandler& errorHandler = ErrorHandler::initErrorHandler(symbolTable, ferr);
	// 词法分析
	LexicalAnalyzer& lexicalAnalyzer = LexicalAnalyzer::initLexicalAnalyzer(fin, fout, errorHandler);
	lexicalAnalyzer.lexicalAnalyze();
	// 中间代码
	IMCode& imCode = IMCode::initIMCode(fold, fnew, symbolTable);
	// 语法分析
	GrammarAnalyzer& grammarAnalyzer = GrammarAnalyzer::initGrammarAnalyzer(lexicalAnalyzer, fout, symbolTable, errorHandler, imCode);
	int hasError = grammarAnalyzer.grammarAnalyze();

	
	regParas = symbolTable.getRegParas();

	imCode.outputOld();
	// 优化
#ifdef OPTIMIZATION
	imCode.optimize();
#endif // OPTIMIZATION
	imCode.outputNew();
	

	symbolTable.insertSVar2RegIntoFuncTable();

	// 生成代码
	if (hasError == 0) {
		ObjectCode& objectCode = ObjectCode::initObjectCode(fmips, imCode, symbolTable);
		objectCode.sReg_paraInFuncCall();
		objectCode.genMips();
	} else {
		cout << "------------Has Error-----------" << endl;
	}
	
	fin.close();
	fout.close();
	ferr.close();
	fmips.close();
	fold.close();
	fnew.close();
	return 0;
}

