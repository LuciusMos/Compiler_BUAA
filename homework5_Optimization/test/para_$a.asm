.data
	string0:	.asciiz "const calculate test: "
	string1:	.asciiz "+-*/This var I is "
	string2:	.asciiz "array test: testnum[9] = "
	string3:	.asciiz "array test: testnum[0] = "
	string4:	.asciiz "Let's start test!"
	string5:	.asciiz "Answer No.4 is : "
	string6:	.asciiz "Answer No.3 is : "
	string7:	.asciiz "Answer No.2 is : "
	string8:	.asciiz "Answer No.1 is : "
	string9:	.asciiz "Congratulations"
	string10:	.asciiz "Error1"
	string11:	.asciiz "Error2"
	string12:	.asciiz "Error3"
	newline:	.asciiz "\n"
.text
	jal	main
	j	end
########	func gets1()
gets1:
########	var int i
########	=		0		i
	li	$t8	0
	sw	$t8	-20	($sp)
########	Label dowhile_0_begin
dowhile_0_begin:
########	+		i		1		~0
	lw	$t8	-20	($sp)
	li	$t9	1
	add	$t8	$t8	$t9
	sw	$t8	-24	($sp)
########	=		~0		i
	lw	$t8	-24	($sp)
	sw	$t8	-20	($sp)
########	+		var2		var1		~1
	add	$t8	$a2	$a1
	sw	$t8	-28	($sp)
########	=		~1		var1
	lw	$t8	-28	($sp)
	move	$a1	$t8
########	bge		i		var2		dowhile_0_end
	lw	$t8	-20	($sp)
	bge	$t8	$a2	dowhile_0_end
########	j dowhile_0_begin
	j	dowhile_0_begin
########	Label dowhile_0_end
dowhile_0_end:
########	=		var1		change1
	sw	$a1	-4	($gp)
########	*		change1		var2		~2
	lw	$t8	-4	($gp)
	mult	$t8	$a2
	mflo	$t8
	sw	$t8	-32	($sp)
########	+		var2		1		~3
	li	$t9	1
	add	$t8	$a2	$t9
	sw	$t8	-36	($sp)
########	-		~3		1		~4
	lw	$t8	-36	($sp)
	li	$t9	1
	sub	$t8	$t8	$t9
	sw	$t8	-40	($sp)
########	/		~2		~4		~5
	lw	$t8	-32	($sp)
	lw	$t9	-40	($sp)
	div 	$t8	$t9
	mflo	$t8
	sw	$t8	-44	($sp)
########	func gets1 -> Retreturn  retValue:~5
	lw	$v0	-44	($sp)
	jr	$ra
########	func gets2()
gets2:
########	var int i
########	=		0		i
	li	$t8	0
	sw	$t8	-20	($sp)
########	Label for_0_begin
for_0_begin:
########	bge		i		var2		for_0_end
	lw	$t8	-20	($sp)
	bge	$t8	$a2	for_0_end
########	+		var2		var1		~6
	add	$t8	$a2	$a1
	sw	$t8	-24	($sp)
########	=		~6		var1
	lw	$t8	-24	($sp)
	move	$a1	$t8
########	+		i		1		~7
	lw	$t8	-20	($sp)
	li	$t9	1
	add	$t8	$t8	$t9
	sw	$t8	-28	($sp)
########	=		~7		i
	lw	$t8	-28	($sp)
	sw	$t8	-20	($sp)
########	j for_0_begin
	j	for_0_begin
########	Label for_0_end
for_0_end:
########	=		var1		change2
	sw	$a1	-8	($gp)
########	+		var1		var1		~8
	add	$t8	$a1	$a1
	sw	$t8	-32	($sp)
########	-		~8		var1		~9
	lw	$t8	-32	($sp)
	sub	$t8	$t8	$a1
	sw	$t8	-36	($sp)
########	func gets2 -> Retreturn  retValue:~9
	lw	$v0	-36	($sp)
	jr	$ra
########	func gets3()
gets3:
########	var int i
########	=		0		i
	li	$t8	0
	sw	$t8	-20	($sp)
########	Label while_0_begin
while_0_begin:
########	bge		i		var2		while_0_end
	lw	$t8	-20	($sp)
	bge	$t8	$a2	while_0_end
########	+		i		1		~10
	lw	$t8	-20	($sp)
	li	$t9	1
	add	$t8	$t8	$t9
	sw	$t8	-24	($sp)
########	=		~10		i
	lw	$t8	-24	($sp)
	sw	$t8	-20	($sp)
########	+		var2		var1		~11
	add	$t8	$a2	$a1
	sw	$t8	-28	($sp)
########	=		~11		var1
	lw	$t8	-28	($sp)
	move	$a1	$t8
########	j while_0_begin
	j	while_0_begin
########	Label while_0_end
while_0_end:
########	=		var1		change3
	sw	$a1	-12	($gp)
########	+		change3		0		~12
	lw	$t8	-12	($gp)
	li	$t9	0
	add	$t8	$t8	$t9
	sw	$t8	-32	($sp)
########	func gets3 -> Retreturn  retValue:~12
	lw	$v0	-32	($sp)
	jr	$ra
########	func gets4()
gets4:
########	*		var2		var2		~13
	mult	$a2	$a2
	mflo	$t8
	sw	$t8	-20	($sp)
########	+		var1		~13		~14
	lw	$t9	-20	($sp)
	add	$t8	$a1	$t9
	sw	$t8	-24	($sp)
########	func gets4 -> Retreturn  retValue:~14
	lw	$v0	-24	($sp)
	jr	$ra
########	func main()
main:
	sw	$ra	-4	($sp)
########	const int const1 = -10
########	const int const2 = 10
########	var int i
########	printf string0
	la	$a0	string0
	li	$v0	4
	syscall
########	printf 1
	li	$t8	1
	move	$a0	$t8
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	scanf i
	li	$v0	5
	syscall
	sw	$v0	-12	($sp)
########	scanf k
	li	$v0	5
	syscall
	sw	$v0	-16	($sp)
########	printf string1
	la	$a0	string1
	li	$v0	4
	syscall
########	printf i
	lw	$t8	-12	($sp)
	move	$a0	$t8
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=		0		i
	li	$t8	0
	sw	$t8	-12	($sp)
########	Label for_1_begin
for_1_begin:
########	bge		i		10		for_1_end
	lw	$t8	-12	($sp)
	li	$t9	10
	bge	$t8	$t9	for_1_end
########	+		i		17060000		~15
	lw	$t8	-12	($sp)
	li	$t9	17060000
	add	$t8	$t8	$t9
	sw	$t8	-60	($sp)
########	[]=		~15		i		testnum
	lw	$t8	-60	($sp)
	lw	$t9	-12	($sp)
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$t8	-56	($t9)
########	+		i		1		~16
	lw	$t8	-12	($sp)
	li	$t9	1
	add	$t8	$t8	$t9
	sw	$t8	-64	($sp)
########	=		~16		i
	lw	$t8	-64	($sp)
	sw	$t8	-12	($sp)
########	j for_1_begin
	j	for_1_begin
########	Label for_1_end
for_1_end:
########	printf string2
	la	$a0	string2
	li	$v0	4
	syscall
########	=[]		testnum		9		~17
	li	$t8	9
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-56	($t8)
	sw	$t9	-68	($sp)
########	printf ~17
	lw	$t8	-68	($sp)
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
########	=[]		testnum		0		~18
	li	$t8	0
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-56	($t8)
	sw	$t9	-72	($sp)
########	printf ~18
	lw	$t8	-72	($sp)
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
########	printf string5
	la	$a0	string5
	li	$v0	4
	syscall
########	push -10
	li	$a1	-10
########	push k
	lw	$a2	-16	($sp)
########	call gets4
	sw	$sp	-80	($sp)
	subi	$sp	$sp	72
	jal	gets4
	lw	$sp	-8	($sp)
########	~19 = retValue
	sw	$v0	-76	($sp)
########	printf ~19
	lw	$t8	-76	($sp)
	move	$a0	$t8
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf string6
	la	$a0	string6
	li	$v0	4
	syscall
########	push -10
	li	$a1	-10
########	push k
	lw	$a2	-16	($sp)
########	call gets3
	sw	$sp	-84	($sp)
	subi	$sp	$sp	76
	jal	gets3
	lw	$sp	-8	($sp)
