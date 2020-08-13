#pragma once
#include <iostream>
#include <map>
#include <string>
#include "type.h"
#include "ErrorHandler.h"

#define Grammar_STAGE
// #define ERROR_STAGE
// #define MIPS_STAGE1

using namespace std;

extern int globalLineNo;

struct LexicalTable {
	symbolType symbol;
	//int num;
	string token;
	int lineNo;
};
extern LexicalTable lexicalTable[50000]; //词法分析结果
extern int sym_cnt;

class LexicalAnalyzer
{
public:
	friend class GrammarAnalyzer;
	friend class ErrorHandler;
	static LexicalAnalyzer &initLexicalAnalyzer(ifstream& fin, ofstream& fout, ErrorHandler& aErrorHandler);
	void lexicalAnalyze();
	map<string, symbolType> reservedWords = {
		{"const", CONSTTK}, {"int", INTTK}, {"char", CHARTK},
		{"void", VOIDTK}, {"main", MAINTK},
		{"if", IFTK}, {"else", ELSETK},
		{"do", DOTK}, {"while", WHILETK}, {"for", FORTK},
		{"scanf", SCANFTK}, {"printf", PRINTFTK}, {"return", RETURNTK},
		{"+", PLUS}, {"-", MINU},
		{"*", MULT}, {"/", DIV},
		{"<", LSS}, {"<=", LEQ},
		{">", GRE}, {">=", GEQ},
		{"==", EQL}, {"!=", NEQ},
		{"=", ASSIGN},
		{";", SEMICN}, {",", COMMA},
		{"(", LPARENT}, {")", RPARENT},
		{"[", LBRACK}, {"]", RBRACK},
		{"{", LBRACE}, {"}", RBRACE}
	};
	map<symbolType, string> reservedWordsOutput = {
		{IDENFR, "IDENFR"},
		{INTCON, "INTCON"}, {CHARCON, "CHARCON"}, {STRCON, "STRCON"},
		{CONSTTK, "CONSTTK"}, {INTTK, "INTTK"}, {CHARTK, "CHARTK"},
		{VOIDTK, "VOIDTK"}, {MAINTK, "MAINTK"},
		{IFTK, "IFTK"}, {ELSETK, "ELSETK"},
		{DOTK, "DOTK"}, {WHILETK, "WHILETK"}, {FORTK, "FORTK"},
		{SCANFTK, "SCANFTK"}, {PRINTFTK, "PRINTFTK"}, {RETURNTK, "RETURNTK"},
		{PLUS, "PLUS"}, {MINU, "MINU"},
		{MULT, "MULT"}, {DIV, "DIV"},
		{LSS, "LSS"}, {LEQ, "LEQ"},
		{GRE, "GRE"}, {GEQ, "GEQ"},
		{EQL, "EQL"}, {NEQ, "NEQ"}, {ASSIGN, "ASSIGN"},
		{SEMICN, "SEMICN"}, {COMMA, "COMMA"},
		{LPARENT, "LPARENT"}, {RPARENT, "RPARENT"},
		{LBRACK, "LBRACK"}, {RBRACK, "RBRACK"},
		{LBRACE, "LBRACE"}, {RBRACE, "RBRACE"},
	};

private:
	ifstream &inputFile;
	ofstream& outputFile;
	ErrorHandler& errorHandler;
	symbolType symbol;
	string token;
	//int num;
	LexicalAnalyzer(ifstream& fin, ofstream& fout, ErrorHandler& aErrorHandler);
	bool nextSymbol(); //TRUE for continue, FALSE for EOF
};

