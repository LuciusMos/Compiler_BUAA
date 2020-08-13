.data
	string0:	.asciiz "x = "
	string1:	.asciiz "y = "
	string2:	.asciiz "SWAP x = "
	string3:	.asciiz "SWAP y = "
	string4:	.asciiz "OVERFLOW!"
	string5:	.asciiz "complete number: "
	string6:	.asciiz "  "
	string7:	.asciiz " "
	string8:	.asciiz "---------------------------------------------------------------"
	string9:	.asciiz "'water flower'number is:"
	string10:	.asciiz "  "
	string11:	.asciiz " "
	string12:	.asciiz "---------------------------------------------------------------"
	string13:	.asciiz " "
	string14:	.asciiz " "
	string15:	.asciiz "The total is "
	string16:	.asciiz "5 != "
	newline:	.asciiz "\n"
.text
	jal	main
	j	end
########	func factorial()
factorial:
	sw	$ra	-4	($sp)
########	para in func: n
########	bgt		n		1		if_0_end
	li	$t9	1
	bgt	$a1	$t9	if_0_end
########	func factorial -> Retreturn  retValue:1
	lw	$ra	-4	($sp)
	li	$v0	1
	jr	$ra
########	Label if_0_end
if_0_end:
########	-		n		1		~0
	li	$t9	1
	sub	$t0	$a1	$t9
########	protect env
	sw	$a1	-12	($sp)
########	push ~0
	move	$a1	$t0
########	call factorial
	sw	$s1	-20	($sp)
	sw	$sp	-24	($sp)
	addi	$sp	$sp	-16
	jal	factorial
	lw	$sp	-8	($sp)
	lw	$a1	-12	($sp)
	lw	$s1	-20	($sp)
########	FunRet_~1 = retValue
	move	$s1	$v0
########	*		n		FunRet_~1		~2
	mult	$a1	$s1
	mflo	$t1
########	func factorial -> Retreturn  retValue:~2
	lw	$ra	-4	($sp)
	move	$v0	$t1
	jr	$ra
########	func mod()
mod:
########	para in func: x
########	para in func: y
########	%		x		y		~3
	div 	$a1	$a2
	mfhi	$t2
########	=		~3		x
	move	$a1	$t2
########	func mod -> Retreturn  retValue:x
	move	$v0	$a1
	jr	$ra
########	func swap()
swap:
########	para in func: x
########	para in func: y
########	printf string0
	la	$a0	string0
	li	$v0	4
	syscall
########	printf x
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
########	printf y
	move	$a0	$a2
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=		x		temp
	move	$s1	$a1
########	=		y		x
	move	$a1	$a2
########	=		temp		y
	move	$a2	$s1
########	printf string2
	la	$a0	string2
	li	$v0	4
	syscall
########	printf x
	move	$a0	$a1
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
########	printf y
	move	$a0	$a2
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	func swap -> NonRetreturn
	jr	$ra
########	func full_num()
full_num:
########	para in func: n
########	para in func: j
########	para in func: a
########	*		n		100		~4
	li	$t9	100
	mult	$a1	$t9
	mflo	$t3
########	*		j		10		~5
	li	$t9	10
	mult	$a2	$t9
	mflo	$t4
########	+		~4		~5		~4
	add	$t3	$t3	$t4
########	+		~4		a		~4
	add	$t3	$t3	$a3
########	func full_num -> Retreturn  retValue:~4
	move	$v0	$t3
	jr	$ra
########	func flower_num()
flower_num:
########	para in func: n
########	para in func: j
########	para in func: a
########	*		n		n		~6
	mult	$a1	$a1
	mflo	$t5
########	*		~6		n		~6
	mult	$t5	$a1
	mflo	$t5
########	*		j		j		~7
	mult	$a2	$a2
	mflo	$t6
########	*		~7		j		~7
	mult	$t6	$a2
	mflo	$t6
########	+		~6		~7		~6
	add	$t5	$t5	$t6
########	*		a		a		~8
	mult	$a3	$a3
	mflo	$t7
########	*		~8		a		~8
	mult	$t7	$a3
	mflo	$t7