########	~20 = retValue
	sw	$v0	-80	($sp)
########	printf ~20
	lw	$t8	-80	($sp)
	move	$a0	$t8
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf string7
	la	$a0	string7
	li	$v0	4
	syscall
########	push -10
	li	$a1	-10
########	push k
	lw	$a2	-16	($sp)
########	call gets2
	sw	$sp	-88	($sp)
	subi	$sp	$sp	80
	jal	gets2
	lw	$sp	-8	($sp)
########	~21 = retValue
	sw	$v0	-84	($sp)
########	printf ~21
	lw	$t8	-84	($sp)
	move	$a0	$t8
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf string8
	la	$a0	string8
	li	$v0	4
	syscall
########	push -10
	li	$a1	-10
########	push k
	lw	$a2	-16	($sp)
########	call gets1
	sw	$sp	-92	($sp)
	subi	$sp	$sp	84
	jal	gets1
	lw	$sp	-8	($sp)
########	~22 = retValue
	sw	$v0	-88	($sp)
########	printf ~22
	lw	$t8	-88	($sp)
	move	$a0	$t8
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	push -10
	li	$a1	-10
########	push k
	lw	$a2	-16	($sp)
########	call gets1
	sw	$sp	-96	($sp)
	subi	$sp	$sp	88
	jal	gets1
	lw	$sp	-8	($sp)
########	~23 = retValue
	sw	$v0	-92	($sp)
########	push -10
	li	$a1	-10
########	push k
	lw	$a2	-16	($sp)
########	call gets2
	sw	$sp	-100	($sp)
	subi	$sp	$sp	92
	jal	gets2
	lw	$sp	-8	($sp)
########	~24 = retValue
	sw	$v0	-96	($sp)
########	bne		~23		~24		if_0_end
	lw	$t8	-92	($sp)
	lw	$t9	-96	($sp)
	bne	$t8	$t9	if_0_end
########	push -10
	li	$a1	-10
########	push k
	lw	$a2	-16	($sp)
########	call gets1
	sw	$sp	-104	($sp)
	subi	$sp	$sp	96
	jal	gets1
	lw	$sp	-8	($sp)
########	~25 = retValue
	sw	$v0	-100	($sp)
########	push -10
	li	$a1	-10
########	push k
	lw	$a2	-16	($sp)
########	call gets3
	sw	$sp	-108	($sp)
	subi	$sp	$sp	100
	jal	gets3
	lw	$sp	-8	($sp)
########	~26 = retValue
	sw	$v0	-104	($sp)
########	bne		~25		~26		if_1_end
	lw	$t8	-100	($sp)
	lw	$t9	-104	($sp)
	bne	$t8	$t9	if_1_end
########	push -10
	li	$a1	-10
########	push k
	lw	$a2	-16	($sp)
########	call gets1
	sw	$sp	-112	($sp)
	subi	$sp	$sp	104
	jal	gets1
	lw	$sp	-8	($sp)
########	~27 = retValue
	sw	$v0	-108	($sp)
########	push -10
	li	$a1	-10
########	push k
	lw	$a2	-16	($sp)
########	call gets4
	sw	$sp	-116	($sp)
	subi	$sp	$sp	108
	jal	gets4
	lw	$sp	-8	($sp)
########	~28 = retValue
	sw	$v0	-112	($sp)
########	bne		~27		~28		if_2_end
	lw	$t8	-108	($sp)
	lw	$t9	-112	($sp)
	bne	$t8	$t9	if_2_end
########	printf string9
	la	$a0	string9
	li	$v0	4
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	j else_2_end
	j	else_2_end
########	Label if_2_end
if_2_end:
########	printf string10
	la	$a0	string10
	li	$v0	4
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	Label else_2_end
else_2_end:
########	j else_1_end
	j	else_1_end
########	Label if_1_end
if_1_end:
########	printf string11
	la	$a0	string11
	li	$v0	4
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	Label else_1_end
else_1_end:
########	j else_0_end
	j	else_0_end
########	Label if_0_end
if_0_end:
########	printf string12
	la	$a0	string12
	li	$v0	4
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	Label else_0_end
else_0_end:
########	func main -> NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	Label end
end:
