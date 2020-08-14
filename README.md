# Compiler_BUAA

本仓库包括完整编译器（/Compiler/），即历次迭代作业+自己和同学构造一些testfile（homeworkx_xxx）。

## 历次作业简介

本课程用于实践编译课上学到的知识，完成一个功能相对简单的编译器，历次任务主要包括词法分析、语法分析、中间代码生成、目标代码生成、优化及竞速排序。

任务量不加优化最终编译器出来大概在2000行左右，加优化没有上限，如果佛系那么工作量其实可以，如果要争竞速排名那么工作量还是很可观的。

### 1. 文法解读

在分析理解文法的基础上编写符合该文法的4-6个测试程序，要求测试程序覆盖文法中所有的语法成分，以及语法成分的常见组合情况。若测试程序不符合文法规则，则不能得分，对于符合文法规则的测试程序，会累积统计对语法成分和组合情况的覆盖率，根据覆盖率给分。

### 2. 词法分析

根据具体文法编写词法分析程序，要求程序可以实现词法分析，并按规定的格式输出单词信息。

### 3. 语法分析

根据具体文法编写语法分析程序，要求程序可以实现语法分析，并按规定格式输出单词信息（沿用词法分析器的输出）和语法成分名称。要求采用递归子程序法进行语法分析，对不满足条件的文法理论上要进行等价改写；在实现中也可以采用向前查看若干符号的方法。

### 4. 错误处理

针对常见的错误分类编写错误处理程序，要求程序可以对各阶段的错误进行错误局部化处理，并进行补充和完善，按要求输出错误信息。

### 5. 代码生成

根据具体文法生成指定代码的目标程序。目标代码分为PCODE、MIPS汇编两种，二者任选其一。若选择生成PCODE代码，需同时实现能对该代码进行解释执行的程序，根据解释执行的结果进行考核。若选择生成MIPS汇编，建议先生成四元式中间代码，再从中间代码生成MIPS汇编代码，并合理利用临时寄存器（临时寄存器池）生成较高质量的目标代码，以获得较高的代码执行效率。根据汇编代码在Mars模拟器上的运行结果进行考核。**笔者选择生成MIPS汇编。**

完成PCODE代码解释执行的作业，最高分为80。完成MIPS汇编的同学可申优，放弃申优最高分为89分。

### 6. 代码优化

在编译器产生的四元式中间代码基础上完成几种优化算法。选择生成PCODE代码的同学无需完成此项作业。

（1）推荐完成如下代码优化算法：基本块内部的公共子表达式删除（DAG图）；**全局寄存器分配（引用计数或着色算法）**；**数据流分析（通过活跃变量分析，或利用定义-使用链建网等方法建立冲突图）**；还可自选其他优化算法。优化后的MIPS代码用1-3个测试程序进行测试，获取在Mars模拟器上的运行结果，与预期结果进行自动比对，在运行结果正确的基础上参加竞速排序

（2）竞速排序：根据测试程序在学生提交的优化编译器上产生的指令统计数据进行竞速排序，根据排序先后给分。

## 编译器设计文档

### 0. 写在前面

在理论课上，老师讲解了编译器的七个部分，我们的作业也按照部分或者说是步骤，引导我们一步步从零开始搭建了自己的编译器。下面我就这七个部分，分成两节来介绍我的编译器：

- 除了优化之外的六个部分，介绍六个部分的组成及功能
- 单独重点介绍优化方法和思路

### 1. 优化前

#### 1.1 词法分析

利用LexicalAnalyzer来完成词法分析的工作。symbol记录当前符号类型，token将当前符号以字符串的形式完整保存下来。nextSymbol函数用来识别并取出当前单词，该函数由语法分析器GrammarAnalyzer来调用。

理论课上讲了**“遍”**的概念。为了方便第二步的语法分析，防止边取词边分析成分对于语法分析部分代码编写造成的困难，我将词法分析和语法分析作为两遍。语法分析的结果保存在lexicalTable中。

```c++
struct LexicalTable {
	symbolType symbol;
	string token;
	int lineNo;
};
extern LexicalTable lexicalTable[50000]; //词法分析结果表
class LexicalAnalyzer
{
public:
	friend class GrammarAnalyzer;
	friend class ErrorHandler;
	static LexicalAnalyzer &initLexicalAnalyzer(ifstream& fin, ofstream& fout, ErrorHandler& aErrorHandler);
	void lexicalAnalyze();
private:
	ifstream &inputFile;
	ofstream& outputFile;
	ErrorHandler& errorHandler;
	symbolType symbol;
	string token;
	LexicalAnalyzer(ifstream& fin, ofstream& fout, ErrorHandler& aErrorHandler);
	bool nextSymbol(); //TRUE for continue, FALSE for EOF
};
```