########	+		~6		~8		~6
	add	$t5	$t5	$t7
########	func flower_num -> Retreturn  retValue:~6
	move	$v0	$t5
	jr	$ra
########	func complete_flower_num()
complete_flower_num:
	sw	$ra	-4	($sp)
########	=		2		j
	li	$t8	2
	move	$s4	$t8
########	bge		j		128		if_1_end
	li	$t9	128
	bge	$s4	$t9	if_1_end
########	Label dowhile_0_begin
dowhile_0_begin:
########	=		-1		n
	li	$t8	-1
	move	$k1	$t8
########	=		j		s
	move	$v1	$s4
########	=		1		i
	li	$t8	1
	move	$s3	$t8
########	bge		i		j		if_2_end
	bge	$s3	$s4	if_2_end
########	Label dowhile_1_begin
dowhile_1_begin:
########	/		j		i		~9
	div 	$s4	$s3
	mflo	$t0
########	*		~9		i		~9
	mult	$t0	$s3
	mflo	$t0
########	=		~9		x1
	move	$s1	$t0
########	protect env
########	push j
	move	$a1	$s4
########	push i
	move	$a2	$s3
########	call mod
	sw	$sp	-588	($sp)
	addi	$sp	$sp	-580
	jal	mod
	lw	$sp	-8	($sp)
########	FunRet_~10 = retValue
	move	$s1	$v0
########	bne		FunRet_~10		0		if_3_end
	li	$t9	0
	bne	$s1	$t9	if_3_end
########	+		n		1		~11
	li	$t9	1
	add	$t1	$k1	$t9
########	=		~11		n
	move	$k1	$t1
########	-		s		i		~12
	sub	$t2	$v1	$s3
########	=		~12		s
	move	$v1	$t2
########	blt		n		128		if_4_end
	li	$t9	128
	blt	$k1	$t9	if_4_end
########	printf string4
	la	$a0	string4
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
########	[]=		i		n		k
	move	$t9	$k1
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$s3	-520	($t9)
########	Label else_4_end
else_4_end:
########	Label if_3_end
if_3_end:
########	+		i		1		~13
	li	$t9	1
	add	$t3	$s3	$t9
########	=		~13		i
	move	$s3	$t3
########	bge		i		j		dowhile_1_end
	bge	$s3	$s4	dowhile_1_end
########	j dowhile_1_begin
	j	dowhile_1_begin
########	Label dowhile_1_end
dowhile_1_end:
########	Label if_2_end
if_2_end:
########	bne		s		0		if_5_end
	li	$t9	0
	bne	$v1	$t9	if_5_end
########	printf string5
	la	$a0	string5
	li	$v0	4
	syscall
########	printf j
	move	$a0	$s4
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=		0		i
	li	$t8	0
	move	$s3	$t8
########	bgt		i		n		if_6_end
	bgt	$s3	$k1	if_6_end
########	Label dowhile_2_begin
dowhile_2_begin:
########	printf string6
	la	$a0	string6
	li	$v0	4
	syscall
########	=[]		k		i		~14
	move	$t8	$s3
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t4	-520	($t8)
########	printf ~14
	move	$a0	$t4
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	+		i		1		~15
	li	$t9	1
	add	$t5	$s3	$t9
########	=		~15		i
	move	$s3	$t5
########	bgt		i		n		dowhile_2_end
	bgt	$s3	$k1	dowhile_2_end
########	j dowhile_2_begin
	j	dowhile_2_begin
########	Label dowhile_2_end
dowhile_2_end:
########	Label if_6_end
if_6_end:
########	printf string7
	la	$a0	string7
	li	$v0	4
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	Label if_5_end
if_5_end:
########	+		j		1		~16
	li	$t9	1
	add	$t6	$s4	$t9
########	=		~16		j
	move	$s4	$t6
########	bge		j		128		dowhile_0_end
	li	$t9	128
	bge	$s4	$t9	dowhile_0_end
########	j dowhile_0_begin
	j	dowhile_0_begin
########	Label dowhile_0_end
dowhile_0_end:
########	Label if_1_end
if_1_end:
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
########	=		0		y
	li	$t8	0
	move	$s0	$t8
########	=		100		i
	li	$t8	100
	move	$s3	$t8
########	bge		i		228		if_7_end
	li	$t9	228
	bge	$s3	$t9	if_7_end
########	Label dowhile_3_begin
dowhile_3_begin:
########	/		i		100		~17
	li	$t9	100
	div 	$s3	$t9
	mflo	$t7
########	=		~17		n
	move	$k1	$t7
########	/		i		10		~18
	li	$t9	10
	div 	$s3	$t9
	mflo	$t0
########	protect env
########	push ~18
	move	$a1	$t0
########	push 10
	li	$a2	10
########	call mod
	sw	$sp	-624	($sp)
	addi	$sp	$sp	-616
	jal	mod
	lw	$sp	-8	($sp)
########	FunRet_~19 = retValue
	move	$s1	$v0
########	=		FunRet_~19		j
	move	$s4	$s1
########	protect env
########	push i
	move	$a1	$s3
########	push 10
	li	$a2	10
########	call mod
	sw	$sp	-628	($sp)
	addi	$sp	$sp	-620
	jal	mod
	lw	$sp	-8	($sp)
########	FunRet_~20 = retValue
	move	$s1	$v0
########	=		FunRet_~20		a
	move	$s1	$s1
########	protect env
########	push n
	move	$a1	$k1
########	push j
	move	$a2	$s4
########	push a
	move	$a3	$s1
########	call full_num
	sw	$sp	-632	($sp)
	addi	$sp	$sp	-624
	jal	full_num
	lw	$sp	-8	($sp)
########	FunRet_~21 = retValue
	sw	$v0	-628	($sp)
########	protect env
########	push n
	move	$a1	$k1
########	push j
	move	$a2	$s4
########	push a
	move	$a3	$s1
########	call flower_num
	sw	$sp	-636	($sp)
	addi	$sp	$sp	-628
	jal	flower_num
	lw	$sp	-8	($sp)
########	FunRet_~22 = retValue
	move	$s1	$v0
########	bne		FunRet_~21		FunRet_~22		if_8_end
	lw	$t8	-628	($sp)
	bne	$t8	$s1	if_8_end
########	[]=		i		y		k
	move	$t9	$s0
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$s3	-520	($t9)
########	+		y		1		~23
	li	$t9	1
	add	$t1	$s0	$t9
########	=		~23		y
	move	$s0	$t1
########	Label if_8_end
if_8_end:
########	+		i		1		~24
	li	$t9	1
	add	$t2	$s3	$t9
########	=		~24		i
	move	$s3	$t2
########	bge		i		228		dowhile_3_end
	li	$t9	228
	bge	$s3	$t9	dowhile_3_end
########	j dowhile_3_begin
	j	dowhile_3_begin
########	Label dowhile_3_end
dowhile_3_end:
########	Label if_7_end
if_7_end:
########	=		0		i
	li	$t8	0
	move	$s3	$t8
########	bge		i		y		if_9_end
	bge	$s3	$s0	if_9_end
########	Label dowhile_4_begin
dowhile_4_begin:
########	printf string10
	la	$a0	string10
	li	$v0	4
	syscall
########	=[]		k		i		~25
	move	$t8	$s3
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t3	-520	($t8)
########	printf ~25
	move	$a0	$t3
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	+		i		1		~26
	li	$t9	1
	add	$t4	$s3	$t9
########	=		~26		i
	move	$s3	$t4
########	bge		i		y		dowhile_4_end
	bge	$s3	$s0	dowhile_4_end
########	j dowhile_4_begin
	j	dowhile_4_begin
########	Label dowhile_4_end
dowhile_4_end:
########	Label if_9_end
if_9_end:
########	printf string11
	la	$a0	string11
	li	$v0	4
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf string12
	la	$a0	string12
	li	$v0	4
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=		0		h
	li	$t8	0
	move	$s2	$t8
########	=		1		leap
	li	$t8	1
	move	$s7	$t8
########	=		2		m
	li	$t8	2
	move	$k0	$t8
########	bgt		m		128		if_10_end
	li	$t9	128
	bgt	$k0	$t9	if_10_end
