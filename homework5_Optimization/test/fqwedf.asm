.data
	string0:	.asciiz "take"
	string1:	.asciiz "from"
	string2:	.asciiz "to"
	string3:	.asciiz "!@\\n#$^&*()Qqaa123[];',./"
	string4:	.asciiz "!@\\n#$^&*()Qqaa123[];',./"
	string5:	.asciiz "!@\\n#$^&*()Qqaa123[];',./"
	string6:	.asciiz "INPUT of func_ret_int_1:"
	string7:	.asciiz "OPERATE of func_ret_int_1:"
	string8:	.asciiz "************************************************"
	string9:	.asciiz "Start testing recursion:"
	string10:	.asciiz "************************************************"
	string11:	.asciiz "Start testing global:"
	string12:	.asciiz "************************************************"
	string13:	.asciiz "Start testing return:"
	string14:	.asciiz "************************************************"
	string15:	.asciiz "Start testing I/O:"
	string16:	.asciiz "************************************************"
	string17:	.asciiz "Start testing assign & exp:"
	string18:	.asciiz "************************************************"
	string19:	.asciiz "Start testing if & while:"
	string20:	.asciiz "************************************************"
	string21:	.asciiz "Start testing parameter:"
	string22:	.asciiz "************************************************"
	newline:	.asciiz "\n"
.text
	jal	main
	j	end
							########	func hanoi()
hanoi:
	sw	$ra	-4	($sp)
							########	para in func: n
							########	para in func: from
							########	para in func: tmp
							########	para in func: to
							########	ble		n		0		if_0_end
	ble	$a1	0	if_0_end
							########	-		n		1		~0
	addi	$t0	$a1	-1
							########	protect env
	sw	$a2	-16	($sp)
	sw	$a1	-12	($sp)
	sw	$a3	-20	($sp)
							########	push ~0
	move	$a1	$t0
							########	push from
							########	push to
	move	$a3	$s3
							########	push tmp
	move	$s3	$a3
							########	call hanoi
	sw	$s3	-24	($sp)
	addi	$sp	$sp	-28
	jal	hanoi
	addi	$sp	$sp	28
	lw	$a2	-16	($sp)
	lw	$a1	-12	($sp)
	lw	$a3	-20	($sp)
	lw	$s3	-24	($sp)
							########	printf string0
	la	$a0	string0
	li	$v0	4
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf n
	move	$a0	$a1
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
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf from
	move	$a0	$a2
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf string2
	la	$a0	string2
	li	$v0	4
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf to
	move	$a0	$s3
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	-		n		1		~1
	addi	$t1	$a1	-1
							########	protect env
	sw	$a2	-16	($sp)
	sw	$a1	-12	($sp)
	sw	$a3	-20	($sp)
							########	push ~1
	move	$a1	$t1
							########	push tmp
	move	$a2	$a3
							########	push from
	move	$a3	$a2
							########	push to
							########	call hanoi
	sw	$s3	-24	($sp)
	addi	$sp	$sp	-32
	jal	hanoi
	addi	$sp	$sp	32
	lw	$a2	-16	($sp)
	lw	$a1	-12	($sp)
	lw	$a3	-20	($sp)
	lw	$s3	-24	($sp)
							########	Label if_0_end
if_0_end:
							########	func hanoi -> NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
							########	func hanoi -> NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
							########	func Fibonacci()
Fibonacci:
	sw	$ra	-4	($sp)
							########	para in func: n
							########	bne		n		0		if_1_end
	bne	$a1	0	if_1_end
							########	func Fibonacci -> Retreturn  retValue:0
	lw	$ra	-4	($sp)
	li	$v0	0
	jr	$ra
							########	Label if_1_end
if_1_end:
							########	bne		n		1		if_2_end
	bne	$a1	1	if_2_end
							########	func Fibonacci -> Retreturn  retValue:1
	lw	$ra	-4	($sp)
	li	$v0	1
	jr	$ra
							########	Label if_2_end
if_2_end:
							########	-		n		1		~2
	addi	$t2	$a1	-1
							########	protect env
	sw	$a1	-12	($sp)
							########	push ~2
	move	$a1	$t2
							########	call Fibonacci
	sw	$s5	-20	($sp)
	sw	$s3	-28	($sp)
	addi	$sp	$sp	-16
	jal	Fibonacci
	addi	$sp	$sp	16
	lw	$a1	-12	($sp)
	lw	$s5	-20	($sp)
	lw	$s3	-28	($sp)
							########	FunRet_~3 = retValue
	move	$s5	$v0
							########	-		n		2		~4
	addi	$t3	$a1	-2
							########	protect env
	sw	$a1	-12	($sp)
							########	push ~4
	move	$a1	$t3
							########	call Fibonacci
	sw	$s5	-20	($sp)
	sw	$s3	-28	($sp)
	addi	$sp	$sp	-24
	jal	Fibonacci
	addi	$sp	$sp	24
	lw	$a1	-12	($sp)
	lw	$s5	-20	($sp)
	lw	$s3	-28	($sp)
							########	FunRet_~5 = retValue
	move	$s3	$v0
							########	+		FunRet_~3		FunRet_~5		~6
	add	$t4	$s5	$s3
							########	func Fibonacci -> Retreturn  retValue:~6
	lw	$ra	-4	($sp)
	move	$v0	$t4
	jr	$ra
							########	func fac()
fac:
	sw	$ra	-4	($sp)
							########	para in func: n
							########	bne		n		1		if_3_end
	bne	$a1	1	if_3_end
							########	func fac -> Retreturn  retValue:1
	lw	$ra	-4	($sp)
	li	$v0	1
	jr	$ra
							########	Label if_3_end
if_3_end:
							########	-		n		1		~7
	addi	$t0	$a1	-1
							########	protect env
	sw	$a1	-12	($sp)
							########	push ~7
	move	$a1	$t0
							########	call fac
	sw	$s3	-20	($sp)
	addi	$sp	$sp	-16
	jal	fac
	addi	$sp	$sp	16
	lw	$a1	-12	($sp)
	lw	$s3	-20	($sp)
							########	FunRet_~8 = retValue
	move	$s3	$v0
							########	*		n		FunRet_~8		~9
	mult	$a1	$s3
	mflo	$t1
							########	func fac -> Retreturn  retValue:~9
	lw	$ra	-4	($sp)
	move	$v0	$t1
	jr	$ra
							########	func initGlobalArray()
initGlobalArray:
							########	[]=		0		0		global_int_array_1
	li	$t8	0
	li	$t9	0
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-20	($t9)
							########	[]=		1		1		global_int_array_1
	li	$t8	1
	li	$t9	1
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-20	($t9)
							########	=[]		global_int_array_1		0		~10
	li	$t8	0
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t2	-20	($t8)
							########	=[]		global_int_array_1		1		~11
	li	$t8	1
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t3	-20	($t8)
							########	+		~10		~11		~11
	add	$t3	$t2	$t3
							########	[]=		~11		2		global_int_array_1
	li	$t9	2
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t3	-20	($t9)
							########	=[]		global_int_array_1		2		~12
	li	$t8	2
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t4	-20	($t8)
							########	=[]		global_int_array_1		1		~13
	li	$t8	1
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t0	-20	($t8)
							########	+		~12		~13		~13
	add	$t0	$t4	$t0
							########	[]=		~13		3		global_int_array_1
	li	$t9	3
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t0	-20	($t9)
							########	=[]		global_int_array_1		3		~14
	li	$t8	3
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t1	-20	($t8)
							########	=[]		global_int_array_1		2		~15
	sw	$t2	-12	($sp)
	sw	$t2	-12	($sp)
	li	$t8	2
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t2	-20	($t8)
							########	+		~14		~15		~15
	add	$t2	$t1	$t2
							########	[]=		~15		4		global_int_array_1
	li	$t9	4
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t2	-20	($t9)
							########	=[]		global_int_array_1		1		~16
	sw	$t3	-16	($sp)
	sw	$t3	-16	($sp)
	sw	$t3	-16	($sp)
	sw	$t3	-16	($sp)
	li	$t8	1
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t3	-20	($t8)
							########	[]=		~16		0		global_int_array_2
	li	$t9	0
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t3	-72	($t9)
							########	=[]		global_int_array_2		0		~17
	sw	$t4	-20	($sp)
	sw	$t4	-20	($sp)
	li	$t8	0
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t4	-72	($t8)
							########	=[]		global_int_array_1		2		~18
	sw	$t0	-24	($sp)
	sw	$t0	-24	($sp)
	sw	$t0	-24	($sp)
	sw	$t0	-24	($sp)
	li	$t8	2
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t0	-20	($t8)
							########	*		~17		~18		~18
	mult	$t4	$t0
	mflo	$t0
							########	[]=		~18		1		global_int_array_2
	li	$t9	1
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t0	-72	($t9)
							########	=[]		global_int_array_2		1		~19
	sw	$t1	-28	($sp)
	sw	$t1	-28	($sp)
	li	$t8	1
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t1	-72	($t8)
							########	=[]		global_int_array_1		3		~20
	sw	$t2	-32	($sp)
	sw	$t2	-32	($sp)
	sw	$t2	-32	($sp)
	sw	$t2	-32	($sp)
	li	$t8	3
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t2	-20	($t8)
							########	*		~19		~20		~20
	mult	$t1	$t2
	mflo	$t2
							########	[]=		~20		2		global_int_array_2
	li	$t9	2
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t2	-72	($t9)
							########	=[]		global_int_array_2		2		~21
	sw	$t3	-36	($sp)
	sw	$t3	-36	($sp)
	li	$t8	2
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t3	-72	($t8)
							########	=[]		global_int_array_1		4		~22
	sw	$t4	-40	($sp)
	sw	$t4	-40	($sp)
	li	$t8	4
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t4	-20	($t8)
							########	*		~21		~22		~22
	mult	$t3	$t4
	mflo	$t4
							########	[]=		~22		3		global_int_array_2
	li	$t9	3
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t4	-72	($t9)
							########	=[]		global_int_array_2		3		~23
	sw	$t0	-44	($sp)
	sw	$t0	-44	($sp)
	sw	$t0	-44	($sp)
	sw	$t0	-44	($sp)
	li	$t8	3
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t0	-72	($t8)
							########	=[]		global_int_array_1		4		~24
	sw	$t1	-48	($sp)
	sw	$t1	-48	($sp)
	li	$t8	4
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t1	-20	($t8)
							########	/		~23		~24		~24
	div 	$t0	$t1
	mflo	$t1
							########	[]=		~24		4		global_int_array_2
	li	$t9	4
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t1	-72	($t9)
							########	[]=		'a'		0		global_char_array_1
	li	$t8	97
	li	$t9	0
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-44	($t9)
							########	[]=		'A'		1		global_char_array_1
	li	$t8	65
	li	$t9	1
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-44	($t9)
							########	[]=		'z'		2		global_char_array_1
	li	$t8	122
	li	$t9	2
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-44	($t9)
							########	[]=		'Z'		3		global_char_array_1
	li	$t8	90
	li	$t9	3
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-44	($t9)
							########	[]=		'_'		4		global_char_array_1
	li	$t8	95
	li	$t9	4
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-44	($t9)
							########	[]=		'+'		0		global_char_array_2
	li	$t8	43
	li	$t9	0
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-96	($t9)
							########	[]=		'-'		1		global_char_array_2
	li	$t8	45
	li	$t9	1
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-96	($t9)
							########	[]=		'*'		2		global_char_array_2
	li	$t8	42
	li	$t9	2
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-96	($t9)
							########	[]=		'/'		3		global_char_array_2
	li	$t8	47
	li	$t9	3
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-96	($t9)
							########	[]=		'6'		4		global_char_array_2
	li	$t8	54
	li	$t9	4
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-96	($t9)
							########	func initGlobalArray -> NonRetreturn

							########	func initGlobalArray -> NonRetreturn
	jr	$ra
							########	func assignGlobal()
assignGlobal:
							########	para in func: a
							########	para in func: b
							########	para in func: c
							########	para in func: d
							########	=		a		global_int_1
	sw	$a1	-24	($gp)
							########	=		b		global_char_1
	sw	$a2	-48	($gp)
							########	=		c		global_int_2
	sw	$a3	-52	($gp)
							########	=		d		global_char_2
	sw	$s3	-76	($gp)
							########	func assignGlobal -> NonRetreturn

							########	func assignGlobal -> NonRetreturn
	jr	$ra
							########	func printGlobalConst()
printGlobalConst:
							########	printf 12345679
	li	$a0	12345679
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf 0
	li	$a0	0
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf 0
	li	$a0	0
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf -12345679
	li	$a0	-12345679
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf '9'
	li	$a0	57
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf '_'
	li	$a0	95
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf '+'
	li	$a0	43
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf '*'
	li	$a0	42
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	func printGlobalConst -> NonRetreturn

							########	func printGlobalConst -> NonRetreturn
	jr	$ra
							########	func printGlobalVar()
printGlobalVar:
							########	printf global_int_1
	lw	$a0	-24	($gp)
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf global_int_2
	lw	$a0	-52	($gp)
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf global_char_1
	lw	$a0	-48	($gp)
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf global_char_2
	lw	$a0	-76	($gp)
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	func printGlobalVar -> NonRetreturn

							########	func printGlobalVar -> NonRetreturn
	jr	$ra
							########	func printGlobalArray()