#### 1.2 语法分析

利用GrammarAnalyzer来完成语法分析的工作。利用**递归下降子程序**的方法，给外部提供一个grammarAnalyzer的调用接口，内部从program开始递归下降调用不同语法成分的分析子程序。

```c++
class GrammarAnalyzer
{
public:
	static GrammarAnalyzer& initGrammarAnalyzer(LexicalAnalyzer& aLexicalAnalyzer, ofstream& fout, SymbolTable& aSymbolTable, ErrorHandler& aErrorHandler, IMCode& aIMCode);
	int grammarAnalyze();
private:
	GrammarAnalyzer(LexicalAnalyzer& aLexicalAnalyzer, ofstream& fout, SymbolTable& aSymbolTable, ErrorHandler& aErrorHandler, IMCode& aIMCode);
	LexicalAnalyzer& lexicalAnalyzer;
	ofstream& outputFile;
	SymbolTable& symbolTable;
	ErrorHandler& errorHandler;
	IMCode& imCode;
	void lexicalOutput();
	void pushReg();
	void popReg();
	void genExpIMCode(IMOpType imOpType);
	void genAssignIMCode(IMOpType imOpType);
	int stringGrammar();
	int program();
	int constDeclaration(); 
	int constDefinition();
	int unsignedInteger();
	int integer();
	int returnFunctionDefinitionHead(); //(用于有返回值函数)
	int variableDeclaration();
	int variableDefinition(); 
	int returnFunctionDefinition();
	int nonReturnFunctionDefinition();
	int compoundStatement();
	int parameterList(); //用于函数定义语句
	int mainFunction();
	int expression();
	int term();
	int factor();
	int statement();
	int assignStatement();
	int conditionStatement();
	int condition(bool isDoWhile);
	int loopStatement();
	int step();
	IMItem* returnFunctionCall();
	int nonReturnFunctionCall();
	int valueParameterList(string funcName, vector<VarEntry*>* valueParas); //值参数表，用于函数调用语句
	int statementsBlock(); //＜语句列＞   ::= ｛＜语句＞｝
	int readStatement();
	int writeStatement();
	int returnStatement();
```

然而，我们的文法是**不能直接**用递归下降子程序法进行语法分析，其原因在于**FIRST集合交集不全为空**，其中最典型的例子就是【变量说明】与【有返回值函数定义】：

> **＜程序＞  ::= ［＜常量说明＞］［＜变量说明＞］{＜有返回值函数定义＞|＜无返回值函数定义＞}＜主函数＞**

变量说明的形式为：``int a;``有返回值函数定义的形式为：``int a() {...}``。针对该情况，部分同学选择了**预读**的方法，即根据当前单词之后的单词来判断应该调用哪个子程序。而我采用了另一种**回溯**的方法。下面举一个例子说明：

```c++
int GrammarAnalyzer::returnFunctionDefinitionHead() {
	// 1 for int, 2 for char
	pushReg();
	if (lexicalTable[sym_p].symbol != INTTK && lexicalTable[sym_p].symbol != CHARTK) {
		popReg();
		return 0;
	}
	int ret = (lexicalTable[sym_p].symbol == INTTK) ? 1 : 2;
	lexicalOutput();
	if (lexicalTable[sym_p].symbol != IDENFR) {
		popReg();
		return 0;
	}
	lexicalOutput();
	output[out_p++] = "<声明头部>\n";
	return ret;
}
```

代码中的``popReg()``就是在回溯。该子程序分析的语句是声明头部（是有返回值函数定义的一部分），首先检查第一个符号是不是INTTK或者CHARTK，不是的话则回溯；然后继续检查第二个符号是不是标识符，不是的话则回溯。若中间没有发生回溯，则会到达分析结束后的输出及正常返回部分。

不过仅利用回溯编写代码会比较困难，所以我也**结合**了上述预读单词，然后选择分支的方法。由于需要预读，所以如果词法分析和语法分析在一遍中完成就涉及到了**文件指针的回退**问题；将这两个部分作为**两遍**，就可以比较简单地完成预读。

#### 1.3 符号表

符号表部分我定义了以下几个类：

首先是**符号表类**，存储了**函数表**、当前函数**局部变量表**、**全局变量表**。

```c++
class SymbolTable
{
private:
	vector<FuncEntry*> funcTable;
	vector<Entry*> localIdenfrTable;
	vector<Entry*> globalIdenfrTable;
public:
    ...
};
```

然后定义了符号表项的**父类Entry**，细分的**变量项VarEntry**、**常量项ConstEntry**、**函数项FuncEntry**继承了父类。（代码中只展示了成员属性）

```c++
class Entry {
	string name;
	EntryKind kind; //CONST, VAR, FUNC
	EntryType type; //VOID, CHAR, INT, STRING
};
class VarEntry : public Entry {
	int dim; //维数，该文法中只能为1或0
	int arrSize; //如果dim==1，则表示数组大小
	int offset; //在当前栈中的位置
};
class ConstEntry : public Entry {
	int value; //常量值
};
class FuncEntry : public Entry {
	vector<VarEntry*> paras; //参数
	vector<Entry*> idenfrTable; //函数内定义的局部变量+参数
	map<IMItem, string> aVar2Reg; //为该函数分配的$a寄存器
	map<IMItem, string> sVar2Reg; //为该函数分配的$s寄存器
};
```

#### 1.4 错误处理

错误可能发生在**词法分析**或**语法分析**的阶段，所以给LexicalAnalyzer和GrammarAnalyzer中传递了了ErrorHandler的实例。ErrorHandler的函数用于处理各种错误，有的**由语法/词法分析程序判断是否有错**，调用后直接报错即可，如a类错误非法符号或不符合词法、l类错误应为')'等；而大部分需要根据传进来的参数，再调用符号表的函数，根据**符号表中已定义的符号**来判断是否有错，比如b类错误名字重定义、de类错误函数参数个数/类型不匹配等。

```c++
class ErrorHandler
{
public:
	static ErrorHandler& initErrorHandler(/*LexicalAnalyzer& aLexicalAnalyzer,*/ SymbolTable& aSymbolTable, ofstream& ferr);
	// 0 for good, 1 for error
    //非法符号或不符合词法 a
	void lexical(int lineNo); 
    //名字重定义（变量） b：常量定义4，变量定义2
	int dupDefId(string token, int lineNo); 
    //名字重定义（函数） b：声明头部（有返回），无返回值函数定义
	int dupDefFuncId(string token, int lineNo);
    //未定义的名字（变量） c：因子，赋值语句，循环语句for，读语句
	int undefId(string token, int lineNo); 
    //未定义的名字（函数） c：函数调用2
	int undefFuncId(string token, int lineNo); 
    //函数参数个数不匹配 d：   函数参数类型不匹配 e：
	void paraUnmatch(string token, int lineNo, vector<VarEntry*>* valueParas);
    //条件判断中出现不合法的类型 f：条件
	void illegalTypeInCondition(int lineNo); 
    //无返回值的函数存在不匹配的return语句 g：无返回值函数定义，返回语句
	void nonretfuncReturnUnmatch(int lineNo); 
    //有返回值的函数缺少return语句或存在不匹配的return语句 h：有返回值函数定义，返回语句
	void retfuncReturnUnmatch(int lineNo); 
    //数组元素的下标只能是整型表达式 i：因子，赋值语句
	void arrayIndexInt(int lineNo); 
    //不能改变常量的值 j：赋值语句，for，scanf
	int constChange(string token, int lineNo); 
    //应为分号 k：常量说明，变量说明，语句，循环语句for
	void semicolon(int lineNo); 
    //应为右小括号’)’ l：函数定义2，主函数，因子，条件语句，循环语句3，函数调用语句2，读语句，写语句，返回语句
	void rParent(int lineNo); 
    //应为右中括号’]’ m：变量定义，因子，赋值语句
	void rBracket(int lineNo); 
    //do-while应为语句中缺少while n
	void lackWhileInDowhile(int lineNo); 
    //常量定义中=后面只能是整型或字符型常量 o
	void intOrCharCon(int lineNo); 
};
```

在错误处理部分，由于提出了一些检测的需求，而这些需求无法在原来语法分析的架构中完成，所以对语法分析也做了一定的改写。例如，对于**表达式是否为int**的判断，由于表达式为char**仅有以下三种情况**：

> ​	1）表达式由<标识符>或＜标识符＞'['＜表达式＞']构成，且<标识符>的类型为char，即char类型的常量和变量、char类型的数组元素。
>
> ​	2）表达式仅由一个<字符>构成，即字符字面量。
>
> ​	3）表达式仅由一个有返回值的函数调用构成，且该被调用的函数返回值为char型
>
> 除此之外的所有情况，<表达式>的类型都是int

对于表达式来说，递归下降子程序的顺序是表达式 -> 项 -> 因子，所以将这三个子程序的返回值都改为了int，若为1则表示int，若为2则表示char

