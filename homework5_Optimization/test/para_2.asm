.data
	string0:	.asciiz "testnum[2] = "
	string1:	.asciiz "testnum[1] = "
	string2:	.asciiz "testnum[3] = "
	string3:	.asciiz "testnum[0] = "
	newline:	.asciiz "\n"
.text
	jal	main
	j	end
########	func abs()
abs:
########	=[]		g_list		0		~0
	li	$t8	0
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-80	($t8)
	sw	$t9	-16	($sp)
########	+		~0		1		~1
	lw	$t8	-16	($sp)
	li	$t9	1
	add	$t8	$t8	$t9
	sw	$t8	-20	($sp)
########	[]=		~1		0		g_list
	lw	$t8	-20	($sp)
	li	$t9	0
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-80	($t9)
########	bge		a		0		if_0_end
	li	$t9	0
	bge	$a1	$t9	if_0_end
########	-		0		a		~2
	li	$t8	0
	sub	$t8	$t8	$a1
	sw	$t8	-24	($sp)
########	+		~2		0		~3
	lw	$t8	-24	($sp)
	li	$t9	0
	add	$t8	$t8	$t9
	sw	$t8	-28	($sp)
########	func abs -> Retreturn  retValue:~3
	lw	$v0	-28	($sp)
	jr	$ra
########	Label if_0_end
if_0_end:
########	+		a		0		~4
	li	$t9	0
	add	$t8	$a1	$t9
	sw	$t8	-32	($sp)
########	func abs -> Retreturn  retValue:~4
	lw	$v0	-32	($sp)
	jr	$ra
########	func init()
init:
########	var int i
########	=		0		i
	li	$t8	0
	sw	$t8	-12	($sp)
########	Label while_0_begin
while_0_begin:
########	bge		i		10		while_0_end
	lw	$t8	-12	($sp)
	li	$t9	10
	bge	$t8	$t9	while_0_end
########	[]=		0		i		g_list
	li	$t8	0
	lw	$t9	-12	($sp)
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-80	($t9)
########	+		i		1		~5
	lw	$t8	-12	($sp)
	li	$t9	1
	add	$t8	$t8	$t9
	sw	$t8	-16	($sp)
########	=		~5		i
	lw	$t8	-16	($sp)
	sw	$t8	-12	($sp)
########	j while_0_begin
	j	while_0_begin
########	Label while_0_end
while_0_end:
########	=[]		g_list		1		~6
	li	$t8	1
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-80	($t8)
	sw	$t9	-20	($sp)
########	+		~6		1		~7
	lw	$t8	-20	($sp)
	li	$t9	1
	add	$t8	$t8	$t9
	sw	$t8	-24	($sp)
########	[]=		~7		1		g_list
	lw	$t8	-24	($sp)
	li	$t9	1
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-80	($t9)
########	func init -> NonRetreturn
	jr	$ra
########	func show()
show:
########	var int i
########	[]=		1		3		g_list
	li	$t8	1
	li	$t9	3
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-80	($t9)
########	=		0		i
	li	$t8	0
	sw	$t8	-12	($sp)
########	Label while_1_begin
while_1_begin:
########	bge		i		4		while_1_end
	lw	$t8	-12	($sp)
	li	$t9	4
	bge	$t8	$t9	while_1_end
########	=[]		g_list		i		~8
	lw	$t8	-12	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-80	($t8)
	sw	$t9	-16	($sp)
########	printf ~8
	lw	$t8	-16	($sp)
	move	$a0	$t8
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	+		i		1		~9
	lw	$t8	-12	($sp)
	li	$t9	1
	add	$t8	$t8	$t9
	sw	$t8	-20	($sp)
########	=		~9		i
	lw	$t8	-20	($sp)
	sw	$t8	-12	($sp)
########	j while_1_begin
	j	while_1_begin
########	Label while_1_end
while_1_end:
########	func show -> NonRetreturn
	jr	$ra
########	func times()
times:
########	[]=		1		2		g_list
	li	$t8	1
	li	$t9	2
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-80	($t9)
########	*		a		b		~10
	mult	$a1	$a2
	mflo	$t8
	sw	$t8	-20	($sp)