printGlobalArray:
							########	=[]		global_int_array_1		0		~25
	sw	$t2	-52	($sp)
	sw	$t2	-52	($sp)
	sw	$t2	-52	($sp)
	sw	$t2	-52	($sp)
	li	$t8	0
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t2	-20	($t8)
							########	printf ~25
	move	$a0	$t2
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_int_array_1		1		~26
	sw	$t3	-56	($sp)
	sw	$t3	-56	($sp)
	li	$t8	1
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t3	-20	($t8)
							########	printf ~26
	move	$a0	$t3
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_int_array_1		2		~27
	sw	$t4	-60	($sp)
	sw	$t4	-60	($sp)
	sw	$t4	-60	($sp)
	sw	$t4	-60	($sp)
	li	$t8	2
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t4	-20	($t8)
							########	printf ~27
	move	$a0	$t4
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_int_array_1		3		~28
	sw	$t0	-64	($sp)
	sw	$t0	-64	($sp)
	li	$t8	3
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t0	-20	($t8)
							########	printf ~28
	move	$a0	$t0
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_int_array_1		4		~29
	sw	$t1	-68	($sp)
	sw	$t1	-68	($sp)
	sw	$t1	-68	($sp)
	sw	$t1	-68	($sp)
	li	$t8	4
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t1	-20	($t8)
							########	printf ~29
	move	$a0	$t1
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_int_array_2		0		~30
	sw	$t2	-12	($sp)
	sw	$t2	-12	($sp)
	li	$t8	0
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t2	-72	($t8)
							########	printf ~30
	move	$a0	$t2
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_int_array_2		1		~31
	sw	$t3	-16	($sp)
	sw	$t3	-16	($sp)
	li	$t8	1
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t3	-72	($t8)
							########	printf ~31
	move	$a0	$t3
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_int_array_2		2		~32
	sw	$t4	-20	($sp)
	sw	$t4	-20	($sp)
	li	$t8	2
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t4	-72	($t8)
							########	printf ~32
	move	$a0	$t4
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_int_array_2		3		~33
	sw	$t0	-24	($sp)
	sw	$t0	-24	($sp)
	li	$t8	3
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t0	-72	($t8)
							########	printf ~33
	move	$a0	$t0
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_int_array_2		4		~34
	sw	$t1	-28	($sp)
	sw	$t1	-28	($sp)
	li	$t8	4
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t1	-72	($t8)
							########	printf ~34
	move	$a0	$t1
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_char_array_1		0		~35
	sw	$t2	-32	($sp)
	sw	$t2	-32	($sp)
	li	$t8	0
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t2	-44	($t8)
							########	printf ~35
	move	$a0	$t2
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_char_array_1		1		~36
	sw	$t3	-36	($sp)
	sw	$t3	-36	($sp)
	li	$t8	1
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t3	-44	($t8)
							########	printf ~36
	move	$a0	$t3
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_char_array_1		2		~37
	sw	$t4	-40	($sp)
	sw	$t4	-40	($sp)
	li	$t8	2
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t4	-44	($t8)
							########	printf ~37
	move	$a0	$t4
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_char_array_1		3		~38
	sw	$t0	-44	($sp)
	sw	$t0	-44	($sp)
	li	$t8	3
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t0	-44	($t8)
							########	printf ~38
	move	$a0	$t0
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_char_array_1		4		~39
	sw	$t1	-48	($sp)
	sw	$t1	-48	($sp)
	li	$t8	4
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t1	-44	($t8)
							########	printf ~39
	move	$a0	$t1
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_char_array_2		0		~40
	sw	$t2	-52	($sp)
	sw	$t2	-52	($sp)
	li	$t8	0
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t2	-96	($t8)
							########	printf ~40
	move	$a0	$t2
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_char_array_2		1		~41
	sw	$t3	-56	($sp)
	sw	$t3	-56	($sp)
	li	$t8	1
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t3	-96	($t8)
							########	printf ~41
	move	$a0	$t3
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_char_array_2		2		~42
	sw	$t4	-60	($sp)
	sw	$t4	-60	($sp)
	li	$t8	2
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t4	-96	($t8)
							########	printf ~42
	move	$a0	$t4
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_char_array_2		3		~43
	sw	$t0	-64	($sp)
	sw	$t0	-64	($sp)
	li	$t8	3
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t0	-96	($t8)
							########	printf ~43
	move	$a0	$t0
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_char_array_2		4		~44
	sw	$t1	-68	($sp)
	sw	$t1	-68	($sp)
	li	$t8	4
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t1	-96	($t8)
							########	printf ~44
	move	$a0	$t1
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	func printGlobalArray -> NonRetreturn

							########	func printGlobalArray -> NonRetreturn
	jr	$ra
							########	func testGlobal()
