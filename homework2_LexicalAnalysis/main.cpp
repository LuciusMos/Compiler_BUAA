#include <iostream>
#include <fstream>
#include <string>
#include "LexicalAnalyzer.h"
using namespace std;

int main()
{
	string inputFile = "testfile.txt";
	string outputFile = "output.txt";
	ifstream fin(inputFile);
	if (!fin.is_open()) {
		cerr << "ERROR: cannot open file: " << inputFile << endl;
		return 0;
	}
	ofstream fout(outputFile);
	LexicalAnalyzer& lexicalAnalyzer = LexicalAnalyzer::initLexicalAnalyzer(fin, fout);
	bool nextsym;
	while ((nextsym = lexicalAnalyzer.nextSymbol())) ;
	fin.close();
	fout.close();
	return 0;
}

