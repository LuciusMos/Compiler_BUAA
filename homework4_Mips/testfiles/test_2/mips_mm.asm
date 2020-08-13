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
	string21:	.asciiz "Start testing switch:"
	string22:	.asciiz "************************************************"
	string23:	.asciiz "Start testing parameter:"
	string24:	.asciiz "************************************************"
	newline:	.asciiz "\n"
.text
	jal	main
	j	end
########	const int const_int_1 = 12345679
########	const int const_int_2 = 0
########	const int const_int_3 = 0
########	const int const_int_4 = -12345679
########	const char const_char_1 = '9'
########	const char const_char_2 = '_'
########	const char const_char_3 = '+'
########	const char const_char_4 = '*'
########	var int global_int_array_1
########	func void hanoi()
hanoi:
	sw	$ra	-4	($sp)
########	ble		n		0		if_0_end
	lw	$t0	-12	($sp)
	li	$t1	0
	ble	$t0	$t1	if_0_end
########	-		n		1		~0
	lw	$t0	-12	($sp)
	li	$t1	1
	sub	$t2	$t0	$t1
	sw	$t2	-28	($sp)
########	push ~0
	lw	$t0	-28	($sp)
	sw	$t0	-40	($sp)
########	push from
	lw	$t0	-16	($sp)
	sw	$t0	-44	($sp)
########	push to
	lw	$t0	-24	($sp)
	sw	$t0	-48	($sp)
########	push tmp
	lw	$t0	-20	($sp)
	sw	$t0	-52	($sp)
########	call hanoi
	sw	$sp	-36	($sp)
	subi	$sp	$sp	28
	jal	hanoi
	lw	$sp	-8	($sp)
########	printf string0
	la	$a0	string0
	li	$v0	4
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf n
	lw	$t0	-12	($sp)
	move	$a0	$t0
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
	lw	$t0	-16	($sp)
	move	$a0	$t0
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
	lw	$t0	-24	($sp)
	move	$a0	$t0
	li	$v0	11
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	-		n		1		~1
	lw	$t0	-12	($sp)
	li	$t1	1
	sub	$t2	$t0	$t1
	sw	$t2	-32	($sp)
########	push ~1
	lw	$t0	-32	($sp)
	sw	$t0	-44	($sp)
########	push tmp
	lw	$t0	-20	($sp)
	sw	$t0	-48	($sp)
########	push from
	lw	$t0	-16	($sp)
	sw	$t0	-52	($sp)
########	push to
	lw	$t0	-24	($sp)
	sw	$t0	-56	($sp)
########	call hanoi
	sw	$sp	-40	($sp)
	subi	$sp	$sp	32
	jal	hanoi
	lw	$sp	-8	($sp)
########	Label if_0_end
if_0_end:
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	func int Fibonacci()
Fibonacci:
	sw	$ra	-4	($sp)
########	bne		n		0		if_1_end
	lw	$t0	-12	($sp)
	li	$t1	0
	bne	$t0	$t1	if_1_end
########	Retreturn  retValue:0
	lw	$ra	-4	($sp)
	li	$v0	0
	jr	$ra
########	Label if_1_end
if_1_end:
########	bne		n		1		if_2_end
	lw	$t0	-12	($sp)
	li	$t1	1
	bne	$t0	$t1	if_2_end
########	Retreturn  retValue:1
	lw	$ra	-4	($sp)
	li	$v0	1
	jr	$ra
########	Label if_2_end
if_2_end:
########	-		n		1		~2
	lw	$t0	-12	($sp)
	li	$t1	1
	sub	$t2	$t0	$t1
	sw	$t2	-16	($sp)
########	push ~2
	lw	$t0	-16	($sp)
	sw	$t0	-28	($sp)
########	call Fibonacci
	sw	$sp	-24	($sp)
	subi	$sp	$sp	16
	jal	Fibonacci
	lw	$sp	-8	($sp)
########	~3 = retValue
	sw	$v0	-20	($sp)
########	-		n		2		~4
	lw	$t0	-12	($sp)
	li	$t1	2
	sub	$t2	$t0	$t1
	sw	$t2	-24	($sp)
########	push ~4
	lw	$t0	-24	($sp)
	sw	$t0	-36	($sp)
########	call Fibonacci
	sw	$sp	-32	($sp)
	subi	$sp	$sp	24
	jal	Fibonacci
	lw	$sp	-8	($sp)
########	~5 = retValue
	sw	$v0	-28	($sp)
########	+		~3		~5		~3
	lw	$t0	-20	($sp)
	lw	$t1	-28	($sp)
	add	$t2	$t0	$t1
	sw	$t2	-20	($sp)
########	Retreturn  retValue:~3
	lw	$ra	-4	($sp)
	lw	$v0	-20	($sp)
	jr	$ra
########	func int fac()
fac:
	sw	$ra	-4	($sp)
########	bne		n		1		if_3_end
	lw	$t0	-12	($sp)
	li	$t1	1
	bne	$t0	$t1	if_3_end
########	Retreturn  retValue:1
	lw	$ra	-4	($sp)
	li	$v0	1
	jr	$ra
########	Label if_3_end
if_3_end:
########	-		n		1		~6
	lw	$t0	-12	($sp)
	li	$t1	1
	sub	$t2	$t0	$t1
	sw	$t2	-16	($sp)
########	push ~6
	lw	$t0	-16	($sp)
	sw	$t0	-28	($sp)
########	call fac
	sw	$sp	-24	($sp)
	subi	$sp	$sp	16
	jal	fac
	lw	$sp	-8	($sp)
########	~7 = retValue
	sw	$v0	-20	($sp)
########	*		n		~7		~7
	lw	$t0	-12	($sp)
	lw	$t1	-20	($sp)
	mult	$t0	$t1
	mflo	$t2
	sw	$t2	-20	($sp)
########	Retreturn  retValue:~7
	lw	$ra	-4	($sp)
	lw	$v0	-20	($sp)
	jr	$ra
########	func void initGlobalArray()
initGlobalArray:
	sw	$ra	-4	($sp)
########	[]=		0		0		global_int_array_1
	li	$t0	0
	li	$t1	0
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-20	($t1)
########	[]=		1		1		global_int_array_1
	li	$t0	1
	li	$t1	1
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-20	($t1)
########	=[]		global_int_array_1		0		~8
	li	$t0	0
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-20	($t0)
	sw	$t1	-12	($sp)
########	=[]		global_int_array_1		1		~9
	li	$t0	1
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-20	($t0)
	sw	$t1	-16	($sp)
########	+		~8		~9		~8
	lw	$t0	-12	($sp)
	lw	$t1	-16	($sp)
	add	$t2	$t0	$t1
	sw	$t2	-12	($sp)
########	[]=		~8		2		global_int_array_1
	lw	$t0	-12	($sp)
	li	$t1	2
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-20	($t1)
########	=[]		global_int_array_1		2		~10
	li	$t0	2
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-20	($t0)
	sw	$t1	-20	($sp)
