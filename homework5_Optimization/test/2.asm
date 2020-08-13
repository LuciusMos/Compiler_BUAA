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
							########	para in func: a
							########	=[]		g_list		0		~0
	li	$t8	0
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t0	-80	($t8)
							########	+		~0		1		~0
	addi	$t0	$t0	1
							########	[]=		~0		0		g_list
	li	$t9	0
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t0	-80	($t9)
							########	bge		a		0		if_0_end
	bge	$a1	0	if_0_end
							########	-		0		a		~1
	li	$t8	0
	sub	$t1	$t8	$a1
							########	+		~1		0		~1
	addi	$t1	$t1	0
							########	func abs -> Retreturn  retValue:~1
	move	$v0	$t1
	jr	$ra
							########	Label if_0_end
if_0_end:
							########	+		a		0		~2
	addi	$t2	$a1	0
							########	func abs -> Retreturn  retValue:~2
	move	$v0	$t2
	jr	$ra
							########	func init()
init:
							########	=		0		i
	li	$s0	0
							########	Label while_0_begin
while_0_begin:
							########	bge		i		10		while_0_end
	bge	$s0	10	while_0_end
							########	[]=		0		i		g_list
	li	$t8	0
	move	$t9	$s0
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-80	($t9)
							########	+		i		1		i
	addi	$s0	$s0	1
							########	j while_0_begin
	j	while_0_begin
							########	Label while_0_end
while_0_end:
	sw	$t0	-16	($sp)
							########	=[]		g_list		1		~4
	li	$t8	1
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t0	-80	($t8)
							########	+		~4		1		~4
	addi	$t0	$t0	1
							########	[]=		~4		1		g_list
	li	$t9	1
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t0	-80	($t9)
							########	func init -> NonRetreturn
	jr	$ra
							########	func show()
show:
							########	[]=		1		3		g_list
	li	$t8	1
	li	$t9	3
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-80	($t9)
							########	=		0		i
	li	$s1	0
							########	Label while_1_begin
while_1_begin:
							########	bge		i		4		while_1_end
	bge	$s1	4	while_1_end
	sw	$t1	-20	($sp)
							########	=[]		g_list		i		~5
	move	$t8	$s1
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t1	-80	($t8)
							########	printf ~5
	move	$a0	$t1
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	+		i		1		i
	addi	$s1	$s1	1
							########	j while_1_begin
	j	while_1_begin
							########	Label while_1_end
while_1_end:
							########	func show -> NonRetreturn
	jr	$ra
							########	func times()
times:
							########	para in func: a
							########	para in func: b
							########	[]=		1		2		g_list
	li	$t8	1
	li	$t9	2
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-80	($t9)
	sw	$t2	-24	($sp)
							########	*		a		b		~7
	mult	$a1	$a2
	mflo	$t2
							########	func times -> Retreturn  retValue:~7
	move	$v0	$t2
	jr	$ra
							########	func sum4()
sum4:
							########	para in func: a
							########	para in func: b
							########	para in func: c
							########	para in func: d
	sw	$t0	-16	($sp)
							########	=[]		g_list		3		~8
	li	$t8	3
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t0	-80	($t8)
							########	+		~8		1		~8
	addi	$t0	$t0	1
							########	[]=		~8		3		g_list
	li	$t9	3
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t0	-80	($t9)
	sw	$t1	-20	($sp)
							########	+		a		b		~9
	add	$t1	$a1	$a2
							########	+		~9		c		~9
	add	$t1	$t1	$a3
							########	+		~9		d		~9
	add	$t1	$t1	$s0
							########	func sum4 -> Retreturn  retValue:~9
	move	$v0	$t1
	jr	$ra
							########	func fi()
fi:
	sw	$ra	-4	($sp)
							########	para in func: i
							########	beq		i		0		if_1_end
	beq	$a1	0	if_1_end
	sw	$t2	-24	($sp)
							########	+		i		1		~10
	addi	$t2	$a1	1
							########	=[]		testnum		~10		~10
	move	$t8	$t2
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t2	-120	($t8)
	sw	$t0	-16	($sp)
							########	-		i		-2		~11
	addi	$t0	$a1	-2
							########	=[]		testnum		~11		~11
	move	$t8	$t0
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t0	-120	($t8)
							########	+		~10		~11		~10
	add	$t2	$t2	$t0
							########	[]=		~10		i		testnum
	move	$t9	$a1
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t2	-120	($t9)
	sw	$t1	-20	($sp)
							########	-		i		1		~12
	addi	$t1	$a1	-1
							########	protect env
	sw	$a1	-12	($sp)
							########	push ~12
	move	$a1	$t1
							########	call fi
	addi	$sp	$sp	-24
	jal	fi
	addi	$sp	$sp	24
	lw	$a1	-12	($sp)
							########	j else_1_end
	j	else_1_end
							########	Label if_1_end
