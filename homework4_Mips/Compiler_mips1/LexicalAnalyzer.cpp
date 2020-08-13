#include <iostream>
#include <map>
#include <string>
#include <fstream>
#include "LexicalAnalyzer.h"
using namespace std;

LexicalTable lexicalTable[50000];
static char ch;
int sym_cnt = 0;

int globalLineNo = 1;

bool isletter(char aChar) {
	return (isalpha(aChar) || (aChar == '_'));
}

LexicalAnalyzer& LexicalAnalyzer::initLexicalAnalyzer(ifstream& fin, ofstream& fout, ErrorHandler& aErrorHandler) {
	static LexicalAnalyzer singleton(fin, fout, aErrorHandler);
	return singleton;
}

LexicalAnalyzer::LexicalAnalyzer(ifstream& fin, ofstream& fout, ErrorHandler& aErrorHandler) : 
	inputFile(fin), outputFile(fout), errorHandler(aErrorHandler) {
	ch = inputFile.get();
	token = string();
}

void LexicalAnalyzer::lexicalAnalyze() {
	bool nextsym;
	while ((nextsym = nextSymbol())) ;
}

bool LexicalAnalyzer::nextSymbol() {
	token.clear();
	while (isspace(ch)) {
		if (ch == '\n') globalLineNo++;
		ch = inputFile.get();
	}
	//先读空格，再判断是否是EOF
	//否则末尾的空格会无法识别
	if (ch == EOF) {
		return false;
	}
	if (isdigit(ch)) {
		symbol = INTCON;
		if (ch == '0') {
			token.append(1, '0');
			ch = inputFile.get();
			/*if (isdigit(ch))
				cerr << "A NUMBER STARTS WITH '0' BUT NOT 0";*/
		} else {
			while (isdigit(ch)) {
				token.append(1, ch);
				ch = inputFile.get();
			}
		}
		/*num = 0;
		while (isdigit(ch)) {
			num = num * 10 + ch - '0';
			ch = inputFile.get();
		}*/
		//outputFile << reservedWordsOutput.find(symbol)->second << " " << token << endl;
	} else if (isletter(ch)) {
		while (isletter(ch) || isdigit(ch)) {
			token.append(1, ch);
			ch = inputFile.get();
		}
		map<string, symbolType>::iterator it = reservedWords.find(token);
		if (it == reservedWords.end()) symbol = IDENFR; //不是保留字，是标识符
		else symbol = it->second; //是保留字
		//outputFile << reservedWordsOutput.find(symbol)->second << " " << token << endl;
	} else if (ch == '\'') {
		symbol = CHARCON;
		ch = inputFile.get();
		if (ch != '+' && ch != '-' && ch != '*' && ch != '/'
			&& !isletter(ch) && !isdigit(ch))
			//cerr << "A CHAR BUT NOT +-*/ OR LETTER OR DIGIT";
			errorHandler.lexical(globalLineNo);
		token.append(1, ch);
		ch = inputFile.get();
		if (ch != '\'') 
			cerr << "A CHAR BUT WITHOUT RIGHT QUOTATION MARK: '";
		ch = inputFile.get();
		//outputFile << reservedWordsOutput.find(symbol)->second << " " << token << endl;
	} else if (ch == '"') {
		symbol = STRCON;
		while (1) {
			ch = inputFile.get();
			if (ch == '"') break; // " = 34
			if (ch != 32 && ch != 33 && !(35 <= ch && ch <= 126))
				//cerr << "A STRING BUT HAS ILLEGAL CHAR";
				errorHandler.lexical(globalLineNo);
			token.append(1, ch);
			if (ch == '\\') {
				token.append(1, ch);
			}
		}
		ch = inputFile.get();
		//outputFile << reservedWordsOutput.find(symbol)->second << " " << token << endl;
	} else {
		token.append(1, ch);
		switch (ch) {
		case '+': case '-': case '*': case '/': case ';': case ',':
		case '(': case ')': case '[': case ']': case '{': case '}':
			symbol = reservedWords.find(token)->second;
			break;
		case '<': case '>': case '=': case '!':
			ch = inputFile.peek();
			if (ch == '=') {
				ch = inputFile.get();
				token.append(1, ch);
				symbol = reservedWords.find(token)->second;
			} else {
				if (token.compare("!") == 0) {
					cerr << "NOT \"!=\" BUT HAS '!'";
					break;
				}
				symbol = reservedWords.find(token)->second;
			}
			break;
		default:
			//cerr << "CANNOT RECOGNIZE THIS TOKEN";
			errorHandler.lexical(globalLineNo);
			break;
		}
		ch = inputFile.get();
		//outputFile << reservedWordsOutput.find(symbol)->second << " " << token << endl;
	}
	lexicalTable[sym_cnt].symbol = symbol;
	lexicalTable[sym_cnt].token = token;
	lexicalTable[sym_cnt].lineNo = globalLineNo;
	sym_cnt++;
	return true;
}