testGlobal:
	sw	$ra	-4	($sp)
							########	call initGlobalArray
	addi	$sp	$sp	-8
							########	func initGlobalArray()
							########	[]=		0		0		global_int_array_1
	li	$t8	0
	li	$t9	0
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-20	($t9)
							########	[]=		1		1		global_int_array_1
	li	$t8	1
	li	$t9	1
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-20	($t9)
							########	=[]		global_int_array_1		0		~10
	li	$t8	0
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-20	($t8)
	sw	$t9	-12	($sp)
							########	=[]		global_int_array_1		1		~11
	li	$t8	1
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-20	($t8)
	sw	$t9	-16	($sp)
							########	+		~10		~11		~11
	lw	$t8	-12	($sp)
	lw	$t9	-16	($sp)
	add	$t8	$t8	$t9
	sw	$t8	-16	($sp)
							########	[]=		~11		2		global_int_array_1
	lw	$t8	-16	($sp)
	li	$t9	2
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-20	($t9)
							########	=[]		global_int_array_1		2		~12
	li	$t8	2
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-20	($t8)
	sw	$t9	-20	($sp)
							########	=[]		global_int_array_1		1		~13
	li	$t8	1
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-20	($t8)
	sw	$t9	-24	($sp)
							########	+		~12		~13		~13
	lw	$t8	-20	($sp)
	lw	$t9	-24	($sp)
	add	$t8	$t8	$t9
	sw	$t8	-24	($sp)
							########	[]=		~13		3		global_int_array_1
	lw	$t8	-24	($sp)
	li	$t9	3
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-20	($t9)
							########	=[]		global_int_array_1		3		~14
	li	$t8	3
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-20	($t8)
	sw	$t9	-28	($sp)
							########	=[]		global_int_array_1		2		~15
	li	$t8	2
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-20	($t8)
	sw	$t9	-32	($sp)
							########	+		~14		~15		~15
	lw	$t8	-28	($sp)
	lw	$t9	-32	($sp)
	add	$t8	$t8	$t9
	sw	$t8	-32	($sp)
							########	[]=		~15		4		global_int_array_1
	lw	$t8	-32	($sp)
	li	$t9	4
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-20	($t9)
							########	=[]		global_int_array_1		1		~16
	li	$t8	1
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-20	($t8)
	sw	$t9	-36	($sp)
							########	[]=		~16		0		global_int_array_2
	lw	$t8	-36	($sp)
	li	$t9	0
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-72	($t9)
							########	=[]		global_int_array_2		0		~17
	li	$t8	0
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-72	($t8)
	sw	$t9	-40	($sp)
							########	=[]		global_int_array_1		2		~18
	li	$t8	2
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-20	($t8)
	sw	$t9	-44	($sp)
							########	*		~17		~18		~18
	lw	$t8	-40	($sp)
	lw	$t9	-44	($sp)
	mult	$t8	$t9
	mflo	$t8
	sw	$t8	-44	($sp)
							########	[]=		~18		1		global_int_array_2
	lw	$t8	-44	($sp)
	li	$t9	1
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-72	($t9)
							########	=[]		global_int_array_2		1		~19
	li	$t8	1
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-72	($t8)
	sw	$t9	-48	($sp)
							########	=[]		global_int_array_1		3		~20
	li	$t8	3
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-20	($t8)
	sw	$t9	-52	($sp)
							########	*		~19		~20		~20
	lw	$t8	-48	($sp)
	lw	$t9	-52	($sp)
	mult	$t8	$t9
	mflo	$t8
	sw	$t8	-52	($sp)
							########	[]=		~20		2		global_int_array_2
	lw	$t8	-52	($sp)
	li	$t9	2
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-72	($t9)
							########	=[]		global_int_array_2		2		~21
	li	$t8	2
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-72	($t8)
	sw	$t9	-56	($sp)
							########	=[]		global_int_array_1		4		~22
	li	$t8	4
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-20	($t8)
	sw	$t9	-60	($sp)
							########	*		~21		~22		~22
	lw	$t8	-56	($sp)
	lw	$t9	-60	($sp)
	mult	$t8	$t9
	mflo	$t8
	sw	$t8	-60	($sp)
							########	[]=		~22		3		global_int_array_2
	lw	$t8	-60	($sp)
	li	$t9	3
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-72	($t9)
							########	=[]		global_int_array_2		3		~23
	li	$t8	3
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-72	($t8)
	sw	$t9	-64	($sp)
							########	=[]		global_int_array_1		4		~24
	li	$t8	4
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-20	($t8)
	sw	$t9	-68	($sp)
							########	/		~23		~24		~24
	lw	$t8	-64	($sp)
	lw	$t9	-68	($sp)
	div 	$t8	$t9
	mflo	$t8
	sw	$t8	-68	($sp)
							########	[]=		~24		4		global_int_array_2
	lw	$t8	-68	($sp)
	li	$t9	4
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-72	($t9)
							########	[]=		'a'		0		global_char_array_1
	li	$t8	97
	li	$t9	0
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-44	($t9)
							########	[]=		'A'		1		global_char_array_1
	li	$t8	65
	li	$t9	1
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-44	($t9)
							########	[]=		'z'		2		global_char_array_1
	li	$t8	122
	li	$t9	2
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-44	($t9)
							########	[]=		'Z'		3		global_char_array_1
	li	$t8	90
	li	$t9	3
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-44	($t9)
							########	[]=		'_'		4		global_char_array_1
	li	$t8	95
	li	$t9	4
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-44	($t9)
							########	[]=		'+'		0		global_char_array_2
	li	$t8	43
	li	$t9	0
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-96	($t9)
							########	[]=		'-'		1		global_char_array_2
	li	$t8	45
	li	$t9	1
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-96	($t9)
							########	[]=		'*'		2		global_char_array_2
	li	$t8	42
	li	$t9	2
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-96	($t9)
							########	[]=		'/'		3		global_char_array_2
	li	$t8	47
	li	$t9	3
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-96	($t9)
							########	[]=		'6'		4		global_char_array_2
	li	$t8	54
	li	$t9	4
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-96	($t9)
							########	func initGlobalArray -> NonRetreturn
	addi	$sp	$sp	8
							########	protect env
							########	push 12345679
	li	$a1	12345679
							########	push '9'
	li	$a2	57
							########	push -12345679
	li	$a3	-12345679
							########	push '*'
	li	$s3	42
							########	call assignGlobal
	addi	$sp	$sp	-8
							########	func assignGlobal()
							########	para in func: a
							########	para in func: b
							########	para in func: c
							########	para in func: d
							########	=		a		global_int_1
	sw	$a1	-24	($gp)
							########	=		b		global_char_1
	sw	$a2	-48	($gp)
							########	=		c		global_int_2
	sw	$a3	-52	($gp)
							########	=		d		global_char_2
	sw	$s3	-76	($gp)
							########	func assignGlobal -> NonRetreturn
	addi	$sp	$sp	8
							########	call printGlobalConst
	addi	$sp	$sp	-8
							########	func printGlobalConst()
							########	printf 12345679
	li	$a0	12345679
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf 0
	li	$a0	0
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf 0
	li	$a0	0
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf -12345679
	li	$a0	-12345679
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf '9'
	li	$a0	57
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf '_'
	li	$a0	95
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf '+'
	li	$a0	43
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf '*'
	li	$a0	42
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	func printGlobalConst -> NonRetreturn
	addi	$sp	$sp	8
							########	call printGlobalVar
	addi	$sp	$sp	-8
							########	func printGlobalVar()
							########	printf global_int_1
	lw	$a0	-24	($gp)
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf global_int_2
	lw	$a0	-52	($gp)
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf global_char_1
	lw	$a0	-48	($gp)
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf global_char_2
	lw	$a0	-76	($gp)
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	func printGlobalVar -> NonRetreturn
	addi	$sp	$sp	8
							########	call printGlobalArray
	addi	$sp	$sp	-8
							########	func printGlobalArray()
							########	=[]		global_int_array_1		0		~25
	li	$t8	0
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-20	($t8)
	sw	$t9	-12	($sp)
							########	printf ~25
	lw	$a0	-12	($sp)
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_int_array_1		1		~26
	li	$t8	1
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-20	($t8)
	sw	$t9	-16	($sp)
							########	printf ~26
	lw	$a0	-16	($sp)
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_int_array_1		2		~27
	li	$t8	2
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-20	($t8)
	sw	$t9	-20	($sp)
							########	printf ~27
	lw	$a0	-20	($sp)
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_int_array_1		3		~28
	li	$t8	3
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-20	($t8)
	sw	$t9	-24	($sp)
							########	printf ~28
	lw	$a0	-24	($sp)
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_int_array_1		4		~29
	li	$t8	4
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-20	($t8)
	sw	$t9	-28	($sp)
							########	printf ~29
	lw	$a0	-28	($sp)
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_int_array_2		0		~30
	li	$t8	0
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-72	($t8)
	sw	$t9	-32	($sp)
							########	printf ~30
	lw	$a0	-32	($sp)
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_int_array_2		1		~31
	li	$t8	1
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-72	($t8)
	sw	$t9	-36	($sp)
							########	printf ~31
	lw	$a0	-36	($sp)
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_int_array_2		2		~32
	li	$t8	2
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-72	($t8)
	sw	$t9	-40	($sp)
							########	printf ~32
	lw	$a0	-40	($sp)
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_int_array_2		3		~33
	li	$t8	3
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-72	($t8)
	sw	$t9	-44	($sp)
							########	printf ~33
	lw	$a0	-44	($sp)
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_int_array_2		4		~34
	li	$t8	4
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-72	($t8)
	sw	$t9	-48	($sp)
							########	printf ~34
	lw	$a0	-48	($sp)
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_char_array_1		0		~35
	li	$t8	0
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-44	($t8)
	sw	$t9	-52	($sp)
							########	printf ~35
	lw	$a0	-52	($sp)
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_char_array_1		1		~36
	li	$t8	1
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-44	($t8)
	sw	$t9	-56	($sp)
							########	printf ~36
	lw	$a0	-56	($sp)
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_char_array_1		2		~37
	li	$t8	2
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-44	($t8)
	sw	$t9	-60	($sp)
							########	printf ~37
	lw	$a0	-60	($sp)
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_char_array_1		3		~38
	li	$t8	3
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-44	($t8)
	sw	$t9	-64	($sp)
							########	printf ~38
	lw	$a0	-64	($sp)
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_char_array_1		4		~39
	li	$t8	4
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-44	($t8)
	sw	$t9	-68	($sp)
							########	printf ~39
	lw	$a0	-68	($sp)
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_char_array_2		0		~40
	li	$t8	0
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t2	-96	($t8)
							########	printf ~40
	move	$a0	$t2
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_char_array_2		1		~41
	li	$t8	1
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t3	-96	($t8)
							########	printf ~41
	move	$a0	$t3
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_char_array_2		2		~42
	li	$t8	2
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t4	-96	($t8)
							########	printf ~42
	move	$a0	$t4
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_char_array_2		3		~43
	li	$t8	3
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t0	-96	($t8)
							########	printf ~43
	move	$a0	$t0
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		global_char_array_2		4		~44
	li	$t8	4
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t1	-96	($t8)
							########	printf ~44
	move	$a0	$t1
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	func printGlobalArray -> NonRetreturn
	addi	$sp	$sp	8
							########	func testGlobal -> NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
							########	func testGlobal -> NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
							########	func testReturnInt()
