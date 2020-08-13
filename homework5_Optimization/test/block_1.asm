.data
	string0:	.asciiz "\\n"
	string1:	.asciiz "input cal != 0, abs(cal) = "
	string2:	.asciiz "+-*/"
	string3:	.asciiz "abs(-7) = "
	string4:	.asciiz "fibic val = "
	string5:	.asciiz "(expect 91)sum4="
	string6:	.asciiz "1 + 2 + 3 + 4 != 10"
	string7:	.asciiz "1 + 2 + 3 + 4 == 10"
	string8:	.asciiz "Congratulations!"
	string9:	.asciiz "Wrong"
	newline:	.asciiz "\n"
.text
	jal	main
	j	end
########	func fibic()
fibic:
	sw	$ra	-4	($sp)
########	para in func: a
########	ble		a		2		if_0_end
	li	$t9	2
	ble	$a1	$t9	if_0_end
########	-		a		1		~0
	li	$t9	1
	sub	$t8	$a1	$t9
	sw	$t8	-16	($sp)
########	protect env
	sw	$a1	-12	($sp)
########	push ~0
	lw	$a1	-16	($sp)
########	call fibic
	sw	$sp	-24	($sp)
	subi	$sp	$sp	16
	jal	fibic
	lw	$sp	-8	($sp)
	lw	$a1	-12	($sp)
########	FunRet_~1 = retValue
	sw	$v0	-20	($sp)
########	-		a		2		~2
	li	$t9	2
	sub	$t8	$a1	$t9
	sw	$t8	-24	($sp)
########	protect env
	sw	$a1	-12	($sp)
########	push ~2
	lw	$a1	-24	($sp)
########	call fibic
	sw	$sp	-32	($sp)
	subi	$sp	$sp	24
	jal	fibic
	lw	$sp	-8	($sp)
	lw	$a1	-12	($sp)
########	FunRet_~3 = retValue
	sw	$v0	-28	($sp)
########	+		FunRet_~1		FunRet_~3		~4
	lw	$t8	-20	($sp)
	lw	$t9	-28	($sp)
	add	$t8	$t8	$t9
	sw	$t8	-32	($sp)
########	func fibic -> Retreturn  retValue:~4
	lw	$ra	-4	($sp)
	lw	$v0	-32	($sp)
	jr	$ra
########	j else_0_end
	j	else_0_end
########	Label if_0_end
if_0_end:
########	func fibic -> Retreturn  retValue:1
	lw	$ra	-4	($sp)
	li	$v0	1
	jr	$ra
########	Label else_0_end
else_0_end:
########	func abs()
abs:
########	para in func: kk
########	bge		kk		0		if_1_end
	li	$t9	0
	bge	$a1	$t9	if_1_end
########	-		0		kk		~5
	li	$t8	0
	sub	$t8	$t8	$a1
	sw	$t8	-16	($sp)
########	func abs -> Retreturn  retValue:~5
	lw	$v0	-16	($sp)
	jr	$ra
########	Label if_1_end
if_1_end:
########	func abs -> Retreturn  retValue:kk
	move	$v0	$a1
	jr	$ra
########	func plus()
plus:
########	=		'+'		plussy
	li	$t8	43
	sw	$t8	-12	($sp)
########	func plus -> Retreturn  retValue:plussy
	lw	$v0	-12	($sp)
	jr	$ra
########	func sum4()
sum4:
########	para in func: a
########	para in func: b
########	para in func: c
########	para in func: d
########	+		a		b		~6
	add	$t8	$a1	$a2
	sw	$t8	-28	($sp)
########	+		~6		c		~7
	lw	$t8	-28	($sp)
	add	$t8	$t8	$a3
	sw	$t8	-32	($sp)
########	+		~7		d		~8
	lw	$t8	-32	($sp)
	lw	$t9	-24	($sp)
	add	$t8	$t8	$t9
	sw	$t8	-36	($sp)
########	func sum4 -> Retreturn  retValue:~8
	lw	$v0	-36	($sp)
	jr	$ra
########	func main()
main:
	sw	$ra	-4	($sp)
########	scanf toPrinti
	li	$v0	5
	syscall
	sw	$v0	-16	($sp)
########	scanf outch
	li	$v0	12
	syscall
	sw	$v0	-20	($sp)
########	scanf cal
	li	$v0	5
	syscall
	sw	$v0	-12	($sp)
########	printf string0
	la	$a0	string0
	li	$v0	4
	syscall
########	printf toPrinti
	lw	$a0	-16	($sp)
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	beq		cal		0		if_2_end
	lw	$t8	-12	($sp)
	li	$t9	0
	beq	$t8	$t9	if_2_end
########	printf string1
	la	$a0	string1
	li	$v0	4
	syscall
########	protect env
########	push cal
	lw	$a1	-12	($sp)
########	call abs
	sw	$sp	-32	($sp)
	subi	$sp	$sp	24
	jal	abs
	lw	$sp	-8	($sp)
########	FunRet_~9 = retValue
	sw	$v0	-28	($sp)
########	printf FunRet_~9
	lw	$a0	-28	($sp)
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	Label if_2_end
if_2_end:
########	blt		cal		14		if_3_end
	lw	$t8	-12	($sp)
	li	$t9	14
	blt	$t8	$t9	if_3_end