- 在表达式中判断是否**仅有一个项**
- 在项中判断是否**仅有一个因子**
- 在因子中判断是否为**字符常量**或**返回值为char的函数调用**

当这三个条件都成立时当前表达式为char型，否则全部为int型。

#### 1.5 中间代码

在语法分析的基础上，我们可以生成四元式形式中间代码。我的中间代码按照如下层级构建：

首先是四元式的**操作数**，也就是**“元”**，由于在后边IMItem用set容器存储，也做过map的key，所以**重载了<运算符**。

```c++
//四元式的操作数
class IMItem
{
private:
	string name;
	IMItemKind kind; //Const, GlbVar, LcVar, TempVar, Func, String
	int value; //Const:值, Var:偏移, TempVar:偏移
	EntryType type;
	string funcName;
public:
	...
	bool operator < (const IMItem& cmp) const {
		if (this->name != cmp.name) 
			return (this->name < cmp.name);
		if (this->kind != cmp.kind)
			return (this->kind < cmp.kind);
		if (this->value != cmp.value)
			return (this->value < cmp.value);
		if (this->type != cmp.type)
			return (this->type < cmp.type);
		if (this->funcName != cmp.funcName)
			return (this->funcName < cmp.funcName);
		return false;
	}
};
```

有了“元”，就可以构建**四元式**了，有**一个操作符和三个操作数**组成：

```c++
//四元式
class IMCodeEntry {
	IMOpType op;
	IMItem* item1 = NULL;
	IMItem* item2 = NULL;
	IMItem* item3 = NULL;
};
```

在四元式的基础上，为了方便优化，我构建了**基本块**。按照理论课所讲算法，我在基本块中存储了后继块块号（begin和next就是为了确定后继块块号的）、def use in out四个集合。

```c++
//基本块
class Block {
	int blockNo; //块号
	string begin; //起始label
	string next; //后继块label
	set<int> followBlocksNo; //后继块块号
	set<IMItem> def;
	set<IMItem> use;
	set<IMItem> in;
	set<IMItem> out;
	vector<IMCodeEntry*> imCodesInBlock; //四元式
};
```

将基本块再存在一起，就是整个**中间代码**了，下边的代码中除了四元式集合和基本块集合两个成员变量外，还列出了一些优化函数：

```c++
//中间代码
class IMCode {
	vector<IMCodeEntry*> IMCodeTable;
	vector<Block*> blockTable;
	void judgeLeafFunc();
	void insertProtectEnvOp();
	void cutBlocks();
	void genConflictGraph();
	void colorizeConflictGraph();
	void allocSTReg();
	void IM_modDetect();
	void IM_selfOp();
	void IM_imm2Second();
	void IM_eraseUseless();
};
```

另外，附上我设计的【**中间代码格式**】：

| op                                | item1                                  | item2          | item3              | Example                 |
| --------------------------------- | -------------------------------------- | -------------- | ------------------ | ----------------------- |
| ConstDefInt                       | ("1", Const, INT, 1)                   | \              | \                  | const int a = 1;        |
| ConstDefChar                      | ("2", Const, CHAR, '2' )               | \              | \                  | const char b = '2'      |
| VarDefInt                         | (a, , INT, offset)                     | \              | \                  | int a                   |
| VarDefChar                        | (b, , CHAR, offset)                    | \              | \                  | char b                  |
| FuncDef                           | ("fun3", Func, VOID, 0)                | \              | \                  | void fun3()             |
| ParaInFuncDef                     | a                                      | \              | \                  | int fun1(int a)         |
| ParaInFuncCall                    | exp                                    | new_pos/ "$a2" | fun1               | fun1(exp)               |
| FuncCall                          | ("presentSize", Const, INT, varOffset) | ("fun1", , , ) | \   or   ("NoJal") | fun1()                  |
| FuncCallRet                       | ("FunRet_temp", LcVar, , varOffset)    | \              | \                  | FunRet_temp = fun1()    |
| NonRetFuncReturn                  | curFunc                                | \              | \    or ("NoJr")   | return                  |
| RetFuncReturn                     | curFunc                                | t              | \    or ("NoJr")   | return(t)               |
| Add                               | b                                      | c              | a                  | a = b + c               |
| Sub                               | b                                      | c              | a                  | a = b - c               |
| Mult                              | b                                      | c              | a                  | a = b * c               |
| Div                               | b                                      | c              | a                  | a = b / c               |
| Assign                            | t                                      | a              | \                  | a = t                   |
| AssignArray                       | arr                                    | 3              | a                  | a = arr[3]              |
| ArrayAssign                       | t                                      | 2              | arr                | arr[2] = t              |
| Label                             | ("for_1_begin", , , )                  | \              | \                  | for(...) {}             |
| Scanf                             | a                                      | \              | \                  | scanf(a)                |
| Printf                            | a                                      | \              | \                  | printf(a)               |
| B__(Bgt, Bge, Blt, Ble, Beq, Bne) | item1                                  | item2          | label              | b__ item1, item2, label |
| Jump                              | ("for_1_end", , , )                    | \              | \                  | for(...) {}             |

#### 1.6 目标代码

ObjectCode接受来自IMCode的四元式，并完成从四元式到目标代码的翻译工作，其中常用的读取数据到寄存器**loadToReg**和将寄存器中的值写回内存**storeToMem**这两项操作（当然，在代码优化之后可能数据已经在寄存器中，不一定需要重复读取；或者可能不需要写回到内存，放在寄存器中就好）写成了函数方便调用。

```c++
class ObjectCode
{
public:
	void genMips();
private:
	IMCode& imCode;
	SymbolTable& symbolTable;
	vector<Block*> blockTable;
	string loadToReg(IMItem item, string regName, bool mustFromMem, bool mustToReg);
	void storeToMem(IMItem item, string reg, bool mustToReg, bool mustToMem);
};
```

### 2. 优化

上述是我的编译器的基本架构，完成了词法分析、语法分析、生成中间代码、生成目标代码这四个步骤，并介绍了符号表和错误处理这两个部件，理论课中讲的五步七部分就只剩下最后一个了：**位于生成目标代码及生成中间代码之间**的优化。

观察竞速程序的指令类型计数，可以发现**mem, alu, jump**三类指令占了相当多的cycle且有很大的优化空间，所以将从这三个方面介绍我的优化思路。

#### 2.1 Mem类优化

##### 2.1.1 分基本块

**要完成优化，首先要做的就是分基本块。**在我的中间代码中，以下四元式是可能会**划分基本块**的：

- **第一类**表示，截止到该句且不包含该句，以上内容可以分为一块，**从该句开始要划分新块**。包括Label, FuncDef。
- **第二类**表示，截止到该句且包含该句，以上内容可以分为一块，**从下一句开始要划分新块**。包括B__系列, FuncCall, RetFuncReturn, NonRetFuncReturn, Jump

由于之后要采用活跃变量分析，所以需要在分块的同时就计算好该块的def和use。所以对于一些**不涉及分块**的四元式，如Printf, Add, ParaInFuncCall等，不需要分新块，只需要添加def和use。

下边举三个相应的例子：

```c++
		switch (op)
		{
        // 分块第一类
		case Label: {
			if (tImCodes.size() > 0) {
				Block* nowBlock = new Block(blockCnt++, tDef, tUse, tBegin, tNext, tImCodes);
				nowBlock->insertFollowBlocksNo(blockCnt); //下一句
				blockTable.push_back(nowBlock);
			}
			tClear();
			tImCodes.push_back(IMCodeTable[i]);
			tBegin = IMCodeTable[i]->getItem1()->getName();
			break;
		}
        // 分块第二类
        case Bgt:
		case Bge:
		case Blt:
		case Ble:
		case Beq:
		case Bne: {
			//截止到branch建立一个基本块，然后开始新的基本块
			insertTUse(IMCodeTable[i]->getItem1());
			insertTUse(IMCodeTable[i]->getItem2());
			tNext = IMCodeTable[i]->getItem3()->getName();
			tImCodes.push_back(IMCodeTable[i]);
			Block* nowBlock = new Block(blockCnt++, tDef, tUse, tBegin, tNext, tImCodes);
			nowBlock->insertFollowBlocksNo(blockCnt);
			blockTable.push_back(nowBlock);
			tClear();
			break;
		}
        // 不分块
		case Add: 
		case Sub: 
		case Mult: 
		case Div: 
			insertTUse(IMCodeTable[i]->getItem1());
			insertTUse(IMCodeTable[i]->getItem2());
			insertTDef(IMCodeTable[i]->getItem3());
			tImCodes.push_back(IMCodeTable[i]);
			break;
		...
		}
```

需要注意的是，在分块的最后要手动加上一个**结束块**。

在划分基本块的过程中，需要维护每一个块的begin和next两个string，然后根据这两个标签来计算每一块的**后继块**都有谁。计算好后继块后，就利用理论课讲的算法计算每一个块的**in, out集合**，**为下一步构建冲突图做准备**。

##### 2.1.2 构建冲突图

在构建冲突图中，我采用了马振亚学长的算法：

