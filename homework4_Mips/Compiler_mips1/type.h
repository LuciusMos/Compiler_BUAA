#pragma once

enum symbolType {
	IDENFR, INTCON, CHARCON, STRCON,
	CONSTTK, INTTK, CHARTK, VOIDTK, MAINTK,
	IFTK, ELSETK, DOTK, WHILETK, FORTK,
	SCANFTK, PRINTFTK, RETURNTK,
	PLUS, MINU, MULT, DIV,
	LSS, LEQ, GRE, GEQ, EQL, NEQ, ASSIGN,
	SEMICN, COMMA,
	LPARENT, RPARENT, //()
	LBRACK, RBRACK,   //[]
	LBRACE, RBRACE    //{}
};

enum EntryKind { //SymbolTable
	CONST, VAR, FUNC
};
enum EntryType { //SymbolTable(Entry) & IMCodeEntry
	VOID, CHAR, INT, STRING
};

enum IMOpType {
	ConstDefInt, ConstDefChar, VarDefInt, VarDefChar,
	FuncDefInt, FuncDefChar, FuncDefVoid,
	ParaInFuncDef, ParaInFuncCall,
	FuncCall, FuncCallRet, NonRetFuncReturn, RetFuncReturn,
	Add, Sub, Mult, Div,
	Assign, ArrayAssign, AssignArray,
	Label,
	Scanf, Printf,
	Bgt, Bge, Blt, Ble, Beq, Bne, Jump
};
enum IMItemKind {
	Const, GlbVar, LcVar, TempVar, Func, String
};

enum LabelType {
	If, While, Dowhile, For
};