########	=		13		cal
	li	$t8	13
	sw	$t8	-12	($sp)
########	Label if_3_end
if_3_end:
########	=		'_'		underline
	li	$t8	95
	sw	$t8	-24	($sp)
########	printf outch
	lw	$a0	-20	($sp)
	li	$v0	11
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	call plus
	sw	$sp	-36	($sp)
	subi	$sp	$sp	28
	jal	plus
	lw	$sp	-8	($sp)
########	FunRet_~10 = retValue
	sw	$v0	-32	($sp)
########	printf FunRet_~10
	lw	$a0	-32	($sp)
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
########	printf underline
	lw	$a0	-24	($sp)
	li	$v0	11
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	protect env
########	push cal
	lw	$a1	-12	($sp)
########	call abs
	sw	$sp	-40	($sp)
	subi	$sp	$sp	32
	jal	abs
	lw	$sp	-8	($sp)
########	FunRet_~11 = retValue
	sw	$v0	-36	($sp)
########	=		FunRet_~11		cal
	lw	$t8	-36	($sp)
	sw	$t8	-12	($sp)
########	printf string3
	la	$a0	string3
	li	$v0	4
	syscall
########	protect env
########	push -7
	li	$a1	-7
########	call abs
	sw	$sp	-44	($sp)
	subi	$sp	$sp	36
	jal	abs
	lw	$sp	-8	($sp)
########	FunRet_~12 = retValue
	sw	$v0	-40	($sp)
########	printf FunRet_~12
	lw	$a0	-40	($sp)
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
########	protect env
########	push cal
	lw	$a1	-12	($sp)
########	call fibic
	sw	$sp	-48	($sp)
	subi	$sp	$sp	40
	jal	fibic
	lw	$sp	-8	($sp)
########	FunRet_~13 = retValue
	sw	$v0	-44	($sp)
########	printf FunRet_~13
	lw	$a0	-44	($sp)
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf string5
	la	$a0	string5
	li	$v0	4
	syscall
########	protect env
########	push 3
	li	$a1	3
########	push 4
	li	$a2	4
########	push 5
	li	$a3	5
########	push 6
	li	$t8	6
	sw	$t8	-68	($sp)
########	call sum4
	sw	$sp	-52	($sp)
	subi	$sp	$sp	44
	jal	sum4
	lw	$sp	-8	($sp)
########	FunRet_~14 = retValue
	sw	$v0	-48	($sp)
########	protect env
########	push 2
	li	$a1	2
########	push FunRet_~14
	lw	$a2	-48	($sp)
########	push 7
	li	$a3	7
########	push 8
	li	$t8	8
	sw	$t8	-72	($sp)
########	call sum4
	sw	$sp	-56	($sp)
	subi	$sp	$sp	48
	jal	sum4
	lw	$sp	-8	($sp)
########	FunRet_~15 = retValue
	sw	$v0	-52	($sp)
########	protect env
########	push 10
	li	$a1	10
########	push 11
	li	$a2	11
########	push 12
	li	$a3	12
########	push 13
	li	$t8	13
	sw	$t8	-76	($sp)
########	call sum4
	sw	$sp	-60	($sp)
	subi	$sp	$sp	52
	jal	sum4
	lw	$sp	-8	($sp)
########	FunRet_~16 = retValue
	sw	$v0	-56	($sp)
########	protect env
########	push 1
	li	$a1	1
########	push FunRet_~15
	lw	$a2	-52	($sp)
########	push 9
	li	$a3	9
########	push FunRet_~16
	lw	$t8	-56	($sp)
	sw	$t8	-80	($sp)
########	call sum4
	sw	$sp	-64	($sp)
	subi	$sp	$sp	56
	jal	sum4
	lw	$sp	-8	($sp)
########	FunRet_~17 = retValue
	sw	$v0	-60	($sp)
########	printf FunRet_~17
	lw	$a0	-60	($sp)
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	protect env
########	push 1
	li	$a1	1
########	push 2
	li	$a2	2
########	push 3
	li	$a3	3
########	push 4
	li	$t8	4
	sw	$t8	-84	($sp)
########	call sum4
	sw	$sp	-68	($sp)
	subi	$sp	$sp	60
	jal	sum4
	lw	$sp	-8	($sp)
########	FunRet_~18 = retValue
	sw	$v0	-64	($sp)
########	beq		FunRet_~18		10		if_4_end
	lw	$t8	-64	($sp)
	li	$t9	10
	beq	$t8	$t9	if_4_end
########	printf string6
	la	$a0	string6
	li	$v0	4
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	j else_4_end
	j	else_4_end
########	Label if_4_end
if_4_end:
########	printf string7
	la	$a0	string7
	li	$v0	4
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	Label else_4_end
else_4_end:
########	bne		25		25		if_5_end
	li	$t8	25
	li	$t9	25
	bne	$t8	$t9	if_5_end
########	printf string8
	la	$a0	string8
	li	$v0	4
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	j else_5_end
	j	else_5_end
########	Label if_5_end
if_5_end:
########	printf string9
	la	$a0	string9
	li	$v0	4
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	Label else_5_end
else_5_end:
########	func main -> NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	Label end
end:
