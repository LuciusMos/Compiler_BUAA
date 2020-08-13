#pragma once
#include <iostream>
#include <map>
#include <string>
using namespace std;

enum symbolType {
	IDENFR,
	INTCON,
	CHARCON,
	STRCON,
	CONSTTK,
	INTTK,
	CHARTK,
	VOIDTK,
	MAINTK,
	IFTK,
	ELSETK,
	DOTK,
	WHILETK,
	FORTK,
	SCANFTK,
	PRINTFTK,
	RETURNTK,
	PLUS,
	MINU,
	MULT,
	DIV,
	LSS,
	LEQ,
	GRE,
	GEQ,
	EQL,
	NEQ,
	ASSIGN,
	SEMICN,
	COMMA,
	LPARENT,
	RPARENT,
	LBRACK,
	RBRACK,
	LBRACE,
	RBRACE
};

class LexicalAnalyzer
{
public:
	static LexicalAnalyzer &initLexicalAnalyzer(ifstream& fin, ofstream& fout);
	bool nextSymbol(); //TRUE for continue, FALSE for EOF

private:
	ifstream &inputFile;
	ofstream& outputFile;
	symbolType symbol;
	string token;
	int num;
	LexicalAnalyzer(ifstream& fin, ofstream& fout);
	map<string, symbolType> reservedWords = {
		{"const", CONSTTK},
		{"int", INTTK},
		{"char", CHARTK},
		{"void", VOIDTK},
		{"main", MAINTK},
		{"if", IFTK},
		{"else", ELSETK},
		{"do", DOTK},
		{"while", WHILETK},
		{"for", FORTK},
		{"scanf", SCANFTK},
		{"printf", PRINTFTK},
		{"return", RETURNTK},
		{"+", PLUS},
		{"-", MINU},
		{"*", MULT},
		{"/", DIV},
		{"<", LSS},
		{"<=", LEQ},
		{">", GRE},
		{">=", GEQ},
		{"==", EQL},
		{"!=", NEQ},
		{"=", ASSIGN},
		{";", SEMICN},
		{",", COMMA},
		{"(", LPARENT},
		{")", RPARENT},
		{"[", LBRACK},
		{"]", RBRACK},
		{"{", LBRACE},
		{"}", RBRACE}
	};
	map<symbolType, string> reservedWordsOutput = {
		{IDENFR, "IDENFR"},
		{INTCON, "INTCON"},
		{CHARCON, "CHARCON"},
		{STRCON, "STRCON"},
		{CONSTTK, "CONSTTK"},
		{INTTK, "INTTK"},
		{CHARTK, "CHARTK"},
		{VOIDTK, "VOIDTK"},
		{MAINTK, "MAINTK"},
		{IFTK, "IFTK"},
		{ELSETK, "ELSETK"},
		{DOTK, "DOTK"},
		{WHILETK, "WHILETK"},
		{FORTK, "FORTK"},
		{SCANFTK, "SCANFTK"},
		{PRINTFTK, "PRINTFTK"},
		{RETURNTK, "RETURNTK"},
		{PLUS, "PLUS"},
		{MINU, "MINU"},
		{MULT, "MULT"},
		{DIV, "DIV"},
		{LSS, "LSS"},
		{LEQ, "LEQ"},
		{GRE, "GRE"},
		{GEQ, "GEQ"},
		{EQL, "EQL"},
		{NEQ, "NEQ"},
		{ASSIGN, "ASSIGN"},
		{SEMICN, "SEMICN"},
		{COMMA, "COMMA"},
		{LPARENT, "LPARENT"},
		{RPARENT, "RPARENT"},
		{LBRACK, "LBRACK"},
		{RBRACK, "RBRACK"},
		{LBRACE, "LBRACE"},
		{RBRACE, "RBRACE"},
	};
};