########	=[]		global_int_array_1		1		~11
	li	$t0	1
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-20	($t0)
	sw	$t1	-24	($sp)
########	+		~10		~11		~10
	lw	$t0	-20	($sp)
	lw	$t1	-24	($sp)
	add	$t2	$t0	$t1
	sw	$t2	-20	($sp)
########	[]=		~10		3		global_int_array_1
	lw	$t0	-20	($sp)
	li	$t1	3
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-20	($t1)
########	=[]		global_int_array_1		3		~12
	li	$t0	3
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-20	($t0)
	sw	$t1	-28	($sp)
########	=[]		global_int_array_1		2		~13
	li	$t0	2
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-20	($t0)
	sw	$t1	-32	($sp)
########	+		~12		~13		~12
	lw	$t0	-28	($sp)
	lw	$t1	-32	($sp)
	add	$t2	$t0	$t1
	sw	$t2	-28	($sp)
########	[]=		~12		4		global_int_array_1
	lw	$t0	-28	($sp)
	li	$t1	4
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-20	($t1)
########	=[]		global_int_array_1		1		~14
	li	$t0	1
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-20	($t0)
	sw	$t1	-36	($sp)
########	[]=		~14		0		global_int_array_2
	lw	$t0	-36	($sp)
	li	$t1	0
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-72	($t1)
########	=[]		global_int_array_2		0		~15
	li	$t0	0
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-72	($t0)
	sw	$t1	-40	($sp)
########	=[]		global_int_array_1		2		~16
	li	$t0	2
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-20	($t0)
	sw	$t1	-44	($sp)
########	*		~15		~16		~15
	lw	$t0	-40	($sp)
	lw	$t1	-44	($sp)
	mult	$t0	$t1
	mflo	$t2
	sw	$t2	-40	($sp)
########	[]=		~15		1		global_int_array_2
	lw	$t0	-40	($sp)
	li	$t1	1
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-72	($t1)
########	=[]		global_int_array_2		1		~17
	li	$t0	1
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-72	($t0)
	sw	$t1	-48	($sp)
########	=[]		global_int_array_1		3		~18
	li	$t0	3
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-20	($t0)
	sw	$t1	-52	($sp)
########	*		~17		~18		~17
	lw	$t0	-48	($sp)
	lw	$t1	-52	($sp)
	mult	$t0	$t1
	mflo	$t2
	sw	$t2	-48	($sp)
########	[]=		~17		2		global_int_array_2
	lw	$t0	-48	($sp)
	li	$t1	2
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-72	($t1)
########	=[]		global_int_array_2		2		~19
	li	$t0	2
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-72	($t0)
	sw	$t1	-56	($sp)
########	=[]		global_int_array_1		4		~20
	li	$t0	4
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-20	($t0)
	sw	$t1	-60	($sp)
########	*		~19		~20		~19
	lw	$t0	-56	($sp)
	lw	$t1	-60	($sp)
	mult	$t0	$t1
	mflo	$t2
	sw	$t2	-56	($sp)
########	[]=		~19		3		global_int_array_2
	lw	$t0	-56	($sp)
	li	$t1	3
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-72	($t1)
########	=[]		global_int_array_2		3		~21
	li	$t0	3
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-72	($t0)
	sw	$t1	-64	($sp)
########	=[]		global_int_array_1		4		~22
	li	$t0	4
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-20	($t0)
	sw	$t1	-68	($sp)
########	/		~21		~22		~21
	lw	$t0	-64	($sp)
	lw	$t1	-68	($sp)
	div	$t0	$t1
	mflo	$t2
	sw	$t2	-64	($sp)
########	[]=		~21		4		global_int_array_2
	lw	$t0	-64	($sp)
	li	$t1	4
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-72	($t1)
########	[]=		'a'		0		global_char_array_1
	li	$t0	97
	li	$t1	0
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-44	($t1)
########	[]=		'A'		1		global_char_array_1
	li	$t0	65
	li	$t1	1
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-44	($t1)
########	[]=		'z'		2		global_char_array_1
	li	$t0	122
	li	$t1	2
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-44	($t1)
########	[]=		'Z'		3		global_char_array_1
	li	$t0	90
	li	$t1	3
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-44	($t1)
########	[]=		'_'		4		global_char_array_1
	li	$t0	95
	li	$t1	4
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-44	($t1)
########	[]=		'+'		0		global_char_array_2
	li	$t0	43
	li	$t1	0
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-96	($t1)
########	[]=		'-'		1		global_char_array_2
	li	$t0	45
	li	$t1	1
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-96	($t1)
########	[]=		'*'		2		global_char_array_2
	li	$t0	42
	li	$t1	2
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-96	($t1)
########	[]=		'/'		3		global_char_array_2
	li	$t0	47
	li	$t1	3
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-96	($t1)
########	[]=		'6'		4		global_char_array_2
	li	$t0	54
	li	$t1	4
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-96	($t1)
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	func void assignGlobal()
assignGlobal:
	sw	$ra	-4	($sp)
########	=		a		global_int_1
	lw	$t0	-12	($sp)
	sw	$t0	-24	($gp)
########	=		b		global_char_1
	lw	$t0	-16	($sp)
	sw	$t0	-48	($gp)
########	=		c		global_int_2
	lw	$t0	-20	($sp)
	sw	$t0	-52	($gp)
########	=		d		global_char_2
	lw	$t0	-24	($sp)
	sw	$t0	-76	($gp)
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	func void printGlobalConst()
printGlobalConst:
	sw	$ra	-4	($sp)
########	printf 12345679
	li	$t0	12345679
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf 0
	li	$t0	0
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf 0
	li	$t0	0
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf -12345679
	li	$t0	-12345679
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf '9'
	li	$t0	57
	move	$a0	$t0
	li	$v0	11
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf '_'
	li	$t0	95
	move	$a0	$t0
	li	$v0	11
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf '+'
	li	$t0	43
	move	$a0	$t0
	li	$v0	11
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf '*'
	li	$t0	42
	move	$a0	$t0
	li	$v0	11
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	func void printGlobalVar()
printGlobalVar:
	sw	$ra	-4	($sp)
########	printf global_int_1
	lw	$t0	-24	($gp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf global_int_2
	lw	$t0	-52	($gp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf global_char_1
	lw	$t0	-48	($gp)
	move	$a0	$t0
	li	$v0	11
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf global_char_2
	lw	$t0	-76	($gp)
	move	$a0	$t0
	li	$v0	11
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	func void printGlobalArray()
printGlobalArray:
	sw	$ra	-4	($sp)
########	=[]		global_int_array_1		0		~23
	li	$t0	0
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-20	($t0)
	sw	$t1	-12	($sp)
########	printf ~23
	lw	$t0	-12	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=[]		global_int_array_1		1		~24
	li	$t0	1
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-20	($t0)
	sw	$t1	-16	($sp)
########	printf ~24
	lw	$t0	-16	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=[]		global_int_array_1		2		~25
	li	$t0	2
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-20	($t0)
	sw	$t1	-20	($sp)
########	printf ~25
	lw	$t0	-20	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=[]		global_int_array_1		3		~26
	li	$t0	3
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-20	($t0)
	sw	$t1	-24	($sp)
########	printf ~26
	lw	$t0	-24	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=[]		global_int_array_1		4		~27
	li	$t0	4
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-20	($t0)
	sw	$t1	-28	($sp)
########	printf ~27
	lw	$t0	-28	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=[]		global_int_array_2		0		~28
	li	$t0	0
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-72	($t0)
	sw	$t1	-32	($sp)
########	printf ~28
	lw	$t0	-32	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=[]		global_int_array_2		1		~29
	li	$t0	1
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-72	($t0)
	sw	$t1	-36	($sp)
########	printf ~29
	lw	$t0	-36	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=[]		global_int_array_2		2		~30
	li	$t0	2
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-72	($t0)
	sw	$t1	-40	($sp)
########	printf ~30
	lw	$t0	-40	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=[]		global_int_array_2		3		~31
	li	$t0	3
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-72	($t0)
	sw	$t1	-44	($sp)
########	printf ~31
	lw	$t0	-44	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=[]		global_int_array_2		4		~32
	li	$t0	4
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-72	($t0)
	sw	$t1	-48	($sp)
########	printf ~32
	lw	$t0	-48	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=[]		global_char_array_1		0		~33
	li	$t0	0
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-44	($t0)
	sw	$t1	-52	($sp)
########	printf ~33
	lw	$t0	-52	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=[]		global_char_array_1		1		~34
	li	$t0	1
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-44	($t0)
	sw	$t1	-56	($sp)
########	printf ~34
	lw	$t0	-56	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=[]		global_char_array_1		2		~35
	li	$t0	2
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-44	($t0)
	sw	$t1	-60	($sp)
########	printf ~35
	lw	$t0	-60	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=[]		global_char_array_1		3		~36
	li	$t0	3
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-44	($t0)
	sw	$t1	-64	($sp)
########	printf ~36
	lw	$t0	-64	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=[]		global_char_array_1		4		~37
	li	$t0	4
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-44	($t0)
	sw	$t1	-68	($sp)
########	printf ~37
	lw	$t0	-68	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=[]		global_char_array_2		0		~38
	li	$t0	0
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-96	($t0)
	sw	$t1	-72	($sp)
########	printf ~38
	lw	$t0	-72	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=[]		global_char_array_2		1		~39
	li	$t0	1
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-96	($t0)
	sw	$t1	-76	($sp)
########	printf ~39
	lw	$t0	-76	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=[]		global_char_array_2		2		~40
	li	$t0	2
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-96	($t0)
	sw	$t1	-80	($sp)
########	printf ~40
	lw	$t0	-80	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=[]		global_char_array_2		3		~41
	li	$t0	3
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-96	($t0)
	sw	$t1	-84	($sp)
########	printf ~41
	lw	$t0	-84	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=[]		global_char_array_2		4		~42
	li	$t0	4
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-96	($t0)
	sw	$t1	-88	($sp)
########	printf ~42
	lw	$t0	-88	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	func void testGlobal()
testGlobal:
	sw	$ra	-4	($sp)
########	call initGlobalArray
	sw	$sp	-16	($sp)
	subi	$sp	$sp	8
	jal	initGlobalArray
	lw	$sp	-8	($sp)
########	push 12345679
	li	$t0	12345679
	sw	$t0	-20	($sp)
########	push '9'
	li	$t0	57
	sw	$t0	-24	($sp)
########	push -12345679
	li	$t0	-12345679
	sw	$t0	-28	($sp)
########	push '*'
	li	$t0	42
	sw	$t0	-32	($sp)
########	call assignGlobal
	sw	$sp	-16	($sp)
	subi	$sp	$sp	8
	jal	assignGlobal
	lw	$sp	-8	($sp)
########	call printGlobalConst
	sw	$sp	-16	($sp)
	subi	$sp	$sp	8
	jal	printGlobalConst
	lw	$sp	-8	($sp)
########	call printGlobalVar
	sw	$sp	-16	($sp)
	subi	$sp	$sp	8
	jal	printGlobalVar
	lw	$sp	-8	($sp)
########	call printGlobalArray
	sw	$sp	-16	($sp)
	subi	$sp	$sp	8
	jal	printGlobalArray
	lw	$sp	-8	($sp)
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	func int testReturnInt()
testReturnInt:
	sw	$ra	-4	($sp)
########	+		a		1		~43
	lw	$t0	-12	($sp)
	li	$t1	1
	add	$t2	$t0	$t1
	sw	$t2	-16	($sp)
########	Retreturn  retValue:~43
	lw	$ra	-4	($sp)
	lw	$v0	-16	($sp)
	jr	$ra
########	func char testReturnChar()
testReturnChar:
	sw	$ra	-4	($sp)
########	bne		a		1		if_4_end
	lw	$t0	-12	($sp)
	li	$t1	1
	bne	$t0	$t1	if_4_end
########	Retreturn  retValue:'a'
	lw	$ra	-4	($sp)
	li	$v0	97
	jr	$ra
########	j else_4_end
	j	else_4_end
########	Label if_4_end
if_4_end:
########	bne		a		2		if_5_end
	lw	$t0	-12	($sp)
	li	$t1	2
	bne	$t0	$t1	if_5_end
########	Retreturn  retValue:'b'
	lw	$ra	-4	($sp)
	li	$v0	98
	jr	$ra
########	j else_5_end
	j	else_5_end
########	Label if_5_end
if_5_end:
########	bne		a		3		if_6_end
	lw	$t0	-12	($sp)
	li	$t1	3
	bne	$t0	$t1	if_6_end
########	Retreturn  retValue:'c'
	lw	$ra	-4	($sp)
	li	$v0	99
	jr	$ra
########	Label if_6_end
if_6_end:
########	Label else_5_end
else_5_end:
########	Label else_4_end
else_4_end:
########	Retreturn  retValue:'_'
	lw	$ra	-4	($sp)
	li	$v0	95
	jr	$ra
########	func void testReturn()
testReturn:
	sw	$ra	-4	($sp)
########	push 3
	li	$t0	3
	sw	$t0	-20	($sp)
########	call fac
	sw	$sp	-16	($sp)
	subi	$sp	$sp	8
	jal	fac
	lw	$sp	-8	($sp)
########	~44 = retValue
	sw	$v0	-12	($sp)
########	push 2
	li	$t0	2
	sw	$t0	-24	($sp)
########	call fac
	sw	$sp	-20	($sp)
	subi	$sp	$sp	12
	jal	fac
	lw	$sp	-8	($sp)
########	~45 = retValue
	sw	$v0	-16	($sp)
########	+		~44		~45		~44
	lw	$t0	-12	($sp)
	lw	$t1	-16	($sp)
	add	$t2	$t0	$t1
	sw	$t2	-12	($sp)
########	push ~44
	lw	$t0	-12	($sp)
	sw	$t0	-28	($sp)
########	call Fibonacci
	sw	$sp	-24	($sp)
	subi	$sp	$sp	16
	jal	Fibonacci
	lw	$sp	-8	($sp)
########	~46 = retValue
	sw	$v0	-20	($sp)
########	push ~46
	lw	$t0	-20	($sp)
	sw	$t0	-32	($sp)
########	call testReturnInt
	sw	$sp	-28	($sp)
	subi	$sp	$sp	20
	jal	testReturnInt
	lw	$sp	-8	($sp)
########	~47 = retValue
	sw	$v0	-24	($sp)
########	printf ~47
	lw	$t0	-24	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	push 1
	li	$t0	1
	sw	$t0	-36	($sp)
########	call testReturnChar
	sw	$sp	-32	($sp)
	subi	$sp	$sp	24
	jal	testReturnChar
	lw	$sp	-8	($sp)
########	~48 = retValue
	sw	$v0	-28	($sp)
########	printf ~48
	lw	$t0	-28	($sp)
	move	$a0	$t0
	li	$v0	11
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	push 2
	li	$t0	2
	sw	$t0	-40	($sp)
########	call testReturnChar
	sw	$sp	-36	($sp)
	subi	$sp	$sp	28
	jal	testReturnChar
	lw	$sp	-8	($sp)
########	~49 = retValue
	sw	$v0	-32	($sp)
########	printf ~49
	lw	$t0	-32	($sp)
	move	$a0	$t0
	li	$v0	11
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	push 3
	li	$t0	3
	sw	$t0	-44	($sp)
########	call testReturnChar
	sw	$sp	-40	($sp)
	subi	$sp	$sp	32
	jal	testReturnChar
	lw	$sp	-8	($sp)
########	~50 = retValue
	sw	$v0	-36	($sp)
########	printf ~50
	lw	$t0	-36	($sp)
	move	$a0	$t0
	li	$v0	11
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	push 4
	li	$t0	4
	sw	$t0	-48	($sp)
########	call testReturnChar
	sw	$sp	-44	($sp)
	subi	$sp	$sp	36
	jal	testReturnChar
	lw	$sp	-8	($sp)
########	~51 = retValue
	sw	$v0	-40	($sp)
########	printf ~51
	lw	$t0	-40	($sp)
	move	$a0	$t0
	li	$v0	11
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	func void testAssignAndExp()
testAssignAndExp:
	sw	$ra	-4	($sp)
########	const int const_int_1 = 1
########	const int const_int_2 = -1
########	const int const_int_3 = 0
########	const char const_char_1 = 'a'
########	const char const_char_2 = 'A'
########	const char const_char_3 = 'b'
########	var int int_temp_1
########	push 5
	li	$t0	5
	sw	$t0	-56	($sp)
########	call Fibonacci
	sw	$sp	-52	($sp)
	subi	$sp	$sp	44
	jal	Fibonacci
	lw	$sp	-8	($sp)
########	~52 = retValue
	sw	$v0	-48	($sp)
########	push ~52
	lw	$t0	-48	($sp)
	sw	$t0	-60	($sp)
########	call Fibonacci
	sw	$sp	-56	($sp)
	subi	$sp	$sp	48
	jal	Fibonacci
	lw	$sp	-8	($sp)
########	~53 = retValue
	sw	$v0	-52	($sp)
########	push ~53
	lw	$t0	-52	($sp)
	sw	$t0	-64	($sp)
########	call Fibonacci
	sw	$sp	-60	($sp)
	subi	$sp	$sp	52
	jal	Fibonacci
	lw	$sp	-8	($sp)
########	~54 = retValue
	sw	$v0	-56	($sp)
########	+		~54		0		~54
	lw	$t0	-56	($sp)
	li	$t1	0
	add	$t2	$t0	$t1
	sw	$t2	-56	($sp)
########	push 3
	li	$t0	3
	sw	$t0	-68	($sp)
########	call fac
	sw	$sp	-64	($sp)
	subi	$sp	$sp	56
	jal	fac
	lw	$sp	-8	($sp)
########	~55 = retValue
	sw	$v0	-60	($sp)
########	/		~54		~55		~54
	lw	$t0	-56	($sp)
	lw	$t1	-60	($sp)
	div	$t0	$t1
	mflo	$t2
	sw	$t2	-56	($sp)
########	+		1		~54		~54
	li	$t0	1
	lw	$t1	-56	($sp)
	add	$t2	$t0	$t1
	sw	$t2	-56	($sp)
########	=		~54		int_temp_1
	lw	$t0	-56	($sp)
	sw	$t0	-12	($sp)
########	push 3
	li	$t0	3
	sw	$t0	-72	($sp)
########	call fac
	sw	$sp	-68	($sp)
	subi	$sp	$sp	60
	jal	fac
	lw	$sp	-8	($sp)
########	~56 = retValue
	sw	$v0	-64	($sp)
########	push 2
	li	$t0	2
	sw	$t0	-76	($sp)
########	call fac
	sw	$sp	-72	($sp)
	subi	$sp	$sp	64
	jal	fac
	lw	$sp	-8	($sp)
########	~57 = retValue
	sw	$v0	-68	($sp)
########	+		~56		~57		~56
	lw	$t0	-64	($sp)
	lw	$t1	-68	($sp)
	add	$t2	$t0	$t1
	sw	$t2	-64	($sp)
########	push ~56
	lw	$t0	-64	($sp)
	sw	$t0	-80	($sp)
########	call fac
	sw	$sp	-76	($sp)
	subi	$sp	$sp	68
	jal	fac
	lw	$sp	-8	($sp)
########	~58 = retValue
	sw	$v0	-72	($sp)
########	=		~58		int_temp_2
	lw	$t0	-72	($sp)
	sw	$t0	-16	($sp)
########	push 0
	li	$t0	0
	sw	$t0	-84	($sp)
########	call testReturnInt
	sw	$sp	-80	($sp)
	subi	$sp	$sp	72
	jal	testReturnInt
	lw	$sp	-8	($sp)
########	~59 = retValue
	sw	$v0	-76	($sp)
########	[]=		~59		0		int_array
	lw	$t0	-76	($sp)
	li	$t1	0
	sll	$t1	$t1	2
	add	$t1	$t1	$sp
	sw	$t0	-24	($t1)
########	push 0
	li	$t0	0
	sw	$t0	-88	($sp)
########	call testReturnInt
	sw	$sp	-84	($sp)
	subi	$sp	$sp	76
	jal	testReturnInt
	lw	$sp	-8	($sp)
########	~60 = retValue
	sw	$v0	-80	($sp)
########	*		~60		-12345679		~60
	lw	$t0	-80	($sp)
	li	$t1	-12345679
	mult	$t0	$t1
	mflo	$t2
	sw	$t2	-80	($sp)
########	+		12345679		~60		~60
	li	$t0	12345679
	lw	$t1	-80	($sp)
	add	$t2	$t0	$t1
	sw	$t2	-80	($sp)
########	-		1		~60		~60
	li	$t0	1
	lw	$t1	-80	($sp)
	sub	$t2	$t0	$t1
	sw	$t2	-80	($sp)
########	push 1
	li	$t0	1
	sw	$t0	-92	($sp)
########	call testReturnInt
	sw	$sp	-88	($sp)
	subi	$sp	$sp	80
	jal	testReturnInt
	lw	$sp	-8	($sp)
########	~61 = retValue
	sw	$v0	-84	($sp)
########	+		1		~61		~61
	li	$t0	1
	lw	$t1	-84	($sp)
	add	$t2	$t0	$t1
	sw	$t2	-84	($sp)
########	[]=		~61		~60		int_array
	lw	$t0	-84	($sp)
	lw	$t1	-80	($sp)
	sll	$t1	$t1	2
	add	$t1	$t1	$sp
	sw	$t0	-24	($t1)
########	=[]		int_array		0		~62
	li	$t0	0
	sll	$t0	$t0	2
	add	$t0	$t0	$sp
	lw	$t1	-24	($t0)
	sw	$t1	-88	($sp)
########	push 0
	li	$t0	0
	sw	$t0	-100	($sp)
########	call testReturnInt
	sw	$sp	-96	($sp)
	subi	$sp	$sp	88
	jal	testReturnInt
	lw	$sp	-8	($sp)
########	~63 = retValue
	sw	$v0	-92	($sp)
########	*		~63		-12345679		~63
	lw	$t0	-92	($sp)
	li	$t1	-12345679
	mult	$t0	$t1
	mflo	$t2
	sw	$t2	-92	($sp)
########	+		12345679		~63		~63
	li	$t0	12345679
	lw	$t1	-92	($sp)
	add	$t2	$t0	$t1
	sw	$t2	-92	($sp)
########	-		1		~63		~63
	li	$t0	1
	lw	$t1	-92	($sp)
	sub	$t2	$t0	$t1
	sw	$t2	-92	($sp)
########	=[]		int_array		~63		~63
	lw	$t0	-92	($sp)
	sll	$t0	$t0	2
	add	$t0	$t0	$sp
	lw	$t1	-24	($t0)
	sw	$t1	-92	($sp)
########	*		~63		1		~63
	lw	$t0	-92	($sp)
	li	$t1	1
	mult	$t0	$t1
	mflo	$t2
	sw	$t2	-92	($sp)
########	-		~62		~63		~62
	lw	$t0	-88	($sp)
	lw	$t1	-92	($sp)
	sub	$t2	$t0	$t1
	sw	$t2	-88	($sp)
########	=		~62		int_temp_3
	lw	$t0	-88	($sp)
	sw	$t0	-28	($sp)
########	=[]		int_array		0		~64
	li	$t0	0
	sll	$t0	$t0	2
	add	$t0	$t0	$sp
	lw	$t1	-24	($t0)
	sw	$t1	-96	($sp)
########	push ~64
	lw	$t0	-96	($sp)
	sw	$t0	-108	($sp)
########	call testReturnChar
	sw	$sp	-104	($sp)
	subi	$sp	$sp	96
	jal	testReturnChar
	lw	$sp	-8	($sp)
########	~65 = retValue
	sw	$v0	-100	($sp)
########	[]=		~65		0		char_array
	lw	$t0	-100	($sp)
	li	$t1	0
	sll	$t1	$t1	2
	add	$t1	$t1	$sp
	sw	$t0	-40	($t1)
########	push 0
	li	$t0	0
	sw	$t0	-112	($sp)
########	call testReturnInt
	sw	$sp	-108	($sp)
	subi	$sp	$sp	100
	jal	testReturnInt
	lw	$sp	-8	($sp)
########	~66 = retValue
	sw	$v0	-104	($sp)
########	*		~66		-12345679		~66
	lw	$t0	-104	($sp)
	li	$t1	-12345679
	mult	$t0	$t1
	mflo	$t2
	sw	$t2	-104	($sp)
########	+		12345679		~66		~66
	li	$t0	12345679
	lw	$t1	-104	($sp)
	add	$t2	$t0	$t1
	sw	$t2	-104	($sp)
########	-		1		~66		~66
	li	$t0	1
	lw	$t1	-104	($sp)
	sub	$t2	$t0	$t1
	sw	$t2	-104	($sp)
########	=[]		int_array		1		~67
	li	$t0	1
	sll	$t0	$t0	2
	add	$t0	$t0	$sp
	lw	$t1	-24	($t0)
	sw	$t1	-108	($sp)
########	+		~67		1		~67
	lw	$t0	-108	($sp)
	li	$t1	1
	add	$t2	$t0	$t1
	sw	$t2	-108	($sp)
########	push ~67
	lw	$t0	-108	($sp)
	sw	$t0	-120	($sp)
########	call testReturnChar
	sw	$sp	-116	($sp)
	subi	$sp	$sp	108
	jal	testReturnChar
	lw	$sp	-8	($sp)
########	~68 = retValue
	sw	$v0	-112	($sp)
########	[]=		~68		~66		char_array
	lw	$t0	-112	($sp)
	lw	$t1	-104	($sp)
	sll	$t1	$t1	2
	add	$t1	$t1	$sp
	sw	$t0	-40	($t1)
########	=[]		char_array		0		~69
	li	$t0	0
	sll	$t0	$t0	2
	add	$t0	$t0	$sp
	lw	$t1	-40	($t0)
	sw	$t1	-116	($sp)
########	=		~69		char_temp_1
	lw	$t0	-116	($sp)
	sw	$t0	-32	($sp)
########	push 0
	li	$t0	0
	sw	$t0	-128	($sp)
########	call testReturnInt
	sw	$sp	-124	($sp)
	subi	$sp	$sp	116
	jal	testReturnInt
	lw	$sp	-8	($sp)
########	~70 = retValue
	sw	$v0	-120	($sp)
########	*		~70		-12345679		~70
	lw	$t0	-120	($sp)
	li	$t1	-12345679
	mult	$t0	$t1
	mflo	$t2
	sw	$t2	-120	($sp)
########	+		12345679		~70		~70
	li	$t0	12345679
	lw	$t1	-120	($sp)
	add	$t2	$t0	$t1
	sw	$t2	-120	($sp)
########	-		1		~70		~70
	li	$t0	1
	lw	$t1	-120	($sp)
	sub	$t2	$t0	$t1
	sw	$t2	-120	($sp)
########	=[]		char_array		~70		~70
	lw	$t0	-120	($sp)
	sll	$t0	$t0	2
	add	$t0	$t0	$sp
	lw	$t1	-40	($t0)
	sw	$t1	-120	($sp)
########	=		~70		char_temp_2
	lw	$t0	-120	($sp)
	sw	$t0	-44	($sp)
########	printf int_temp_1
	lw	$t0	-12	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf int_temp_2
	lw	$t0	-16	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf int_temp_3
	lw	$t0	-28	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=[]		int_array		0		~71
	li	$t0	0
	sll	$t0	$t0	2
	add	$t0	$t0	$sp
	lw	$t1	-24	($t0)
	sw	$t1	-124	($sp)
########	printf ~71
	lw	$t0	-124	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	push 0
	li	$t0	0
	sw	$t0	-136	($sp)
########	call testReturnInt
	sw	$sp	-132	($sp)
	subi	$sp	$sp	124
	jal	testReturnInt
	lw	$sp	-8	($sp)
########	~72 = retValue
	sw	$v0	-128	($sp)
########	*		~72		-12345679		~72
	lw	$t0	-128	($sp)
	li	$t1	-12345679
	mult	$t0	$t1
	mflo	$t2
	sw	$t2	-128	($sp)
########	+		12345679		~72		~72
	li	$t0	12345679
	lw	$t1	-128	($sp)
	add	$t2	$t0	$t1
	sw	$t2	-128	($sp)
########	-		1		~72		~72
	li	$t0	1
	lw	$t1	-128	($sp)
	sub	$t2	$t0	$t1
	sw	$t2	-128	($sp)
########	=[]		int_array		~72		~72
	lw	$t0	-128	($sp)
	sll	$t0	$t0	2
	add	$t0	$t0	$sp
	lw	$t1	-24	($t0)
	sw	$t1	-128	($sp)
########	printf ~72
	lw	$t0	-128	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf char_temp_1
	lw	$t0	-32	($sp)
	move	$a0	$t0
	li	$v0	11
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf char_temp_2
	lw	$t0	-44	($sp)
	move	$a0	$t0
	li	$v0	11
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=[]		char_array		0		~73
	li	$t0	0
	sll	$t0	$t0	2
	add	$t0	$t0	$sp
	lw	$t1	-40	($t0)
	sw	$t1	-132	($sp)
########	printf ~73
	lw	$t0	-132	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=[]		char_array		1		~74
	li	$t0	1
	sll	$t0	$t0	2
	add	$t0	$t0	$sp
	lw	$t1	-40	($t0)
	sw	$t1	-136	($sp)
########	printf ~74
	lw	$t0	-136	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=[]		char_array		0		~75
	li	$t0	0
	sll	$t0	$t0	2
	add	$t0	$t0	$sp
	lw	$t1	-40	($t0)
	sw	$t1	-140	($sp)
########	=[]		char_array		0		~76
	li	$t0	0
	sll	$t0	$t0	2
	add	$t0	$t0	$sp
	lw	$t1	-40	($t0)
	sw	$t1	-144	($sp)
########	*		~76		char_temp_2		~76
	lw	$t0	-144	($sp)
	lw	$t1	-44	($sp)
	mult	$t0	$t1
	mflo	$t2
	sw	$t2	-144	($sp)
########	+		~75		~76		~75
	lw	$t0	-140	($sp)
	lw	$t1	-144	($sp)
	add	$t2	$t0	$t1
	sw	$t2	-140	($sp)
########	*		char_temp_1		~75		~75
	lw	$t0	-32	($sp)
	lw	$t1	-140	($sp)
	mult	$t0	$t1
	mflo	$t2
	sw	$t2	-140	($sp)
########	printf ~75
	lw	$t0	-140	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	func void testIO()
testIO:
	sw	$ra	-4	($sp)
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
	lw	$t0	-24	($gp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf global_char_1
	lw	$t0	-48	($gp)
	move	$a0	$t0
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
	lw	$t0	-24	($gp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf global_char_1
	lw	$t0	-48	($gp)
	move	$a0	$t0
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
	lw	$t0	-48	($gp)
	move	$a0	$t0
	li	$v0	11
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf global_int_1
	lw	$t0	-24	($gp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	func void testIfWhile()
testIfWhile:
	sw	$ra	-4	($sp)
########	var int i
########	=		10		k
	li	$t0	10
	sw	$t0	-20	($sp)
########	=		'+'		a
	li	$t0	43
	sw	$t0	-24	($sp)
########	=		'-'		b
	li	$t0	45
	sw	$t0	-28	($sp)
########	=		'*'		c
	li	$t0	42
	sw	$t0	-32	($sp)
########	=		'/'		d
	li	$t0	47
	sw	$t0	-36	($sp)
########	ble		k		0		if_7_end
	lw	$t0	-20	($sp)
	li	$t1	0
	ble	$t0	$t1	if_7_end
########	bgt		k		10		if_8_end
	lw	$t0	-20	($sp)
	li	$t1	10
	bgt	$t0	$t1	if_8_end
########	=		0		i
	li	$t0	0
	sw	$t0	-12	($sp)
########	Label while_0_begin
while_0_begin:
########	/		k		2		~77
	lw	$t0	-20	($sp)
	li	$t1	2
	div	$t0	$t1
	mflo	$t2
	sw	$t2	-40	($sp)
########	bge		i		~77		while_0_end
	lw	$t0	-12	($sp)
	lw	$t1	-40	($sp)
	bge	$t0	$t1	while_0_end
########	/		i		2		~78
	lw	$t0	-12	($sp)
	li	$t1	2
	div	$t0	$t1
	mflo	$t2
	sw	$t2	-44	($sp)
########	*		~78		2		~78
	lw	$t0	-44	($sp)
	li	$t1	2
	mult	$t0	$t1
	mflo	$t2
	sw	$t2	-44	($sp)
########	-		i		~78		~78
	lw	$t0	-12	($sp)
	lw	$t1	-44	($sp)
	sub	$t2	$t0	$t1
	sw	$t2	-44	($sp)
########	bne		~78		0		if_9_end
	lw	$t0	-44	($sp)
	li	$t1	0
	bne	$t0	$t1	if_9_end
########	[]=		a		i		global_char_array_3
	lw	$t0	-24	($sp)
	lw	$t1	-12	($sp)
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-136	($t1)
########	j else_9_end
	j	else_9_end
########	Label if_9_end
if_9_end:
########	/		i		2		~79
	lw	$t0	-12	($sp)
	li	$t1	2
	div	$t0	$t1
	mflo	$t2
	sw	$t2	-48	($sp)
########	*		~79		2		~79
	lw	$t0	-48	($sp)
	li	$t1	2
	mult	$t0	$t1
	mflo	$t2
	sw	$t2	-48	($sp)
########	-		i		~79		~79
	lw	$t0	-12	($sp)
	lw	$t1	-48	($sp)
	sub	$t2	$t0	$t1
	sw	$t2	-48	($sp)
########	bne		~79		1		if_10_end
	lw	$t0	-48	($sp)
	li	$t1	1
	bne	$t0	$t1	if_10_end
########	[]=		b		i		global_char_array_3
	lw	$t0	-28	($sp)
	lw	$t1	-12	($sp)
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-136	($t1)
########	Label if_10_end
if_10_end:
########	Label else_9_end
else_9_end:
########	=[]		global_char_array_3		i		~80
	lw	$t0	-12	($sp)
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-136	($t0)
	sw	$t1	-52	($sp)
########	printf ~80
	lw	$t0	-52	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	+		i		1		~81
	lw	$t0	-12	($sp)
	li	$t1	1
	add	$t2	$t0	$t1
	sw	$t2	-56	($sp)
########	=		~81		i
	lw	$t0	-56	($sp)
	sw	$t0	-12	($sp)
########	j while_0_begin
	j	while_0_begin
########	Label while_0_end
while_0_end:
########	Label while_1_begin
while_1_begin:
########	bge		i		k		while_1_end
	lw	$t0	-12	($sp)
	lw	$t1	-20	($sp)
	bge	$t0	$t1	while_1_end
########	/		i		2		~82
	lw	$t0	-12	($sp)
	li	$t1	2
	div	$t0	$t1
	mflo	$t2
	sw	$t2	-60	($sp)
########	*		~82		2		~82
	lw	$t0	-60	($sp)
	li	$t1	2
	mult	$t0	$t1
	mflo	$t2
	sw	$t2	-60	($sp)
########	-		i		~82		~82
	lw	$t0	-12	($sp)
	lw	$t1	-60	($sp)
	sub	$t2	$t0	$t1
	sw	$t2	-60	($sp)
########	bne		~82		0		if_11_end
	lw	$t0	-60	($sp)
	li	$t1	0
	bne	$t0	$t1	if_11_end
########	[]=		c		i		global_char_array_3
	lw	$t0	-32	($sp)
	lw	$t1	-12	($sp)
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-136	($t1)
########	j else_11_end
	j	else_11_end
########	Label if_11_end
if_11_end:
########	[]=		d		i		global_char_array_3
	lw	$t0	-36	($sp)
	lw	$t1	-12	($sp)
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-136	($t1)
########	Label else_11_end
else_11_end:
########	=[]		global_char_array_3		i		~83
	lw	$t0	-12	($sp)
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-136	($t0)
	sw	$t1	-64	($sp)
########	printf ~83
	lw	$t0	-64	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	+		i		1		~84
	lw	$t0	-12	($sp)
	li	$t1	1
	add	$t2	$t0	$t1
	sw	$t2	-68	($sp)
########	=		~84		i
	lw	$t0	-68	($sp)
	sw	$t0	-12	($sp)
########	j while_1_begin
	j	while_1_begin
########	Label while_1_end
while_1_end:
########	Label if_8_end
if_8_end:
########	Label if_7_end
if_7_end:
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	func void testSwitch()
testSwitch:
	sw	$ra	-4	($sp)
########	const int sum = 3
########	var int int_1
########	=		0		i
	li	$t0	0
	sw	$t0	-16	($sp)
########	=		0		int_1
	li	$t0	0
	sw	$t0	-12	($sp)
########	Label while_2_begin
while_2_begin:
########	bge		i		3		while_2_end
	lw	$t0	-16	($sp)
	li	$t1	3
	bge	$t0	$t1	while_2_end
########	bne		int_1		0		if_12_end
	lw	$t0	-12	($sp)
	li	$t1	0
	bne	$t0	$t1	if_12_end
########	=		'a'		char_1
	li	$t0	97
	sw	$t0	-20	($sp)
########	printf char_1
	lw	$t0	-20	($sp)
	move	$a0	$t0
	li	$v0	11
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	j else_12_end
	j	else_12_end
########	Label if_12_end
if_12_end:
########	bne		int_1		1		if_13_end
	lw	$t0	-12	($sp)
	li	$t1	1
	bne	$t0	$t1	if_13_end
########	=		'b'		char_1
	li	$t0	98
	sw	$t0	-20	($sp)
########	printf char_1
	lw	$t0	-20	($sp)
	move	$a0	$t0
	li	$v0	11
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	j else_13_end
	j	else_13_end
########	Label if_13_end
if_13_end:
########	=		'_'		char_1
	li	$t0	95
	sw	$t0	-20	($sp)
########	printf char_1
	lw	$t0	-20	($sp)
	move	$a0	$t0
	li	$v0	11
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	Label else_13_end
else_13_end:
########	Label else_12_end
else_12_end:
########	bne		char_1		'a'		if_14_end
	lw	$t0	-20	($sp)
	li	$t1	97
	bne	$t0	$t1	if_14_end
########	+		i		1		~85
	lw	$t0	-16	($sp)
	li	$t1	1
	add	$t2	$t0	$t1
	sw	$t2	-24	($sp)
########	=		~85		int_1
	lw	$t0	-24	($sp)
	sw	$t0	-12	($sp)
########	printf int_1
	lw	$t0	-12	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	j else_14_end
	j	else_14_end
########	Label if_14_end
if_14_end:
########	bne		char_1		'b'		if_15_end
	lw	$t0	-20	($sp)
	li	$t1	98
	bne	$t0	$t1	if_15_end
########	=		3		int_1
	li	$t0	3
	sw	$t0	-12	($sp)
########	printf int_1
	lw	$t0	-12	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	Label if_15_end
if_15_end:
########	Label else_14_end
else_14_end:
########	+		i		1		~86
	lw	$t0	-16	($sp)
	li	$t1	1
	add	$t2	$t0	$t1
	sw	$t2	-28	($sp)
########	=		~86		i
	lw	$t0	-28	($sp)
	sw	$t0	-16	($sp)
########	j while_2_begin
	j	while_2_begin
########	Label while_2_end
while_2_end:
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	func int func_ret_int_1()
func_ret_int_1:
	sw	$ra	-4	($sp)
########	var int i_temp
########	printf string6
	la	$a0	string6
	li	$v0	4
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf i_1
	lw	$t0	-12	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf i_2
	lw	$t0	-16	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf c_1
	lw	$t0	-20	($sp)
	move	$a0	$t0
	li	$v0	11
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf c_2
	lw	$t0	-24	($sp)
	move	$a0	$t0
	li	$v0	11
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=		i_1		i_temp
	lw	$t0	-12	($sp)
	sw	$t0	-28	($sp)
########	=		i_2		i_1
	lw	$t0	-16	($sp)
	sw	$t0	-12	($sp)
########	=		i_temp		i_2
	lw	$t0	-28	($sp)
	sw	$t0	-16	($sp)
########	=		c_1		c_temp
	lw	$t0	-20	($sp)
	sw	$t0	-32	($sp)
########	=		c_2		c_1
	lw	$t0	-24	($sp)
	sw	$t0	-20	($sp)
########	=		c_temp		c_2
	lw	$t0	-32	($sp)
	sw	$t0	-24	($sp)
########	printf string7
	la	$a0	string7
	li	$v0	4
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf i_1
	lw	$t0	-12	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf i_2
	lw	$t0	-16	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf c_1
	lw	$t0	-20	($sp)
	move	$a0	$t0
	li	$v0	11
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf c_2
	lw	$t0	-24	($sp)
	move	$a0	$t0
	li	$v0	11
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	Retreturn  retValue:i_1
	lw	$ra	-4	($sp)
	lw	$v0	-12	($sp)
	jr	$ra
########	func void testPara()
testPara:
	sw	$ra	-4	($sp)
########	var int i
########	=		12345679		i
	li	$t0	12345679
	sw	$t0	-12	($sp)
########	=		-12345679		j
	li	$t0	-12345679
	sw	$t0	-16	($sp)
########	=		'A'		c
	li	$t0	65
	sw	$t0	-20	($sp)
########	=		'Z'		d
	li	$t0	90
	sw	$t0	-24	($sp)
########	push i
	lw	$t0	-12	($sp)
	sw	$t0	-36	($sp)
########	push j
	lw	$t0	-16	($sp)
	sw	$t0	-40	($sp)
########	push c
	lw	$t0	-20	($sp)
	sw	$t0	-44	($sp)
########	push d
	lw	$t0	-24	($sp)
	sw	$t0	-48	($sp)
########	call func_ret_int_1
	sw	$sp	-32	($sp)
	subi	$sp	$sp	24
	jal	func_ret_int_1
	lw	$sp	-8	($sp)
########	~87 = retValue
	sw	$v0	-28	($sp)
########	printf ~87
	lw	$t0	-28	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	func void testRecursion()
testRecursion:
	sw	$ra	-4	($sp)
########	push 2
	li	$t0	2
	sw	$t0	-20	($sp)
########	call fac
	sw	$sp	-16	($sp)
	subi	$sp	$sp	8
	jal	fac
	lw	$sp	-8	($sp)
########	~88 = retValue
	sw	$v0	-12	($sp)
########	push 3
	li	$t0	3
	sw	$t0	-24	($sp)
########	call fac
	sw	$sp	-20	($sp)
	subi	$sp	$sp	12
	jal	fac
	lw	$sp	-8	($sp)
########	~89 = retValue
	sw	$v0	-16	($sp)
########	*		~88		~89		~88
	lw	$t0	-12	($sp)
	lw	$t1	-16	($sp)
	mult	$t0	$t1
	mflo	$t2
	sw	$t2	-12	($sp)
########	push ~88
	lw	$t0	-12	($sp)
	sw	$t0	-28	($sp)
########	call Fibonacci
	sw	$sp	-24	($sp)
	subi	$sp	$sp	16
	jal	Fibonacci
	lw	$sp	-8	($sp)
########	~90 = retValue
	sw	$v0	-20	($sp)
########	push 3
	li	$t0	3
	sw	$t0	-32	($sp)
########	call Fibonacci
	sw	$sp	-28	($sp)
	subi	$sp	$sp	20
	jal	Fibonacci
	lw	$sp	-8	($sp)
########	~91 = retValue
	sw	$v0	-24	($sp)
########	push 4
	li	$t0	4
	sw	$t0	-36	($sp)
########	call Fibonacci
	sw	$sp	-32	($sp)
	subi	$sp	$sp	24
	jal	Fibonacci
	lw	$sp	-8	($sp)
########	~92 = retValue
	sw	$v0	-28	($sp)
########	+		~91		~92		~91
	lw	$t0	-24	($sp)
	lw	$t1	-28	($sp)
	add	$t2	$t0	$t1
	sw	$t2	-24	($sp)
########	push ~91
	lw	$t0	-24	($sp)
	sw	$t0	-40	($sp)
########	call fac
	sw	$sp	-36	($sp)
	subi	$sp	$sp	28
	jal	fac
	lw	$sp	-8	($sp)
########	~93 = retValue
	sw	$v0	-32	($sp)
########	-		~90		~93		~90
	lw	$t0	-20	($sp)
	lw	$t1	-32	($sp)
	sub	$t2	$t0	$t1
	sw	$t2	-20	($sp)
########	push 2
	li	$t0	2
	sw	$t0	-44	($sp)
########	call Fibonacci
	sw	$sp	-40	($sp)
	subi	$sp	$sp	32
	jal	Fibonacci
	lw	$sp	-8	($sp)
########	~94 = retValue
	sw	$v0	-36	($sp)
########	push 3
	li	$t0	3
	sw	$t0	-48	($sp)
########	call Fibonacci
	sw	$sp	-44	($sp)
	subi	$sp	$sp	36
	jal	Fibonacci
	lw	$sp	-8	($sp)
########	~95 = retValue
	sw	$v0	-40	($sp)
########	+		~94		~95		~94
	lw	$t0	-36	($sp)
	lw	$t1	-40	($sp)
	add	$t2	$t0	$t1
	sw	$t2	-36	($sp)
########	push ~94
	lw	$t0	-36	($sp)
	sw	$t0	-52	($sp)
########	call fac
	sw	$sp	-48	($sp)
	subi	$sp	$sp	40
	jal	fac
	lw	$sp	-8	($sp)
########	~96 = retValue
	sw	$v0	-44	($sp)
########	/		~90		~96		~90
	lw	$t0	-20	($sp)
	lw	$t1	-44	($sp)
	div	$t0	$t1
	mflo	$t2
	sw	$t2	-20	($sp)
########	push ~90
	lw	$t0	-20	($sp)
	sw	$t0	-56	($sp)
########	push 'a'
	li	$t0	97
	sw	$t0	-60	($sp)
########	push 'b'
	li	$t0	98
	sw	$t0	-64	($sp)
########	push 'c'
	li	$t0	99
	sw	$t0	-68	($sp)
########	call hanoi
	sw	$sp	-52	($sp)
	subi	$sp	$sp	44
	jal	hanoi
	lw	$sp	-8	($sp)
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	Label main
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
	sw	$sp	-16	($sp)
	subi	$sp	$sp	8
	jal	testRecursion
	lw	$sp	-8	($sp)
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
	sw	$sp	-16	($sp)
	subi	$sp	$sp	8
	jal	testGlobal
	lw	$sp	-8	($sp)
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
	sw	$sp	-16	($sp)
	subi	$sp	$sp	8
	jal	testReturn
	lw	$sp	-8	($sp)
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
	sw	$sp	-16	($sp)
	subi	$sp	$sp	8
	jal	testIO
	lw	$sp	-8	($sp)
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
	sw	$sp	-16	($sp)
	subi	$sp	$sp	8
	jal	testAssignAndExp
	lw	$sp	-8	($sp)
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
	sw	$sp	-16	($sp)
	subi	$sp	$sp	8
	jal	testIfWhile
	lw	$sp	-8	($sp)
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
########	call testSwitch
	sw	$sp	-16	($sp)
	subi	$sp	$sp	8
	jal	testSwitch
	lw	$sp	-8	($sp)
########	printf string22
	la	$a0	string22
	li	$v0	4
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf string23
	la	$a0	string23
	li	$v0	4
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	call testPara
	sw	$sp	-16	($sp)
	subi	$sp	$sp	8
	jal	testPara
	lw	$sp	-8	($sp)
########	printf string24
	la	$a0	string24
	li	$v0	4
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	Label end
end:
