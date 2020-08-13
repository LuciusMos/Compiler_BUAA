#include <iostream>
#include <map>
#include <string>
#include <fstream>
#include "LexicalAnalyzer.h"
using namespace std;

static char ch;

bool isletter(char aChar) {
	return (isalpha(aChar) || (aChar == '_'));
}

LexicalAnalyzer& LexicalAnalyzer::initLexicalAnalyzer(ifstream& fin, ofstream& fout) {
	static LexicalAnalyzer singleton(fin, fout);
	return singleton;
}

LexicalAnalyzer::LexicalAnalyzer(ifstream& fin, ofstream& fout) : inputFile(fin), outputFile(fout) {
	ch = inputFile.get();
}

bool LexicalAnalyzer::nextSymbol() {
	token.clear();
	while (isspace(ch)) {
		ch = inputFile.get();
	}
	if (ch == EOF) return false;
	if (isdigit(ch)) {
		symbol = INTCON;
		num = 0;
		while (isdigit(ch)) {
			num = num * 10 + ch - '0';
			ch = inputFile.get();
		}
		outputFile << reservedWordsOutput.find(symbol)->second << " " << num << endl;
	} else if (isletter(ch)) {
		while (isletter(ch) || isdigit(ch)) {
			token.append(1, ch);
			ch = inputFile.get();
		}
		map<string, symbolType>::iterator it = reservedWords.find(token);
		if (it == reservedWords.end()) symbol = IDENFR;
		else symbol = it->second;
		outputFile << reservedWordsOutput.find(symbol)->second << " " << token << endl;
	} else if (ch == '\'') {
		symbol = CHARCON;
		ch = inputFile.get();
		token.append(1, ch);
		ch = inputFile.get();
		if (ch != '\'') cerr << "NOT A CHAR LIKE 'A'";
		ch = inputFile.get();
		outputFile << reservedWordsOutput.find(symbol)->second << " " << token << endl;
	} else if (ch == '"') {
		symbol = STRCON;
		while (1) {
			ch = inputFile.get();
			if (ch == '"') break;
			token.append(1, ch);
		}
		ch = inputFile.get();
		outputFile << reservedWordsOutput.find(symbol)->second << " " << token << endl;
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
			cerr << "CANNOT RECOGNIZE THIS TOKEN";
			break;
		}
		ch = inputFile.get();
		outputFile << reservedWordsOutput.find(symbol)->second << " " << token << endl;
	}
	return true;
}