> 对于基本块B，首先令live = out[B]
>
> ​    然后对于B中的指令I，从后往前，开始遍历
>
> ​       对于任意变量x属于def(I)，对于任意变量y属于live
>
> ​           冲突图添加边(x,y)
>
> ​       然后更新live = use(I) U (live-def(I))

可以发现，这个过程中的def和use和活跃变量分析中非常相似，其区别在于：**活跃变量分析中的def和use是整个基本块的，而构建冲突图时的def和use都是针对每一个四元式的**，所以对每一个四元式，初始的tUse和tDef都需要**清空**。

```c++
	for (int i = 0; i < blockTable.size(); i++) {
		vector<IMCodeEntry*> tImCodes = blockTable[i]->getIMCodesInBlock();
		tOut.clear();
		tOut = blockTable[i]->getOut();
		for (int j = tImCodes.size() - 1; j >= 0; j--) {
			tUse.clear(); //清空
			tDef.clear(); //清空
			switch (tImCodes[j]->getOp())
			{
				...
			}
			updateConflictGraph(); //构建冲突图
			// 更新 tOut = tUse + (tOut - tDef)
			for (set<IMItem>::iterator defIter = tDef.begin(); defIter != tDef.end(); defIter++) {
				tOut.erase(*defIter);
			}
			for (set<IMItem>::iterator useIter = tUse.begin(); useIter != tUse.end(); useIter++) {
				tOut.insert(*useIter);
			}
		}
	}
```

每一句四元式分析完def和use后，就可以**添加冲突边**了。我使用了``map<IMItem, set\<IMItem>>``这样一个数据结构来存储**无向图**。

```c++
map<IMItem, set<IMItem>> conflictGraph;
void addEdge(set<IMItem>::iterator iter1, set<IMItem>::iterator iter2) {
	if (conflictGraph.count(*iter1) != 0) {
		(conflictGraph[*iter1]).insert(*iter2);
	} else {
		set<IMItem> value = { *iter2 };
		conflictGraph.insert(pair<IMItem, set<IMItem>>(*iter1, value));
	}
}
void updateConflictGraph() {
	for (set<IMItem>::iterator defIter = tDef.begin(); defIter != tDef.end(); defIter++) {
		for (set<IMItem>::iterator outIter = tOut.begin(); outIter != tOut.end(); outIter++) {
			addEdge(defIter, outIter);
			addEdge(outIter, defIter);
		}
	}
}
```

##### 2.1.3 染色

构建好冲突图后，就可以按照理论课所讲的启发式算法来为冲突图染色了。染色分为两步：

1. **启发式算法从冲突图中删点：**点分为两类，若所连边数小于颜色个数，则为满足染色条件的点，否则为不满足染色条件的点。若满足颜色条件，则可从图中删去，进入结点栈；否则需要将点标记为不需要染色，再从图中删去，不进入结点栈。
2. **根据结点栈逆向添加删去的点，并为加入的点染色：**由于结点栈中只有需要被染色的点，所以每个加入的点都需要被染色。

```c++
void IMCode::colorizeConflictGraph() {
	// 启发式删点
	tConflictGraph = conflictGraph;
	removeSatVertex();
	while (tConflictGraph.size() > 0) {
		map<IMItem, set<IMItem>>::iterator first = tConflictGraph.begin();
		vertex2Color[first->first] = -1;
		for (map<IMItem, set<IMItem>>::iterator valueIter = tConflictGraph.begin(); valueIter != tConflictGraph.end(); valueIter++) {
			valueIter->second.erase(first->first);
		}
		tConflictGraph.erase(first);
		removeSatVertex();
	}
	// 将删去的点逆序加回，然后染色
	for (int i = vertexStack.size() - 1; i >= 0; i--) {
		IMItem nowVertex = vertexStack[i];
		if (vertex2Color.count(nowVertex) == 0) { // nowVertex尚未染色
			int color = allocColor(nowVertex);
			vertex2Color[nowVertex] = color;
			colorUsed[color] = 1;
		}
		clearUsedColor();
	}
}
```

##### 2.1.4 分配\$t及\$s寄存器

在染好色之后，就可以分配**\$s寄存器**了，我的\$s寄存器池还包括\$v1,\$fp两个我没有用到的寄存器，以及没有用到的临时寄存器。其中sRegNum就是在染色中可用的颜色的个数。

```c++
vector<string> sRegPool = { "$s0", "$s1", "$s2", "$s3", "$s4", "$s5", "$s6", "$s7", "$v1", "$fp", "$t3", "$t4", "$t5", "$t6", "$t7" };
int sRegNum = sRegPool.size();
vector<string> tRegPool = { "$t0", "$t1", "$t2" };
int tRegNum = tRegPool.size;
```

对于**$t寄存器**来说，由于一个四元式最多含有三个临时变量，所以最多只需要三个临时寄存器。但要注意的是，当寄存器对应的临时变量改变时（即被分配给了新的临时变量），需要将原先的临时变量存回内存，少分配\$t给\$s寄存器池固然可以给更多的局部变量分配寄存器，但临时寄存器池的缩小也会导致mem指令增加，所以为临时寄存器池分配多少个\$t寄存器是一个需要**平衡二者开销**的问题。

#### 2.2 ALU类优化

ALU类的优化都是针对一个基本块内部而言的，所以层级结构是**IMCode遍历所有的基本块，然后调用每个基本块的相应的优化函数**。

##### 2.2.1 中间结果及立即数

观察我生成的目标代码，对于中间代码``+ a 1 a``会生成以下的指令：

```
li $t0  1
lw $s2  -16($sp)
add $t1 $s2 $t0
move $s2 $t1
```

有两个问题：

1. 先将a+1的结果算出来保存在临时变量中，再从临时变量加载到a中，可以直接保存在a中
2. 没有利用``addi``这种接受立即数的指令，将1这个常量先加载到了寄存器中，再进行运算

针对**中间结果**问题，我检查连续两句是否满足：1）前一句是否为加减乘除类语句，后一句是否为赋值类语句；2）前一句的dst操作数是否为后一句的src操作数。若均满足，则可以省略中间结果，直接将值存在后一句dst操作数中。

针对**立即数指令**问题，我检查add和b\_\_系列语句的第一个操作数是否为常数，若是常数，则与第二个操作数交换（对于b\_\_系列，若为ble, blt, bge, bgt还要取反），然后在生成中间代码的时候，若检测到add, sub第二个操作数为常量，则使用addi指令（将sub也用addi表示），若检测到b\_\_系列的第二个操作数为常量，则不需要更改指令，直接将常量加载到寄存器即可。

代码示例如下：

```c++
void IMCode::IM_selfOp() {
	for (int i = 0; i < blockTable.size(); i++) {
		blockTable[i]->Block_selfOp();
	}
}
void Block::Block_selfOp() {
	if (imCodesInBlock.size() <= 1) return;
	bool canIter = true;
	while (canIter) {
		canIter = false;
		for (vector<IMCodeEntry*>::iterator selfIter = imCodesInBlock.begin(); selfIter < imCodesInBlock.end() - 1; selfIter++) {
			IMCodeEntry* entry1 = *selfIter;
			IMCodeEntry* entry2 = *(selfIter + 1);
			if ((entry1->getOp() == IMOpType::Add || entry1->getOp() == IMOpType::Sub || entry1->getOp() == IMOpType::Mult ||
				entry1->getOp() == IMOpType::Div || entry1->getOp() == IMOpType::Mod) && entry2->getOp() == IMOpType::Assign
				&& entry2->getItem1()->equalsTo(*entry1->getItem3()) && entry2->getItem1()->getKind() == IMItemKind::TempVar) {
				canIter = true;
				IMCodeEntry* selfOpEntry = new IMCodeEntry(entry1->getOp(), entry1->getItem1(), entry1->getItem2(), entry2->getItem2());
				selfIter = imCodesInBlock.erase(selfIter, selfIter + 2);
				selfIter = imCodesInBlock.insert(selfIter, selfOpEntry);
				if (selfIter == imCodesInBlock.end()) break;
			}
		}
	}
}
```

##### 2.2.2 无用代码删除

代码中可能会有一些没有用的代码，例如在我们的竞速程序中，complete_flower_num函数中有一条语句``x1 = (j/i) * i ;``出现在两层for中，但计算出的x1在后续中并没有用到，如果可以将这句话删除就可以减少很多ALU指令。

删除无用代码用到了每一个基本块的in, out集合，其基本思想和构建冲突图非常相似，依然用到了前述的live集。具体做法是将live集初始化为块的out，然后从后向前扫描，到达当条指令时如果当前指令**有定义变量**，且**out中不包含当条指令定义的变量**，则该句为**可以删除**的。但要注意，**Scanf**语句由于与输入有关，所以不能删除，**ArrayAssign**语句由于不会将数组添加到def中，但确实产生了效果，不能判断该语句是否无用，所以也不能删除。

删除了一条def为局部变量的语句后，我们会发现，之前可能还存在很多改变了临时变量的值的语句，如果当前语句使用了这些临时变量的值，那么其实之前的这些变量也是无用的。所以需要记录一下被删除语句中使用到的临时变量，叫做**无用临时变量**，再向上遍历四元式的过程中，如果当前语句改变了无用临时变量中临时变量的值，那么当条语句也可以删除。

该算法前边的部分和构建冲突图十分类似，故在此处只放了删除四元式的代码。

```c++
		if (tDef.size() != 0) { //定义局部变量
			IMItem defItem = *tDef.begin();
			if (tOut.count(defItem) == 0) { //out中不含有当前语句的def，即可以删去该语句
				eraseIter = vector<IMCodeEntry*>::reverse_iterator(imCodesInBlock.erase((++eraseIter).base()));
				// 维护无用临时变量
                for (set<IMItem>::iterator useIter = tempUseInErase.begin(); useIter != tempUseInErase.end(); useIter++) {
					if ((*useIter).getKind() == IMItemKind::TempVar) {
						tempCanBeErased.insert(*useIter);
					}
				}
				continue;
			}
		}
		if (tempDefInErase.size() != 0) { //定义临时变量
			IMItem defTemp = *tempDefInErase.begin();
			if (tempCanBeErased.count(defTemp) != 0) { //当前tempDef是无用临时变量，可以删去该语句
				eraseIter = vector<IMCodeEntry*>::reverse_iterator(imCodesInBlock.erase((++eraseIter).base()));
				// 维护无用临时变量
                for (set<IMItem>::iterator useIter = tempUseInErase.begin(); useIter != tempUseInErase.end(); useIter++) {
					if ((*useIter).getKind() == IMItemKind::TempVar) {
						tempCanBeErased.insert(*useIter);
					}
				}
				continue;
			}
		}
```

#### 2.3 JUMP优化

##### 2.3.1 for改do-while

这个方法讨论区中已经讲得比较详细了，其基本思想就是将for循环改为do-while循环（外加一条if），来**减少不必要的 j 指令**。这个是原本的类C代码和生成的目标代码：

```c++
for (i = 0; a < b; c = d + 1) {
	//do something...
}
```

```
	i = 0
for_begin:
	bge a b for_end
	#### do something...
	c = d + 1
	j for_begin
for_end:
```

转换为do-while后的类C代码和目标代码为：

```c++
i = 0;
if (a < b) {
	do {
       //do something...
       c = d + 1;
    } while (a < b)
}
```

```
	i = 0
	bge a b if_end
dowhile_begin:
	#### do something...
	c = d + 1
	blt a b dowhile_begin
if_end:
```

完成这一步优化相当于直接改变语义，所以需要在**语法分析**中进行。需要注意的一点是条件``a<b``使用了两次，且中间会跨国复合语句，所以在第一次使用时需要将其记录一下，一直传递到第二次使用时。

### 3. 写在最后

历时三个多月，编译课设终于在神仙竞速中接近了尾声。和计算机组成原理及操作系统两门课程的课设相比，我觉得编译技术课设的难度只高不低，因为在前两门课中，最后要做出什么成果、如何一步步做到那个成果，大多都是有定式的，大家写出来的东西相差不会太多，特别是操作系统是在已有代码的基础上添加函数，我们只需要理解架构，却不需要设计架构。但编译课设的整个系统完全由自己独立设计，七个部分确实相对较为独立，但是五个步骤的每一步和上一步，以及步骤和符号表、错误处理之间都有着很强的关联，架构的设计应该从一开始就重视起来，在整个过程中贯彻高内聚低耦合的设计思想，而不是写到一半突然发现因为没有好好设计架构导致编码上出现了各种困难。

难度的另一方面，体现在优化。优化是八仙过海各显神通的舞台，开放性的问题给大家留出了很大的发挥空间，也极大提高了这门课的难度上限。从没优化时的几百万条，到优化结束后二十多万条，优化的每一步都有回报。优化是一个痛苦并快乐的过程，优化出bug就痛苦，de完bug看到排名上升就快乐（然而过几个小时发现排名掉了就又痛苦了）。上课时老师曾给我们看了一张图，大意是初始时优化的回报非常大，简单的优化可以带来性能的极大提升；随着优化的深入，性能提升的幅度会越来越小。我们现在应当处于回报率非常高这一阶段的靠前位置，时间所限，有很多课上讲过或者提过的优化还都没有实现，如公共子表达式、循环中的优化、函数内联等等。

最后，感谢课程组提供的指引和答疑，感谢身边各位大佬在各个阶段给我提供的帮助和无私的经验分享，助我们所学都有所用，助编译课设越来越好！