if_1_end:
	sw	$t2	-16	($sp)
							########	+		i		1		~13
	addi	$t2	$a1	1
							########	=[]		testnum		~13		~13
	move	$t8	$t2
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t2	-120	($t8)
	sw	$t0	-16	($sp)
							########	-		i		-2		~14
	addi	$t0	$a1	-2
							########	=[]		testnum		~14		~14
	move	$t8	$t0
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t0	-120	($t8)
							########	+		~13		~14		~13
	add	$t2	$t2	$t0
							########	[]=		~13		i		testnum
	move	$t9	$a1
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t2	-120	($t9)
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
							########	scanf f
	li	$v0	12
	syscall
	move	$s2	$v0
							########	scanf a
	li	$v0	5
	syscall
	move	$s1	$v0
							########	call init
	addi	$sp	$sp	-24
	jal	init
	addi	$sp	$sp	24
							########	protect env
							########	push 2
	li	$a1	2
							########	push -2
	li	$a2	-2
							########	call times
	addi	$sp	$sp	-24
	jal	times
	addi	$sp	$sp	24
							########	FunRet_~15 = retValue
	move	$s0	$v0
							########	protect env
							########	push FunRet_~15
	move	$a1	$s0
							########	call abs
	addi	$sp	$sp	-28
	jal	abs
	addi	$sp	$sp	28
							########	FunRet_~16 = retValue
	move	$s3	$v0
							########	protect env
							########	push -1
	li	$a1	-1
							########	call abs
	addi	$sp	$sp	-32
	jal	abs
	addi	$sp	$sp	32
							########	FunRet_~17 = retValue
	move	$s4	$v0
							########	protect env
							########	push -3
	li	$a1	-3
							########	call abs
	addi	$sp	$sp	-36
	jal	abs
	addi	$sp	$sp	36
							########	FunRet_~18 = retValue
	move	$s5	$v0
							########	protect env
							########	push 22
	li	$a1	22
							########	call abs
	addi	$sp	$sp	-40
	jal	abs
	addi	$sp	$sp	40
							########	FunRet_~19 = retValue
	move	$s0	$v0
							########	protect env
							########	push FunRet_~16
	move	$a1	$s3
							########	push FunRet_~17
	move	$a2	$s4
							########	push FunRet_~18
	move	$a3	$s5
							########	push FunRet_~19
							########	call sum4
	addi	$sp	$sp	-44
	jal	sum4
	addi	$sp	$sp	44
							########	FunRet_~20 = retValue
	move	$s0	$v0
							########	printf FunRet_~20
	move	$a0	$s0
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
							########	protect env
							########	push 7
	li	$a1	7
							########	call fi
	addi	$sp	$sp	-48
	jal	fi
	addi	$sp	$sp	48
							########	printf string0
	la	$a0	string0
	li	$v0	4
	syscall
	sw	$t1	-20	($sp)
							########	=[]		testnum		8		~21
	li	$t8	8
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t1	-120	($t8)
							########	=[]		testnum		~21		~21
	move	$t8	$t1
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t1	-120	($t8)
							########	printf ~21
	move	$a0	$t1
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
	sw	$t2	-16	($sp)
							########	=[]		testnum		1		~22
	li	$t8	1
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t2	-120	($t8)
							########	printf ~22
	move	$a0	$t2
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
	sw	$t0	-16	($sp)
							########	=[]		testnum		5		~23
	li	$t8	5
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t0	-120	($t8)
							########	=[]		testnum		~23		~23
	move	$t8	$t0
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t0	-120	($t8)
	sw	$t1	-20	($sp)
							########	=[]		testnum		9		~24
	li	$t8	9
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t1	-120	($t8)
							########	+		~23		~24		~23
	add	$t0	$t0	$t1
							########	=[]		testnum		~23		~23
	move	$t8	$t0
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t0	-120	($t8)
							########	printf ~23
	move	$a0	$t0
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
	sw	$t2	-16	($sp)
							########	=[]		testnum		0		~25
	li	$t8	0
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t2	-120	($t8)
							########	printf ~25
	move	$a0	$t2
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=		0		theSum
	li	$s0	0
							########	ble		a		10		if_2_end
	ble	$s1	10	if_2_end
							########	=		0		i
	li	$s2	0
							########	Label dowhile_0_begin
dowhile_0_begin:
							########	+		theSum		i		theSum
	add	$s0	$s0	$s2
							########	+		i		1		i
	addi	$s2	$s2	1
							########	blt		i		a		dowhile_0_begin
	blt	$s2	$s1	dowhile_0_begin
							########	j else_2_end
	j	else_2_end
							########	Label if_2_end
if_2_end:
	sw	$t0	-16	($sp)
							########	+		f		0		~28
	addi	$t0	$s2	0
							########	bne		~28		43		if_3_end
	bne	$t0	43	if_3_end
							########	=		0		i
	li	$s2	0
							########	Label while_2_begin
while_2_begin:
	sw	$t1	-20	($sp)
							########	+		a		3		~29
	addi	$t1	$s1	3
							########	bge		i		~29		while_2_end
	bge	$s2	$t1	while_2_end
							########	+		theSum		i		theSum
	add	$s0	$s0	$s2
							########	+		i		3		i
	addi	$s2	$s2	3
							########	j while_2_begin
	j	while_2_begin
							########	Label while_2_end
while_2_end:
							########	j else_3_end
	j	else_3_end
							########	Label if_3_end
if_3_end:
							########	=		0		i
	li	$s2	0
							########	Label while_3_begin
while_3_begin:
	sw	$t2	-16	($sp)
							########	+		a		3		~32
	addi	$t2	$s1	3
							########	bge		i		~32		while_3_end
	bge	$s2	$t2	while_3_end
							########	-		theSum		i		theSum
	sub	$s0	$s0	$s2
							########	+		i		3		i
	addi	$s2	$s2	3
							########	j while_3_begin
	j	while_3_begin
							########	Label while_3_end
while_3_end:
							########	Label else_3_end
else_3_end:
							########	Label else_2_end
else_2_end:
							########	call show
	addi	$sp	$sp	-104
	jal	show
	addi	$sp	$sp	104
							########	printf theSum
	move	$a0	$s0
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