testReturnInt:
							########	para in func: a
							########	+		a		1		~45
	addi	$t2	$a1	1
							########	func testReturnInt -> Retreturn  retValue:~45
	move	$v0	$t2
	addi	$sp	$sp	8
							########	func testReturnChar()
testReturnChar:
							########	para in func: a
							########	bne		a		1		if_4_end
	bne	$a1	1	if_4_end
							########	func testReturnChar -> Retreturn  retValue:'a'
	li	$v0	97
	jr	$ra
							########	j else_4_end
	j	else_4_end
							########	Label if_4_end
if_4_end:
							########	bne		a		2		if_5_end
	bne	$a1	2	if_5_end
							########	func testReturnChar -> Retreturn  retValue:'b'
	li	$v0	98
	jr	$ra
							########	j else_5_end
	j	else_5_end
							########	Label if_5_end
if_5_end:
							########	bne		a		3		if_6_end
	bne	$a1	3	if_6_end
							########	func testReturnChar -> Retreturn  retValue:'c'
	li	$v0	99
	jr	$ra
							########	Label if_6_end
if_6_end:
							########	Label else_5_end
else_5_end:
							########	Label else_4_end
else_4_end:
							########	func testReturnChar -> Retreturn  retValue:'_'
	li	$v0	95
	jr	$ra
							########	func testReturn()
testReturn:
	sw	$ra	-4	($sp)
							########	protect env
							########	push 3
	li	$a1	3
							########	call fac
	addi	$sp	$sp	-8
	jal	fac
	addi	$sp	$sp	8
							########	FunRet_~46 = retValue
	move	$s6	$v0
							########	protect env
							########	push 2
	li	$a1	2
							########	call fac
	addi	$sp	$sp	-12
	jal	fac
	addi	$sp	$sp	12
							########	FunRet_~47 = retValue
	move	$s3	$v0
							########	+		FunRet_~46		FunRet_~47		~48
	add	$t3	$s6	$s3
							########	protect env
							########	push ~48
	move	$a1	$t3
							########	call Fibonacci
	addi	$sp	$sp	-20
	jal	Fibonacci
	addi	$sp	$sp	20
							########	FunRet_~49 = retValue
	move	$s3	$v0
							########	protect env
							########	push FunRet_~49
	move	$a1	$s3
							########	call testReturnInt
	addi	$sp	$sp	-24
							########	func testReturnInt()
							########	para in func: a
							########	+		a		1		~45
	addi	$t2	$a1	1
							########	func testReturnInt -> Retreturn  retValue:~45
	move	$v0	$t2
	addi	$sp	$sp	24
							########	FunRet_~50 = retValue
	move	$s3	$v0
							########	printf FunRet_~50
	move	$a0	$s3
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	protect env
							########	push 1
	li	$a1	1
							########	call testReturnChar
	addi	$sp	$sp	-28
	jal	testReturnChar
	addi	$sp	$sp	28
							########	FunRet_~51 = retValue
	move	$s3	$v0
							########	printf FunRet_~51
	move	$a0	$s3
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	protect env
							########	push 2
	li	$a1	2
							########	call testReturnChar
	addi	$sp	$sp	-32
	jal	testReturnChar
	addi	$sp	$sp	32
							########	FunRet_~52 = retValue
	move	$s3	$v0
							########	printf FunRet_~52
	move	$a0	$s3
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	protect env
							########	push 3
	li	$a1	3
							########	call testReturnChar
	addi	$sp	$sp	-36
	jal	testReturnChar
	addi	$sp	$sp	36
							########	FunRet_~53 = retValue
	move	$s3	$v0
							########	printf FunRet_~53
	move	$a0	$s3
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	protect env
							########	push 4
	li	$a1	4
							########	call testReturnChar
	addi	$sp	$sp	-40
	jal	testReturnChar
	addi	$sp	$sp	40
							########	FunRet_~54 = retValue
	move	$s3	$v0
							########	printf FunRet_~54
	move	$a0	$s3
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	func testReturn -> NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
							########	func testReturn -> NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
							########	func testAssignAndExp()