########	func times -> Retreturn  retValue:~10
	lw	$v0	-20	($sp)
	jr	$ra
########	func sum4()
sum4:
########	=[]		g_list		3		~11
	li	$t8	3
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-80	($t8)
	sw	$t9	-28	($sp)
########	+		1		~11		~12
	li	$t8	1
	lw	$t9	-28	($sp)
	add	$t8	$t8	$t9
	sw	$t8	-32	($sp)
########	[]=		~12		3		g_list
	lw	$t8	-32	($sp)
	li	$t9	3
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-80	($t9)
########	+		a		b		~13
	add	$t8	$a1	$a2
	sw	$t8	-36	($sp)
########	+		~13		c		~14
	lw	$t8	-36	($sp)
	add	$t8	$t8	$a3
	sw	$t8	-40	($sp)
########	+		~14		d		~15
	lw	$t8	-40	($sp)
	lw	$t9	-24	($sp)
	add	$t8	$t8	$t9
	sw	$t8	-44	($sp)
########	func sum4 -> Retreturn  retValue:~15
	lw	$v0	-44	($sp)
	jr	$ra
########	func fi()
fi:
	sw	$ra	-4	($sp)
########	beq		i		0		if_1_end
	li	$t9	0
	beq	$a1	$t9	if_1_end
########	+		i		1		~16
	li	$t9	1
	add	$t8	$a1	$t9
	sw	$t8	-16	($sp)
########	=[]		testnum		~16		~17
	lw	$t8	-16	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-120	($t8)
	sw	$t9	-20	($sp)
########	-		i		-2		~18
	li	$t9	-2
	sub	$t8	$a1	$t9
	sw	$t8	-24	($sp)
########	=[]		testnum		~18		~19
	lw	$t8	-24	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-120	($t8)
	sw	$t9	-28	($sp)
########	+		~17		~19		~20
	lw	$t8	-20	($sp)
	lw	$t9	-28	($sp)
	add	$t8	$t8	$t9
	sw	$t8	-32	($sp)
########	[]=		~20		i		testnum
	lw	$t8	-32	($sp)
	move	$t9	$a1
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-120	($t9)
########	-		i		1		~21
	li	$t9	1
	sub	$t8	$a1	$t9
	sw	$t8	-36	($sp)
########	push ~21
	lw	$a1	-36	($sp)
########	call fi
	sw	$a1	-12	($sp)
	sw	$sp	-44	($sp)
	subi	$sp	$sp	36
	jal	fi
	lw	$sp	-8	($sp)
	move	$a1	$a1
########	j else_1_end
	j	else_1_end
########	Label if_1_end
if_1_end:
########	+		i		1		~22
	li	$t9	1
	add	$t8	$a1	$t9
	sw	$t8	-40	($sp)
########	=[]		testnum		~22		~23
	lw	$t8	-40	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-120	($t8)
	sw	$t9	-44	($sp)
########	-		i		-2		~24
	li	$t9	-2
	sub	$t8	$a1	$t9
	sw	$t8	-48	($sp)
########	=[]		testnum		~24		~25
	lw	$t8	-48	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-120	($t8)
	sw	$t9	-52	($sp)
########	+		~23		~25		~26
	lw	$t8	-44	($sp)
	lw	$t9	-52	($sp)
	add	$t8	$t8	$t9
	sw	$t8	-56	($sp)
########	[]=		~26		i		testnum
	lw	$t8	-56	($sp)
	move	$t9	$a1
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-120	($t9)
########	func fi -> NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	Label else_1_end
else_1_end:
########	func fi -> NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	func main()
main:
	sw	$ra	-4	($sp)
########	var int a
########	scanf f
	li	$v0	12
	syscall
	sw	$v0	-24	($sp)
########	scanf a
	li	$v0	5
	syscall
	sw	$v0	-12	($sp)
########	call init
	sw	$sp	-32	($sp)
	subi	$sp	$sp	24
	jal	init
	lw	$sp	-8	($sp)
########	push 2
	li	$a1	2
########	push -2
	li	$a2	-2