########	Label dowhile_5_begin
dowhile_5_begin:
########	/		m		2		~27
	li	$t9	2
	div 	$k0	$t9
	mflo	$t5
########	=		~27		k2
	move	$s6	$t5
########	=		2		i
	li	$t8	2
	move	$s3	$t8
########	bgt		i		k2		if_11_end
	bgt	$s3	$s6	if_11_end
########	Label dowhile_6_begin
dowhile_6_begin:
########	/		m		i		~28
	div 	$k0	$s3
	mflo	$t6
########	*		~28		i		~28
	mult	$t6	$s3
	mflo	$t6
########	=		~28		x2
	move	$s1	$t6
########	protect env
########	push m
	move	$a1	$k0
########	push i
	move	$a2	$s3
########	call mod
	sw	$sp	-664	($sp)
	addi	$sp	$sp	-656
	jal	mod
	lw	$sp	-8	($sp)
########	FunRet_~29 = retValue
	move	$s1	$v0
########	bne		FunRet_~29		0		if_12_end
	li	$t9	0
	bne	$s1	$t9	if_12_end
########	=		0		leap
	li	$t8	0
	move	$s7	$t8
########	Label if_12_end
if_12_end:
########	+		i		1		~30
	li	$t9	1
	add	$t7	$s3	$t9
########	=		~30		i
	move	$s3	$t7
########	bgt		i		k2		dowhile_6_end
	bgt	$s3	$s6	dowhile_6_end
########	j dowhile_6_begin
	j	dowhile_6_begin
########	Label dowhile_6_end
dowhile_6_end:
########	Label if_11_end
if_11_end:
########	bne		leap		1		if_13_end
	li	$t9	1
	bne	$s7	$t9	if_13_end
########	printf string13
	la	$a0	string13
	li	$v0	4
	syscall
########	printf m
	move	$a0	$k0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	+		h		1		~31
	li	$t9	1
	add	$t0	$s2	$t9
########	=		~31		h
	move	$s2	$t0
########	/		h		10		~32
	li	$t9	10
	div 	$s2	$t9
	mflo	$t1
########	*		~32		10		~32
	li	$t9	10
	mult	$t1	$t9
	mflo	$t1
########	=		~32		x2
	move	$s1	$t1
########	bne		x2		h		if_14_end
	bne	$s1	$s2	if_14_end
########	printf string14
	la	$a0	string14
	li	$v0	4
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	Label if_14_end
if_14_end:
########	Label if_13_end
if_13_end:
########	=		1		leap
	li	$t8	1
	move	$s7	$t8
########	+		m		1		~33
	li	$t9	1
	add	$t2	$k0	$t9
########	=		~33		m
	move	$k0	$t2
########	bgt		m		128		dowhile_5_end
	li	$t9	128
	bgt	$k0	$t9	dowhile_5_end
########	j dowhile_5_begin
	j	dowhile_5_begin
########	Label dowhile_5_end
dowhile_5_end:
########	Label if_10_end
if_10_end:
########	printf string15
	la	$a0	string15
	li	$v0	4
	syscall
########	printf h
	move	$a0	$s2
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	func complete_flower_num -> NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	func main()
main:
	sw	$ra	-4	($sp)
########	protect env
########	push 5
	li	$a1	5
########	call factorial
	sw	$sp	-20	($sp)
	addi	$sp	$sp	-12
	jal	factorial
	lw	$sp	-8	($sp)
########	FunRet_~34 = retValue
	move	$s1	$v0
########	=		FunRet_~34		n
	move	$s1	$s1
########	printf string16
	la	$a0	string16
	li	$v0	4
	syscall
########	printf n
	move	$a0	$s1
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	protect env
########	push 5
	li	$a1	5
########	push 10
	li	$a2	10
########	call swap
	sw	$sp	-24	($sp)
	addi	$sp	$sp	-16
	jal	swap
	lw	$sp	-8	($sp)
########	call complete_flower_num
	sw	$sp	-24	($sp)
	addi	$sp	$sp	-16
	jal	complete_flower_num
	lw	$sp	-8	($sp)
########	func main -> NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	Label end
end:
