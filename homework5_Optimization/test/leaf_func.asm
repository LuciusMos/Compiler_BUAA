.data
	string0:	.asciiz "--------Test const in different areas--------"
	string1:	.asciiz "The local Num1 is : "
	string2:	.asciiz "The global Num1 is : "
	string3:	.asciiz "The function's Num1 is : "
	string4:	.asciiz "--------Test finished--------"
	string5:	.asciiz "--------Test var--------"
	string6:	.asciiz "The testch is : "
	string7:	.asciiz "The testCh is : "
	string8:	.asciiz "--------Test finished--------"
	newline:	.asciiz "\n"
.text
	jal	main
	j	end
########	const int num1 = 1024
########	var char testCh
########	func test_same_const1()
test_same_const1:
########	const int num1 = 0
########	func test_same_const1 -> Retreturn  retValue:0
	li	$v0	0
	jr	$ra
########	func test_same_const2()
test_same_const2:
########	func test_same_const2 -> Retreturn  retValue:1024
	li	$v0	1024
	jr	$ra
########	func getCh()
getCh:
########	scanf testCh
	li	$v0	12
	syscall
	sw	$v0	-4	($gp)
########	func getCh -> Retreturn  retValue:testCh
	lw	$v0	-4	($gp)
	jr	$ra
########	func main()
main:
	sw	$ra	-4	($sp)
########	const int num_0 = 0
########	const int num1 = 100
########	var int i
########	=		0		i
	li	$t8	0
	sw	$t8	-12	($sp)
########	Label for_0_begin
for_0_begin:
########	bge		i		10		for_0_end
	lw	$t8	-12	($sp)
	li	$t9	10
	bge	$t8	$t9	for_0_end
########	[]=		0		i		str
	li	$t8	0
	lw	$t9	-12	($sp)
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$t8	-52	($t9)
########	[]=		0		i		abc
	li	$t8	0
	lw	$t9	-12	($sp)
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$t8	-96	($t9)
########	+		i		1		~0
	lw	$t8	-12	($sp)
	li	$t9	1
	add	$t8	$t8	$t9
	sw	$t8	-100	($sp)
########	=		~0		i
	lw	$t8	-100	($sp)
	sw	$t8	-12	($sp)
########	j for_0_begin
	j	for_0_begin
########	Label for_0_end
for_0_end:
########	printf string0
	la	$a0	string0
	li	$v0	4
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf string1
	la	$a0	string1
	li	$v0	4
	syscall
########	printf 100
	li	$t8	100
	move	$a0	$t8
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf string2
	la	$a0	string2
	li	$v0	4
	syscall
########	call test_same_const2
	sw	$sp	-108	($sp)
	subi	$sp	$sp	100
	jal	test_same_const2
	lw	$sp	-8	($sp)
########	~1 = retValue
	sw	$v0	-104	($sp)
########	+		~1		100		~2
	lw	$t8	-104	($sp)
	li	$t9	100
	add	$t8	$t8	$t9
	sw	$t8	-108	($sp)
########	-		~2		100		~3
	lw	$t8	-108	($sp)
	li	$t9	100
	sub	$t8	$t8	$t9
	sw	$t8	-112	($sp)
########	printf ~3
	lw	$t8	-112	($sp)
	move	$a0	$t8
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf string3
	la	$a0	string3
	li	$v0	4
	syscall
########	call test_same_const1
	sw	$sp	-120	($sp)
	subi	$sp	$sp	112
	jal	test_same_const1
	lw	$sp	-8	($sp)
########	~4 = retValue
	sw	$v0	-116	($sp)
########	+		~4		100		~5
	lw	$t8	-116	($sp)
	li	$t9	100
	add	$t8	$t8	$t9
	sw	$t8	-120	($sp)
########	-		~5		100		~6
	lw	$t8	-120	($sp)
	li	$t9	100
	sub	$t8	$t8	$t9
	sw	$t8	-124	($sp)
########	printf ~6
	lw	$t8	-124	($sp)
	move	$a0	$t8
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf string4
	la	$a0	string4
	li	$v0	4
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	scanf testch
	li	$v0	12
	syscall
	sw	$v0	-56	($sp)
########	printf string5
	la	$a0	string5
	li	$v0	4
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf string6
	la	$a0	string6
	li	$v0	4
	syscall
########	printf testch
	lw	$t8	-56	($sp)
	move	$a0	$t8
	li	$v0	11
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf string7
	la	$a0	string7
	li	$v0	4
	syscall
########	call getCh
	sw	$sp	-132	($sp)
	subi	$sp	$sp	124
	jal	getCh
	lw	$sp	-8	($sp)
########	~7 = retValue
	sw	$v0	-128	($sp)
########	printf ~7
	lw	$t8	-128	($sp)
	move	$a0	$t8
	li	$v0	11
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf string8
	la	$a0	string8
	li	$v0	4
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	[]=		1		0		str
	li	$t8	1
	li	$t9	0
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$t8	-52	($t9)
########	[]=		2		1		abc
	li	$t8	2
	li	$t9	1
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$t8	-96	($t9)
########	[]=		3		2		str
	li	$t8	3
	li	$t9	2
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$t8	-52	($t9)
########	[]=		4		3		abc
	li	$t8	4
	li	$t9	3
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$t8	-96	($t9)
########	[]=		5		4		str
	li	$t8	5
	li	$t9	4
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$t8	-52	($t9)
########	[]=		6		5		abc
	li	$t8	6
	li	$t9	5
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$t8	-96	($t9)
########	=[]		str		4		~8
	li	$t8	4
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-52	($t8)
	sw	$t9	-132	($sp)
########	=[]		abc		~8		~9
	lw	$t8	-132	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-96	($t8)
	sw	$t9	-136	($sp)
########	[]=		7		~9		str
	li	$t8	7
	lw	$t9	-136	($sp)
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$t8	-52	($t9)
########	=[]		str		2		~10
	li	$t8	2
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-52	($t8)
	sw	$t9	-140	($sp)
########	=[]		abc		~10		~11
	lw	$t8	-140	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-96	($t8)
	sw	$t9	-144	($sp)
########	=[]		str		~11		~12
	lw	$t8	-144	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-52	($t8)
	sw	$t9	-148	($sp)
########	=[]		abc		~12		~13
	lw	$t8	-148	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-96	($t8)
	sw	$t9	-152	($sp)
########	=[]		str		~13		~14
	lw	$t8	-152	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-52	($t8)
	sw	$t9	-156	($sp)
########	=[]		str		2		~15
	li	$t8	2
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-52	($t8)
	sw	$t9	-160	($sp)
########	=[]		abc		~15		~16
	lw	$t8	-160	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-96	($t8)
	sw	$t9	-164	($sp)
########	=[]		str		~16		~17
	lw	$t8	-164	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-52	($t8)
	sw	$t9	-168	($sp)
########	=[]		abc		~17		~18
	lw	$t8	-168	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-96	($t8)
	sw	$t9	-172	($sp)
########	=[]		str		~18		~19
	lw	$t8	-172	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-52	($t8)
	sw	$t9	-176	($sp)
########	=[]		str		2		~20
	li	$t8	2
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-52	($t8)
	sw	$t9	-180	($sp)
########	=[]		abc		~20		~21
	lw	$t8	-180	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-96	($t8)
	sw	$t9	-184	($sp)
########	=[]		str		~21		~22
	lw	$t8	-184	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-52	($t8)
	sw	$t9	-188	($sp)
########	=[]		abc		~22		~23
	lw	$t8	-188	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-96	($t8)
	sw	$t9	-192	($sp)
########	+		~19		~23		~24
	lw	$t8	-176	($sp)
	lw	$t9	-192	($sp)
	add	$t8	$t8	$t9
	sw	$t8	-196	($sp)
########	[]=		~24		~14		abc
	lw	$t8	-196	($sp)
	lw	$t9	-156	($sp)
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$t8	-96	($t9)
########	=[]		abc		1		~25
	li	$t8	1
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-96	($t8)
	sw	$t9	-200	($sp)
########	+		5		~25		~26
	li	$t8	5
	lw	$t9	-200	($sp)
	add	$t8	$t8	$t9
	sw	$t8	-204	($sp)
########	-		~26		5		~27
	lw	$t8	-204	($sp)
	li	$t9	5
	sub	$t8	$t8	$t9
	sw	$t8	-208	($sp)
########	=[]		str		~27		~28
	lw	$t8	-208	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-52	($t8)
	sw	$t9	-212	($sp)
########	*		6		~28		~29
	li	$t8	6
	lw	$t9	-212	($sp)
	mult	$t8	$t9
	mflo	$t8
	sw	$t8	-216	($sp)
########	/		~29		2		~30
	lw	$t8	-216	($sp)
	li	$t9	2
	div	$t8	$t9
	mflo	$t8
	sw	$t8	-220	($sp)
########	/		~30		3		~31
	lw	$t8	-220	($sp)
	li	$t9	3
	div	$t8	$t9
	mflo	$t8
	sw	$t8	-224	($sp)
########	=[]		abc		~31		~32
	lw	$t8	-224	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-96	($t8)
	sw	$t9	-228	($sp)
########	*		1		~32		~33
	li	$t8	1
	lw	$t9	-228	($sp)
	mult	$t8	$t9
	mflo	$t8
	sw	$t8	-232	($sp)
########	=[]		str		~33		~34
	lw	$t8	-232	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-52	($t8)
	sw	$t9	-236	($sp)
########	+		4		~34		~35
	li	$t8	4
	lw	$t9	-236	($sp)
	add	$t8	$t8	$t9
	sw	$t8	-240	($sp)
########	=[]		str		2		~36
	li	$t8	2
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-52	($t8)
	sw	$t9	-244	($sp)
########	=[]		abc		~36		~37
	lw	$t8	-244	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-96	($t8)
	sw	$t9	-248	($sp)
########	-		~35		~37		~38
	lw	$t8	-240	($sp)
	lw	$t9	-248	($sp)
	sub	$t8	$t8	$t9
	sw	$t8	-252	($sp)
########	=[]		abc		~38		~39
	lw	$t8	-252	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-96	($t8)
	sw	$t9	-256	($sp)
########	=[]		str		~39		~40
	lw	$t8	-256	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-52	($t8)
	sw	$t9	-260	($sp)
########	=[]		abc		~40		~41
	lw	$t8	-260	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-96	($t8)
	sw	$t9	-264	($sp)
########	printf ~41
	lw	$t8	-264	($sp)
	move	$a0	$t8
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	func main -> NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	func main -> NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	Label end
end:
move 