########	call times
	sw	$sp	-32	($sp)
	subi	$sp	$sp	24
	jal	times
	lw	$sp	-8	($sp)
########	~27 = retValue
	sw	$v0	-28	($sp)
########	push ~27
	lw	$a1	-28	($sp)
########	call abs
	sw	$sp	-36	($sp)
	subi	$sp	$sp	28
	jal	abs
	lw	$sp	-8	($sp)
########	~28 = retValue
	sw	$v0	-32	($sp)
########	push -1
	li	$a1	-1
########	call abs
	sw	$sp	-40	($sp)
	subi	$sp	$sp	32
	jal	abs
	lw	$sp	-8	($sp)
########	~29 = retValue
	sw	$v0	-36	($sp)
########	push -3
	li	$a1	-3
########	call abs
	sw	$sp	-44	($sp)
	subi	$sp	$sp	36
	jal	abs
	lw	$sp	-8	($sp)
########	~30 = retValue
	sw	$v0	-40	($sp)
########	push 22
	li	$a1	22
########	call abs
	sw	$sp	-48	($sp)
	subi	$sp	$sp	40
	jal	abs
	lw	$sp	-8	($sp)
########	~31 = retValue
	sw	$v0	-44	($sp)
########	push ~28
	lw	$a1	-32	($sp)
########	push ~29
	lw	$a2	-36	($sp)
########	push ~30
	lw	$a3	-40	($sp)
########	push ~31
	lw	$t8	-44	($sp)
	sw	$t8	-68	($sp)
########	call sum4
	sw	$sp	-52	($sp)
	subi	$sp	$sp	44
	jal	sum4
	lw	$sp	-8	($sp)
########	~32 = retValue
	sw	$v0	-48	($sp)
########	printf ~32
	lw	$t8	-48	($sp)
	move	$a0	$t8
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	[]=		1		9		testnum
	li	$t8	1
	li	$t9	9
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-120	($t9)
########	[]=		2		8		testnum
	li	$t8	2
	li	$t9	8
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-120	($t9)
########	push 7
	li	$a1	7
########	call fi
	sw	$sp	-56	($sp)
	subi	$sp	$sp	48
	jal	fi
	lw	$sp	-8	($sp)
########	printf string0
	la	$a0	string0
	li	$v0	4
	syscall
########	=[]		testnum		8		~33
	li	$t8	8
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-120	($t8)
	sw	$t9	-52	($sp)
########	=[]		testnum		~33		~34
	lw	$t8	-52	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-120	($t8)
	sw	$t9	-56	($sp)
########	printf ~34
	lw	$t8	-56	($sp)
	move	$a0	$t8
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf string1
	la	$a0	string1
	li	$v0	4
	syscall
########	=[]		testnum		1		~35
	li	$t8	1
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-120	($t8)
	sw	$t9	-60	($sp)
########	printf ~35
	lw	$t8	-60	($sp)
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
########	=[]		testnum		5		~36
	li	$t8	5
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-120	($t8)
	sw	$t9	-64	($sp)
########	=[]		testnum		~36		~37
	lw	$t8	-64	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-120	($t8)
	sw	$t9	-68	($sp)
########	=[]		testnum		9		~38
	li	$t8	9
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-120	($t8)
	sw	$t9	-72	($sp)
########	+		~37		~38		~39
	lw	$t8	-68	($sp)
	lw	$t9	-72	($sp)
	add	$t8	$t8	$t9
	sw	$t8	-76	($sp)
########	=[]		testnum		~39		~40
	lw	$t8	-76	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-120	($t8)
	sw	$t9	-80	($sp)
########	printf ~40
	lw	$t8	-80	($sp)
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
########	=[]		testnum		0		~41
	li	$t8	0
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-120	($t8)
	sw	$t9	-84	($sp)
########	printf ~41
	lw	$t8	-84	($sp)
	move	$a0	$t8
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=		0		theSum
	li	$t8	0
	sw	$t8	-16	($sp)
########	ble		a		10		if_2_end
	lw	$t8	-12	($sp)
	li	$t9	10
	ble	$t8	$t9	if_2_end
########	=		0		i
	li	$t8	0
	sw	$t8	-20	($sp)
########	Label dowhile_0_begin
dowhile_0_begin:
########	+		theSum		i		~42
	lw	$t8	-16	($sp)
	lw	$t9	-20	($sp)
	add	$t8	$t8	$t9
	sw	$t8	-88	($sp)
########	=		~42		theSum
	lw	$t8	-88	($sp)
	sw	$t8	-16	($sp)
########	+		i		1		~43
	lw	$t8	-20	($sp)
	li	$t9	1
	add	$t8	$t8	$t9
	sw	$t8	-92	($sp)
########	=		~43		i
	lw	$t8	-92	($sp)
	sw	$t8	-20	($sp)
########	bge		i		a		dowhile_0_end
	lw	$t8	-20	($sp)
	lw	$t9	-12	($sp)
	bge	$t8	$t9	dowhile_0_end
########	j dowhile_0_begin
	j	dowhile_0_begin
########	Label dowhile_0_end
dowhile_0_end:
########	j else_2_end
	j	else_2_end
########	Label if_2_end
if_2_end:
########	+		f		0		~44
	lw	$t8	-24	($sp)
	li	$t9	0
	add	$t8	$t8	$t9
	sw	$t8	-96	($sp)
########	bne		~44		43		if_3_end
	lw	$t8	-96	($sp)
	li	$t9	43
	bne	$t8	$t9	if_3_end
########	=		0		i
	li	$t8	0
	sw	$t8	-20	($sp)
########	Label while_2_begin
while_2_begin:
########	+		a		3		~45
	lw	$t8	-12	($sp)
	li	$t9	3
	add	$t8	$t8	$t9
	sw	$t8	-100	($sp)
########	bge		i		~45		while_2_end
	lw	$t8	-20	($sp)
	lw	$t9	-100	($sp)
	bge	$t8	$t9	while_2_end
########	+		theSum		i		~46
	lw	$t8	-16	($sp)
	lw	$t9	-20	($sp)
	add	$t8	$t8	$t9
	sw	$t8	-104	($sp)
########	=		~46		theSum
	lw	$t8	-104	($sp)
	sw	$t8	-16	($sp)
########	+		i		3		~47
	lw	$t8	-20	($sp)
	li	$t9	3
	add	$t8	$t8	$t9
	sw	$t8	-108	($sp)
########	=		~47		i
	lw	$t8	-108	($sp)
	sw	$t8	-20	($sp)
########	j while_2_begin
	j	while_2_begin
########	Label while_2_end
while_2_end:
########	j else_3_end
	j	else_3_end
########	Label if_3_end
if_3_end:
########	=		0		i
	li	$t8	0
	sw	$t8	-20	($sp)
########	Label while_3_begin
while_3_begin:
########	+		a		3		~48
	lw	$t8	-12	($sp)
	li	$t9	3
	add	$t8	$t8	$t9
	sw	$t8	-112	($sp)
########	bge		i		~48		while_3_end
	lw	$t8	-20	($sp)
	lw	$t9	-112	($sp)
	bge	$t8	$t9	while_3_end
########	-		theSum		i		~49
	lw	$t8	-16	($sp)
	lw	$t9	-20	($sp)
	sub	$t8	$t8	$t9
	sw	$t8	-116	($sp)
########	=		~49		theSum
	lw	$t8	-116	($sp)
	sw	$t8	-16	($sp)
########	+		i		3		~50
	lw	$t8	-20	($sp)
	li	$t9	3
	add	$t8	$t8	$t9
	sw	$t8	-120	($sp)
########	=		~50		i
	lw	$t8	-120	($sp)
	sw	$t8	-20	($sp)
########	j while_3_begin
	j	while_3_begin
########	Label while_3_end
while_3_end:
########	Label else_3_end
else_3_end:
########	Label else_2_end
else_2_end:
########	call show
	sw	$sp	-128	($sp)
	subi	$sp	$sp	120
	jal	show
	lw	$sp	-8	($sp)
########	printf theSum
	lw	$t8	-16	($sp)
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