testAssignAndExp:
	sw	$ra	-4	($sp)
							########	protect env
							########	push 5
	li	$a1	5
							########	call Fibonacci
	addi	$sp	$sp	-44
	jal	Fibonacci
	addi	$sp	$sp	44
							########	FunRet_~55 = retValue
	move	$s3	$v0
							########	protect env
							########	push FunRet_~55
	move	$a1	$s3
							########	call Fibonacci
	addi	$sp	$sp	-48
	jal	Fibonacci
	addi	$sp	$sp	48
							########	FunRet_~56 = retValue
	move	$s3	$v0
							########	protect env
							########	push FunRet_~56
	move	$a1	$s3
							########	call Fibonacci
	addi	$sp	$sp	-52
	jal	Fibonacci
	addi	$sp	$sp	52
							########	FunRet_~57 = retValue
	move	$s3	$v0
							########	+		FunRet_~57		0		~58
	addi	$t4	$s3	0
							########	protect env
							########	push 3
	li	$a1	3
							########	call fac
	addi	$sp	$sp	-60
	jal	fac
	addi	$sp	$sp	60
							########	FunRet_~59 = retValue
	move	$s3	$v0
							########	/		~58		FunRet_~59		~58
	div 	$t4	$s3
	mflo	$t4
							########	+		~58		1		int_temp_1
	addi	$v1	$t4	1
							########	protect env
							########	push 3
	li	$a1	3
							########	call fac
	addi	$sp	$sp	-64
	jal	fac
	addi	$sp	$sp	64
							########	FunRet_~60 = retValue
	move	$s7	$v0
							########	protect env
							########	push 2
	li	$a1	2
							########	call fac
	addi	$sp	$sp	-68
	jal	fac
	addi	$sp	$sp	68
							########	FunRet_~61 = retValue
	move	$s3	$v0
							########	+		FunRet_~60		FunRet_~61		~62
	add	$t0	$s7	$s3
							########	protect env
							########	push ~62
	move	$a1	$t0
							########	call fac
	addi	$sp	$sp	-76
	jal	fac
	addi	$sp	$sp	76
							########	FunRet_~63 = retValue
	move	$s3	$v0
							########	=		FunRet_~63		int_temp_2
	move	$fp	$s3
							########	protect env
							########	push 0
	li	$a1	0
							########	call testReturnInt
	addi	$sp	$sp	-80
							########	func testReturnInt()
							########	para in func: a
							########	+		a		1		~45
	addi	$t2	$a1	1
							########	func testReturnInt -> Retreturn  retValue:~45
	move	$v0	$t2
	addi	$sp	$sp	80
							########	FunRet_~64 = retValue
	move	$s3	$v0
							########	[]=		FunRet_~64		0		int_array
	li	$t9	0
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$s3	-24	($t9)
							########	protect env
							########	push 0
	li	$a1	0
							########	call testReturnInt
	addi	$sp	$sp	-84
							########	func testReturnInt()
							########	para in func: a
							########	+		a		1		~45
	addi	$t2	$a1	1
							########	func testReturnInt -> Retreturn  retValue:~45
	move	$v0	$t2
	addi	$sp	$sp	84
							########	FunRet_~65 = retValue
	move	$s3	$v0
							########	*		FunRet_~65		-12345679		~66
	li	$t9	-12345679
	mult	$s3	$t9
	mflo	$t1
							########	+		~66		12345679		~66
	addi	$t1	$t1	12345679
							########	-		1		~66		~66
	li	$t8	1
	sub	$t1	$t8	$t1
							########	protect env
							########	push 1
	li	$a1	1
							########	call testReturnInt
	addi	$sp	$sp	-92
							########	func testReturnInt()
							########	para in func: a
							########	+		a		1		~45
	addi	$t2	$a1	1
							########	func testReturnInt -> Retreturn  retValue:~45
	move	$v0	$t2
	addi	$sp	$sp	92
							########	FunRet_~67 = retValue
	move	$s3	$v0
							########	+		FunRet_~67		1		~68
	sw	$t2	-16	($sp)
	sw	$t2	-16	($sp)
	sw	$t2	-16	($sp)
	sw	$t2	-16	($sp)
	sw	$t2	-16	($sp)
	sw	$t2	-16	($sp)
	sw	$t2	-16	($sp)
	sw	$t2	-16	($sp)
	addi	$t2	$s3	1
							########	[]=		~68		~66		int_array
	sll	$t9	$t1	2
	add	$t9	$t9	$sp
	sw	$t2	-24	($t9)
							########	=[]		int_array		0		~69
	li	$t8	0
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t3	-24	($t8)
							########	protect env
							########	push 0
	li	$a1	0
							########	call testReturnInt
	addi	$sp	$sp	-104
							########	func testReturnInt()
							########	para in func: a
							########	+		a		1		~45
	addi	$t8	$a1	1
	sw	$t8	-16	($sp)
							########	func testReturnInt -> Retreturn  retValue:~45
	lw	$v0	-16	($sp)
	addi	$sp	$sp	104
							########	FunRet_~70 = retValue
	move	$s3	$v0
							########	*		FunRet_~70		-12345679		~71
	li	$t9	-12345679
	mult	$s3	$t9
	mflo	$t4
							########	+		~71		12345679		~71
	addi	$t4	$t4	12345679
							########	-		1		~71		~71
	li	$t8	1
	sub	$t4	$t8	$t4
							########	=[]		int_array		~71		~71
	sll	$t8	$t4	2
	add	$t8	$t8	$sp
	lw	$t4	-24	($t8)
							########	*		~71		1		~71
	li	$t9	1
	mult	$t4	$t9
	mflo	$t4
							########	-		~69		~71		int_temp_3
	sub	$t5	$t3	$t4
							########	=[]		int_array		0		~72
	li	$t8	0
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t0	-24	($t8)
							########	protect env
							########	push ~72
	move	$a1	$t0
							########	call testReturnChar
	addi	$sp	$sp	-116
	jal	testReturnChar
	addi	$sp	$sp	116
							########	FunRet_~73 = retValue
	move	$s3	$v0
							########	[]=		FunRet_~73		0		char_array
	li	$t9	0
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$s3	-40	($t9)
							########	protect env
							########	push 0
	li	$a1	0
							########	call testReturnInt
	addi	$sp	$sp	-120
							########	func testReturnInt()
							########	para in func: a
							########	+		a		1		~45
	addi	$t8	$a1	1
	sw	$t8	-16	($sp)
							########	func testReturnInt -> Retreturn  retValue:~45
	lw	$v0	-16	($sp)
	addi	$sp	$sp	120
							########	FunRet_~74 = retValue
	move	$s3	$v0
							########	*		FunRet_~74		-12345679		~75
	li	$t9	-12345679
	mult	$s3	$t9
	mflo	$t1
							########	+		~75		12345679		~75
	addi	$t1	$t1	12345679
							########	-		1		~75		~75
	li	$t8	1
	sub	$t1	$t8	$t1
							########	=[]		int_array		1		~76
	li	$t8	1
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t2	-24	($t8)
							########	+		~76		1		~76
	addi	$t2	$t2	1
							########	protect env
							########	push ~76
	move	$a1	$t2
							########	call testReturnChar
	addi	$sp	$sp	-132
	jal	testReturnChar
	addi	$sp	$sp	132
							########	FunRet_~77 = retValue
	move	$s3	$v0
							########	[]=		FunRet_~77		~75		char_array
	sll	$t9	$t1	2
	add	$t9	$t9	$sp
	sw	$s3	-40	($t9)
							########	=[]		char_array		0		~78
	li	$t8	0
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t3	-40	($t8)
							########	=		~78		char_temp_1
	move	$k0	$t3
							########	protect env
							########	push 0
	li	$a1	0
							########	call testReturnInt
	addi	$sp	$sp	-140
							########	func testReturnInt()
							########	para in func: a
							########	+		a		1		~45
	addi	$t8	$a1	1
	sw	$t8	-16	($sp)
							########	func testReturnInt -> Retreturn  retValue:~45
	lw	$v0	-16	($sp)
	addi	$sp	$sp	140
							########	FunRet_~79 = retValue
	move	$s3	$v0
							########	*		FunRet_~79		-12345679		~80
	li	$t9	-12345679
	mult	$s3	$t9
	mflo	$t4
							########	+		~80		12345679		~80
	addi	$t4	$t4	12345679
							########	-		1		~80		~80
	li	$t8	1
	sub	$t4	$t8	$t4
							########	=[]		char_array		~80		~80
	sll	$t8	$t4	2
	add	$t8	$t8	$sp
	lw	$t4	-40	($t8)
							########	=		~80		char_temp_2
	move	$k1	$t4
							########	printf int_temp_1
	move	$a0	$v1
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf int_temp_2
	move	$a0	$fp
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf int_temp_3
	move	$a0	$t5
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		int_array		0		~81
	li	$t8	0
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t0	-24	($t8)
							########	printf ~81
	move	$a0	$t0
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	protect env
							########	push 0
	li	$a1	0
							########	call testReturnInt
	addi	$sp	$sp	-152
							########	func testReturnInt()
							########	para in func: a
							########	+		a		1		~45
	addi	$t8	$a1	1
	sw	$t8	-16	($sp)
							########	func testReturnInt -> Retreturn  retValue:~45
	lw	$v0	-16	($sp)
	addi	$sp	$sp	152
							########	FunRet_~82 = retValue
	move	$s0	$v0
							########	*		FunRet_~82		-12345679		~83
	li	$t9	-12345679
	mult	$s0	$t9
	mflo	$t1
							########	+		~83		12345679		~83
	addi	$t1	$t1	12345679
							########	-		1		~83		~83
	li	$t8	1
	sub	$t1	$t8	$t1
							########	=[]		int_array		~83		~83
	sll	$t8	$t1	2
	add	$t8	$t8	$sp
	lw	$t1	-24	($t8)
							########	printf ~83
	move	$a0	$t1
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf char_temp_1
	move	$a0	$k0
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf char_temp_2
	move	$a0	$k1
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		char_array		0		~84
	li	$t8	0
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t2	-40	($t8)
							########	printf ~84
	move	$a0	$t2
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		char_array		1		~85
	li	$t8	1
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t3	-40	($t8)
							########	printf ~85
	move	$a0	$t3
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=[]		char_array		0		~86
	li	$t8	0
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t4	-40	($t8)
							########	=[]		char_array		0		~87
	li	$t8	0
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t0	-40	($t8)
							########	*		~87		char_temp_2		~87
	mult	$t0	$k1
	mflo	$t0
							########	+		~86		~87		~87
	add	$t0	$t4	$t0
							########	*		char_temp_1		~87		~87
	mult	$k0	$t0
	mflo	$t0
							########	printf ~87
	move	$a0	$t0
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	func testAssignAndExp -> NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
							########	func testAssignAndExp -> NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
							########	func testIO()
testIO:
							########	scanf global_int_1
	li	$v0	5
	syscall
	sw	$v0	-24	($gp)
							########	scanf global_char_1
	li	$v0	12
	syscall
	sw	$v0	-48	($gp)
							########	printf string3
	la	$a0	string3
	li	$v0	4
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf global_int_1
	lw	$a0	-24	($gp)
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf global_char_1
	lw	$a0	-48	($gp)
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	scanf global_int_1
	li	$v0	5
	syscall
	sw	$v0	-24	($gp)
							########	scanf global_char_1
	li	$v0	12
	syscall
	sw	$v0	-48	($gp)
							########	printf string4
	la	$a0	string4
	li	$v0	4
	syscall
							########	printf global_int_1
	lw	$a0	-24	($gp)
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf global_char_1
	lw	$a0	-48	($gp)
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	scanf global_char_1
	li	$v0	12
	syscall
	sw	$v0	-48	($gp)
							########	scanf global_int_1
	li	$v0	5
	syscall
	sw	$v0	-24	($gp)
							########	printf string5
	la	$a0	string5
	li	$v0	4
	syscall
							########	printf global_char_1
	lw	$a0	-48	($gp)
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf global_int_1
	lw	$a0	-24	($gp)
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	func testIO -> NonRetreturn
	addi	$sp	$sp	152
							########	func testIO -> NonRetreturn
	jr	$ra
							########	func testIfWhile()
testIfWhile:
							########	=		10		k
	li	$s0	10
							########	=		'+'		a
	li	$s1	43
							########	=		'-'		b
	li	$s2	45
							########	=		'*'		c
	li	$s3	42
							########	=		'/'		d
	li	$s4	47
							########	ble		k		0		if_7_end
	ble	$s0	0	if_7_end
							########	bgt		k		10		if_8_end
	bgt	$s0	10	if_8_end
							########	=		0		i
	li	$s5	0
							########	Label while_0_begin
while_0_begin:
							########	/		k		2		~88
	li	$t9	2
	div 	$s0	$t9
	mflo	$t1
							########	bge		i		~88		while_0_end
	bge	$s5	$t1	while_0_end
							########	%		i		2		~89
	li	$t9	2
	div 	$s5	$t9
	mfhi	$t2
							########	bne		~89		0		if_9_end
	bne	$t2	0	if_9_end
							########	[]=		a		i		global_char_array_3
	sll	$t9	$s5	2
	add	$t9	$t9	$gp
	sw	$s1	-136	($t9)
							########	j else_9_end
	j	else_9_end
							########	Label if_9_end
if_9_end:
							########	%		i		2		~90
	li	$t9	2
	div 	$s5	$t9
	mfhi	$t3
							########	bne		~90		1		if_10_end
	bne	$t3	1	if_10_end
							########	[]=		b		i		global_char_array_3
	sll	$t9	$s5	2
	add	$t9	$t9	$gp
	sw	$s2	-136	($t9)
							########	Label if_10_end
if_10_end:
							########	Label else_9_end
else_9_end:
							########	=[]		global_char_array_3		i		~91
	sll	$t8	$s5	2
	add	$t8	$t8	$gp
	lw	$t4	-136	($t8)
							########	printf ~91
	move	$a0	$t4
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	+		i		1		i
	addi	$s5	$s5	1
							########	j while_0_begin
	j	while_0_begin
							########	Label while_0_end
while_0_end:
							########	Label while_1_begin
while_1_begin:
							########	bge		i		k		while_1_end
	bge	$s5	$s0	while_1_end
							########	%		i		2		~93
	li	$t9	2
	div 	$s5	$t9
	mfhi	$t0
							########	bne		~93		0		if_11_end
	bne	$t0	0	if_11_end
							########	[]=		c		i		global_char_array_3
	sll	$t9	$s5	2
	add	$t9	$t9	$gp
	sw	$s3	-136	($t9)
							########	j else_11_end
	j	else_11_end
							########	Label if_11_end
if_11_end:
							########	[]=		d		i		global_char_array_3
	sll	$t9	$s5	2
	add	$t9	$t9	$gp
	sw	$s4	-136	($t9)
							########	Label else_11_end
else_11_end:
							########	=[]		global_char_array_3		i		~94
	sll	$t8	$s5	2
	add	$t8	$t8	$gp
	lw	$t1	-136	($t8)
							########	printf ~94
	move	$a0	$t1
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	+		i		1		i
	addi	$s5	$s5	1
							########	j while_1_begin
	j	while_1_begin
							########	Label while_1_end
while_1_end:
							########	Label if_8_end
if_8_end:
							########	Label if_7_end
if_7_end:
							########	func testIfWhile -> NonRetreturn
	jr	$ra
							########	func testIfWhile -> NonRetreturn
	jr	$ra
							########	func func_ret_int_1()
func_ret_int_1:
							########	para in func: i_1
							########	para in func: i_2
							########	para in func: c_1
							########	para in func: c_2
							########	printf string6
	la	$a0	string6
	li	$v0	4
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf i_1
	move	$a0	$a1
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf i_2
	move	$a0	$a2
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf c_1
	move	$a0	$a3
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf c_2
	move	$a0	$s1
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=		i_1		i_temp
	move	$s0	$a1
							########	=		i_2		i_1
	move	$a1	$a2
							########	=		i_temp		i_2
	move	$a2	$s0
							########	=		c_1		c_temp
	move	$s0	$a3
							########	=		c_2		c_1
	move	$a3	$s1
							########	=		c_temp		c_2
	move	$s1	$s0
							########	printf string7
	la	$a0	string7
	li	$v0	4
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf i_1
	move	$a0	$a1
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf i_2
	move	$a0	$a2
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf c_1
	move	$a0	$a3
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf c_2
	move	$a0	$s1
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	func func_ret_int_1 -> Retreturn  retValue:i_1
	move	$v0	$a1
	addi	$sp	$sp	152
							########	func testPara()
testPara:
	sw	$ra	-4	($sp)
							########	=		12345679		i
	li	$s3	12345679
							########	=		-12345679		j
	li	$s0	-12345679
							########	=		'A'		c
	li	$s1	65
							########	=		'Z'		d
	li	$s2	90
							########	protect env
							########	push i
	move	$a1	$s3
							########	push j
	move	$a2	$s0
							########	push c
	move	$a3	$s1
							########	push d
	move	$s1	$s2
							########	call func_ret_int_1
	addi	$sp	$sp	-24
							########	func func_ret_int_1()
							########	para in func: i_1
							########	para in func: i_2
							########	para in func: c_1
							########	para in func: c_2
							########	printf string6
	la	$a0	string6
	li	$v0	4
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf i_1
	move	$a0	$a1
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf i_2
	move	$a0	$a2
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf c_1
	move	$a0	$a3
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf c_2
	move	$a0	$s1
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	=		i_1		i_temp
	move	$s0	$a1
							########	=		i_2		i_1
	move	$a1	$a2
							########	=		i_temp		i_2
	move	$a2	$s0
							########	=		c_1		c_temp
	move	$s0	$a3
							########	=		c_2		c_1
	move	$a3	$s1
							########	=		c_temp		c_2
	move	$s1	$s0
							########	printf string7
	la	$a0	string7
	li	$v0	4
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf i_1
	move	$a0	$a1
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf i_2
	move	$a0	$a2
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf c_1
	move	$a0	$a3
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf c_2
	move	$a0	$s1
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	func func_ret_int_1 -> Retreturn  retValue:i_1
	move	$v0	$a1
	addi	$sp	$sp	24
							########	FunRet_~96 = retValue
	move	$s0	$v0
							########	printf FunRet_~96
	move	$a0	$s0
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	func testPara -> NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
							########	func testPara -> NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
							########	func testRecursion()
testRecursion:
	sw	$ra	-4	($sp)
							########	protect env
							########	push 2
	li	$a1	2
							########	call fac
	addi	$sp	$sp	-8
	jal	fac
	addi	$sp	$sp	8
							########	FunRet_~97 = retValue
	move	$s0	$v0
							########	protect env
							########	push 3
	li	$a1	3
							########	call fac
	addi	$sp	$sp	-12
	jal	fac
	addi	$sp	$sp	12
							########	FunRet_~98 = retValue
	move	$s3	$v0
							########	*		FunRet_~97		FunRet_~98		~99
	mult	$s0	$s3
	mflo	$t2
							########	protect env
							########	push ~99
	move	$a1	$t2
							########	call Fibonacci
	addi	$sp	$sp	-20
	jal	Fibonacci
	addi	$sp	$sp	20
							########	FunRet_~100 = retValue
	move	$s1	$v0
							########	protect env
							########	push 3
	li	$a1	3
							########	call Fibonacci
	addi	$sp	$sp	-24
	jal	Fibonacci
	addi	$sp	$sp	24
							########	FunRet_~101 = retValue
	move	$s2	$v0
							########	protect env
							########	push 4
	li	$a1	4
							########	call Fibonacci
	addi	$sp	$sp	-28
	jal	Fibonacci
	addi	$sp	$sp	28
							########	FunRet_~102 = retValue
	move	$s3	$v0
							########	+		FunRet_~101		FunRet_~102		~103
	add	$t3	$s2	$s3
							########	protect env
							########	push ~103
	move	$a1	$t3
							########	call fac
	addi	$sp	$sp	-36
	jal	fac
	addi	$sp	$sp	36
							########	FunRet_~104 = retValue
	move	$s3	$v0
							########	-		FunRet_~100		FunRet_~104		~105
	sub	$t4	$s1	$s3
							########	protect env
							########	push 2
	li	$a1	2
							########	call Fibonacci
	addi	$sp	$sp	-44
	jal	Fibonacci
	addi	$sp	$sp	44
							########	FunRet_~106 = retValue
	move	$s4	$v0
							########	protect env
							########	push 3
	li	$a1	3
							########	call Fibonacci
	addi	$sp	$sp	-48
	jal	Fibonacci
	addi	$sp	$sp	48
							########	FunRet_~107 = retValue
	move	$s3	$v0
							########	+		FunRet_~106		FunRet_~107		~108
	add	$t0	$s4	$s3
							########	protect env
							########	push ~108
	move	$a1	$t0
							########	call fac
	addi	$sp	$sp	-56
	jal	fac
	addi	$sp	$sp	56
							########	FunRet_~109 = retValue
	move	$s3	$v0
							########	/		~105		FunRet_~109		~105
	div 	$t4	$s3
	mflo	$t4
							########	protect env
							########	push ~105
	move	$a1	$t4
							########	push 'a'
	li	$a2	97
							########	push 'b'
	li	$a3	98
							########	push 'c'
	li	$s3	99
							########	call hanoi
	addi	$sp	$sp	-60
	jal	hanoi
	addi	$sp	$sp	60
							########	func testRecursion -> NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
							########	func testRecursion -> NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
							########	func main()
main:
	sw	$ra	-4	($sp)
							########	printf string8
	la	$a0	string8
	li	$v0	4
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf string9
	la	$a0	string9
	li	$v0	4
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	call testRecursion
	addi	$sp	$sp	-8
	jal	testRecursion
	addi	$sp	$sp	8
							########	printf string10
	la	$a0	string10
	li	$v0	4
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf string11
	la	$a0	string11
	li	$v0	4
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	call testGlobal
	addi	$sp	$sp	-8
	jal	testGlobal
	addi	$sp	$sp	8
							########	printf string12
	la	$a0	string12
	li	$v0	4
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf string13
	la	$a0	string13
	li	$v0	4
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	call testReturn
	addi	$sp	$sp	-8
	jal	testReturn
	addi	$sp	$sp	8
							########	printf string14
	la	$a0	string14
	li	$v0	4
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf string15
	la	$a0	string15
	li	$v0	4
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	call testIO
	addi	$sp	$sp	-8
							########	func testIO()
							########	scanf global_int_1
	li	$v0	5
	syscall
	sw	$v0	-24	($gp)
							########	scanf global_char_1
	li	$v0	12
	syscall
	sw	$v0	-48	($gp)
							########	printf string3
	la	$a0	string3
	li	$v0	4
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf global_int_1
	lw	$a0	-24	($gp)
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf global_char_1
	lw	$a0	-48	($gp)
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	scanf global_int_1
	li	$v0	5
	syscall
	sw	$v0	-24	($gp)
							########	scanf global_char_1
	li	$v0	12
	syscall
	sw	$v0	-48	($gp)
							########	printf string4
	la	$a0	string4
	li	$v0	4
	syscall
							########	printf global_int_1
	lw	$a0	-24	($gp)
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf global_char_1
	lw	$a0	-48	($gp)
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	scanf global_char_1
	li	$v0	12
	syscall
	sw	$v0	-48	($gp)
							########	scanf global_int_1
	li	$v0	5
	syscall
	sw	$v0	-24	($gp)
							########	printf string5
	la	$a0	string5
	li	$v0	4
	syscall
							########	printf global_char_1
	lw	$a0	-48	($gp)
	li	$v0	11
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf global_int_1
	lw	$a0	-24	($gp)
	li	$v0	1
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	func testIO -> NonRetreturn
	addi	$sp	$sp	8
							########	printf string16
	la	$a0	string16
	li	$v0	4
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf string17
	la	$a0	string17
	li	$v0	4
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	call testAssignAndExp
	addi	$sp	$sp	-8
	jal	testAssignAndExp
	addi	$sp	$sp	8
							########	printf string18
	la	$a0	string18
	li	$v0	4
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf string19
	la	$a0	string19
	li	$v0	4
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	call testIfWhile
	addi	$sp	$sp	-8
	jal	testIfWhile
	addi	$sp	$sp	8
							########	printf string20
	la	$a0	string20
	li	$v0	4
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	printf string21
	la	$a0	string21
	li	$v0	4
	syscall
							########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
							########	call testPara
	addi	$sp	$sp	-8
	jal	testPara
	addi	$sp	$sp	8
							########	printf string22
	la	$a0	string22
	li	$v0	4
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
