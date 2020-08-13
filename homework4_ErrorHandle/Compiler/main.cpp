#include <iostream>
#include <fstream>
#include <string>
//#include "type.h"
//#include "LexicalAnalyzer.h"
#include "GrammarAnalyzer.h"
//#include "ErrorHandler.h"
//#include "SymbolTable.h"

using namespace std;

extern string output[50000]; //输出
extern int out_cnt;

int main()
{
	string inputFile = "testfile.txt";
	string outputFile = "output.txt";
	string errorFile = "error.txt";
	string mipsFile = "mips.txt";
	ifstream fin(inputFile);
	if (!fin.is_open()) {
		cerr << "ERROR: cannot open file: " << inputFile << endl;
		return 0;
	}
	ofstream fout(outputFile);
	ofstream ferr(errorFile);
	ofstream fmips(mipsFile);
	// 符号表
	SymbolTable& symbolTable = SymbolTable::initSymbolTable();
	// 错误处理
	ErrorHandler& errorHandler = ErrorHandler::initErrorHandler(symbolTable, ferr);
	// 词法分析
	LexicalAnalyzer& lexicalAnalyzer = LexicalAnalyzer::initLexicalAnalyzer(fin, fout, errorHandler);
	lexicalAnalyzer.lexicalAnalyze();
	// 语法分析
	GrammarAnalyzer& grammarAnalyzer = GrammarAnalyzer::initGrammarAnalyzer(lexicalAnalyzer, fout, symbolTable, errorHandler);
	grammarAnalyzer.grammarAnalyze();

	fin.close();
	fout.close();
	ferr.close();
	return 0;
}

