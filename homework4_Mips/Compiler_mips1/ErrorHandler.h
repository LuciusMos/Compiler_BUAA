#pragma once
//#include "LexicalAnalyzer.h"
#include "SymbolTable.h"
using namespace std;

class ErrorHandler
{
public:
	static ErrorHandler& initErrorHandler(/*LexicalAnalyzer& aLexicalAnalyzer,*/ SymbolTable& aSymbolTable, ofstream& ferr);
	// 0 for good, 1 for error
	void lexical(int lineNo); //�Ƿ����Ż򲻷��ϴʷ� a
	int dupDefId(string token, int lineNo); //�����ض��壨������ b����������4����������2
	int dupDefFuncId(string token, int lineNo); //�����ض��壨������ b������ͷ�����з��أ����޷���ֵ��������
	int undefId(string token, int lineNo); //δ��������֣������� c�����ӣ���ֵ��䣬ѭ�����for�������
	int undefFuncId(string token, int lineNo); //δ��������֣������� c����������2
	void paraNoUnmatch(int lineNo); //��������������ƥ�� d��
	void paraTypeUnmatch(int lineNo); //�����������Ͳ�ƥ�� e��
	void paraUnmatch(string token, int lineNo);
	void illegalTypeInCondition(int lineNo); //�����ж��г��ֲ��Ϸ������� f������
	void nonretfuncReturnUnmatch(int lineNo); //�޷���ֵ�ĺ������ڲ�ƥ���return��� g���޷���ֵ�������壬�������
	void retfuncReturnUnmatch(int lineNo); //�з���ֵ�ĺ���ȱ��return������ڲ�ƥ���return��� h���з���ֵ�������壬�������
	void arrayIndexInt(int lineNo); //����Ԫ�ص��±�ֻ�������ͱ��ʽ i�����ӣ���ֵ���
	int constChange(string token, int lineNo); //���ܸı䳣����ֵ j����ֵ��䣬for��scanf
	void semicolon(int lineNo); //ӦΪ�ֺ� k������˵��������˵������䣬ѭ�����for
	void rParent(int lineNo); //ӦΪ��С���š�)�� l����������2�������������ӣ�������䣬ѭ�����3�������������2������䣬д��䣬�������
	void rBracket(int lineNo); //ӦΪ�������š�]�� m���������壬���ӣ���ֵ���
	void lackWhileInDowhile(int lineNo); //do-whileӦΪ�����ȱ��while n
	void intOrCharCon(int lineNo); //����������=����ֻ�������ͻ��ַ��ͳ��� o
	void output();
private:
	//LexicalAnalyzer& lexicalAnalyzer;
	SymbolTable& symbolTable;
	ofstream& errorFile;
	ErrorHandler(/*LexicalAnalyzer& aLexicalAnalyzer,*/ SymbolTable& aSymbolTable, ofstream& ferr);
	void errOutput(char errNo, int lineNo);
	//void jumpToLineEnd();
};

