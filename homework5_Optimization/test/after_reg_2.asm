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
	subi	$sp	$sp	16
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
########	/		x		y		~3
	div 	$a1	$a2
	mflo	$t2
########	*		~3		y		~4
	mult	$t2	$a2
	mflo	$t3
########	-		x		~4		~5
	sub	$t4	$a1	$t3
########	=		~5		x
	move	$a1	$t4
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
########	*		n		100		~6
	li	$t9	100
	mult	$a1	$t9
	mflo	$t5
########	*		j		10		~7
	li	$t9	10
	mult	$a2	$t9
	mflo	$t6
########	+		~6		~7		~8
	add	$t7	$t5	$t6
########	+		~8		a		~9
	add	$t0	$t7	$a3
########	func full_num -> Retreturn  retValue:~9
	move	$v0	$t0
	jr	$ra
########	func flower_num()
flower_num:
########	para in func: n
########	para in func: j
########	para in func: a
########	*		n		n		~10
	mult	$a1	$a1
	mflo	$t1
########	*		~10		n		~11
	mult	$t1	$a1
	mflo	$t2
########	*		j		j		~12
	mult	$a2	$a2
	mflo	$t3
########	*		~12		j		~13
	mult	$t3	$a2
	mflo	$t4
########	+		~11		~13		~14
	add	$t5	$t2	$t4
########	*		a		a		~15
	mult	$a3	$a3
	mflo	$t6
########	*		~15		a		~16
	mult	$t6	$a3
	mflo	$t7
########	+		~14		~16		~17
	add	$t0	$t5	$t7
########	func flower_num -> Retreturn  retValue:~17
	move	$v0	$t0
	jr	$ra
########	func complete_flower_num()
complete_flower_num:
	sw	$ra	-4	($sp)
########	=		2		j
	li	$t8	2
	move	$s4	$t8
########	Label for_0_begin
for_0_begin:
########	bge		j		128		for_0_end
	li	$t9	128
	bge	$s4	$t9	for_0_end
########	=		-1		n
	li	$t8	-1
	move	$k1	$t8
########	=		j		s
	move	$v1	$s4
########	=		1		i
	li	$t8	1
	move	$s3	$t8
########	Label for_1_begin
for_1_begin:
########	bge		i		j		for_1_end
	bge	$s3	$s4	for_1_end
########	/		j		i		~18
	div 	$s4	$s3
	mflo	$t1
########	*		~18		i		~19
	mult	$t1	$s3
	mflo	$t2
########	=		~19		x1
	move	$s1	$t2
########	protect env
########	push j
	move	$a1	$s4
########	push i
	move	$a2	$s3
########	call mod
	sw	$sp	-592	($sp)
	subi	$sp	$sp	584
	jal	mod
	lw	$sp	-8	($sp)
########	FunRet_~20 = retValue
	move	$s1	$v0
########	bne		FunRet_~20		0		if_1_end
	li	$t9	0
	bne	$s1	$t9	if_1_end
########	+		n		1		~21
	li	$t9	1
	add	$t3	$k1	$t9
########	=		~21		n
	move	$k1	$t3
########	-		s		i		~22
	sub	$t4	$v1	$s3
########	=		~22		s
	move	$v1	$t4
########	blt		n		128		if_2_end
	li	$t9	128
	blt	$k1	$t9	if_2_end
########	printf string4
	la	$a0	string4
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
########	[]=		i		n		k
	move	$t9	$k1
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$s3	-520	($t9)
########	Label else_2_end
else_2_end:
########	Label if_1_end
if_1_end:
########	+		i		1		~23
	li	$t9	1
	add	$t5	$s3	$t9
########	=		~23		i
	move	$s3	$t5
########	j for_1_begin
	j	for_1_begin
########	Label for_1_end
for_1_end:
########	bne		s		0		if_3_end
	li	$t9	0
	bne	$v1	$t9	if_3_end
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
########	Label for_2_begin
for_2_begin:
########	bgt		i		n		for_2_end
	bgt	$s3	$k1	for_2_end
########	printf string6
	la	$a0	string6
	li	$v0	4
	syscall
########	=[]		k		i		~24
	move	$t8	$s3
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t6	-520	($t8)
########	printf ~24
	move	$a0	$t6
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	+		i		1		~25
	li	$t9	1
	add	$t7	$s3	$t9
########	=		~25		i
	move	$s3	$t7
########	j for_2_begin
	j	for_2_begin
########	Label for_2_end
for_2_end:
########	printf string7
	la	$a0	string7
	li	$v0	4
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	Label if_3_end
if_3_end:
########	+		j		1		~26
	li	$t9	1
	add	$t0	$s4	$t9
########	=		~26		j
	move	$s4	$t0
########	j for_0_begin
	j	for_0_begin
########	Label for_0_end
for_0_end:
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
########	Label for_3_begin
for_3_begin:
########	bge		i		228		for_3_end
	li	$t9	228
	bge	$s3	$t9	for_3_end
########	/		i		100		~27
	li	$t9	100
	div 	$s3	$t9
	mflo	$t1
########	=		~27		n
	move	$k1	$t1
########	/		i		10		~28
	li	$t9	10
	div 	$s3	$t9
	mflo	$t2
########	protect env
########	push ~28
	move	$a1	$t2
########	push 10
	li	$a2	10
########	call mod
	sw	$sp	-628	($sp)
	subi	$sp	$sp	620
	jal	mod
	lw	$sp	-8	($sp)
########	FunRet_~29 = retValue
	move	$s1	$v0
########	=		FunRet_~29		j
	move	$s4	$s1
########	protect env
########	push i
	move	$a1	$s3
########	push 10
	li	$a2	10
########	call mod
	sw	$sp	-632	($sp)
	subi	$sp	$sp	624
	jal	mod
	lw	$sp	-8	($sp)
########	FunRet_~30 = retValue
	move	$s1	$v0
########	=		FunRet_~30		a
	move	$s1	$s1
########	protect env
########	push n
	move	$a1	$k1
########	push j
	move	$a2	$s4
########	push a
	move	$a3	$s1
########	call full_num
	sw	$sp	-636	($sp)
	subi	$sp	$sp	628
	jal	full_num
	lw	$sp	-8	($sp)
########	FunRet_~31 = retValue
	sw	$v0	-632	($sp)
########	protect env
########	push n
	move	$a1	$k1
########	push j
	move	$a2	$s4
########	push a
	move	$a3	$s1
########	call flower_num
	sw	$sp	-640	($sp)
	subi	$sp	$sp	632
	jal	flower_num
	lw	$sp	-8	($sp)
########	FunRet_~32 = retValue
	move	$s1	$v0
########	bne		FunRet_~31		FunRet_~32		if_4_end
	lw	$t8	-632	($sp)
	bne	$t8	$s1	if_4_end
########	[]=		i		y		k
	move	$t9	$s0
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$s3	-520	($t9)
########	+		y		1		~33
	li	$t9	1
	add	$t3	$s0	$t9
########	=		~33		y
	move	$s0	$t3
########	Label if_4_end
if_4_end:
########	+		i		1		~34
	li	$t9	1
	add	$t4	$s3	$t9
########	=		~34		i
	move	$s3	$t4
########	j for_3_begin
	j	for_3_begin
########	Label for_3_end
for_3_end:
########	=		0		i
	li	$t8	0
	move	$s3	$t8
########	Label for_4_begin
for_4_begin:
########	bge		i		y		for_4_end
	bge	$s3	$s0	for_4_end
########	printf string10
	la	$a0	string10
	li	$v0	4
	syscall
########	=[]		k		i		~35
	move	$t8	$s3
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t5	-520	($t8)
########	printf ~35
	move	$a0	$t5
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	+		i		1		~36
	li	$t9	1
	add	$t6	$s3	$t9
########	=		~36		i
	move	$s3	$t6
########	j for_4_begin
	j	for_4_begin
########	Label for_4_end
for_4_end:
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
########	Label for_5_begin
for_5_begin:
########	bgt		m		128		for_5_end
	li	$t9	128
	bgt	$k0	$t9	for_5_end
########	/		m		2		~37
	li	$t9	2
	div 	$k0	$t9
	mflo	$t7
########	=		~37		k2
	move	$s6	$t7
########	=		2		i
	li	$t8	2
	move	$s3	$t8
########	Label for_6_begin
for_6_begin:
########	bgt		i		k2		for_6_end
	bgt	$s3	$s6	for_6_end
########	/		m		i		~38
	div 	$k0	$s3
	mflo	$t0
########	*		~38		i		~39
	mult	$t0	$s3
	mflo	$t1
########	=		~39		x2
	move	$s1	$t1
########	protect env
########	push m
	move	$a1	$k0
########	push i
	move	$a2	$s3
########	call mod
	sw	$sp	-672	($sp)
	subi	$sp	$sp	664
	jal	mod
	lw	$sp	-8	($sp)
########	FunRet_~40 = retValue
	move	$s1	$v0
########	bne		FunRet_~40		0		if_5_end
	li	$t9	0
	bne	$s1	$t9	if_5_end
########	=		0		leap
	li	$t8	0
	move	$s7	$t8
########	Label if_5_end
if_5_end:
########	+		i		1		~41
	li	$t9	1
	add	$t2	$s3	$t9
########	=		~41		i
	move	$s3	$t2
########	j for_6_begin
	j	for_6_begin
########	Label for_6_end
for_6_end:
########	bne		leap		1		if_6_end
	li	$t9	1
	bne	$s7	$t9	if_6_end
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
########	+		h		1		~42
	li	$t9	1
	add	$t3	$s2	$t9
########	=		~42		h
	move	$s2	$t3
########	/		h		10		~43
	li	$t9	10
	div 	$s2	$t9
	mflo	$t4
########	*		~43		10		~44
	li	$t9	10
	mult	$t4	$t9
	mflo	$t5
########	=		~44		x2
	move	$s1	$t5
########	bne		x2		h		if_7_end
	bne	$s1	$s2	if_7_end
########	printf string14
	la	$a0	string14
	li	$v0	4
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	Label if_7_end
if_7_end:
########	Label if_6_end
if_6_end:
########	=		1		leap
	li	$t8	1
	move	$s7	$t8
########	+		m		1		~45
	li	$t9	1
	add	$t6	$k0	$t9
########	=		~45		m
	move	$k0	$t6
########	j for_5_begin
	j	for_5_begin
########	Label for_5_end
for_5_end:
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
	subi	$sp	$sp	12
	jal	factorial
	lw	$sp	-8	($sp)
########	FunRet_~46 = retValue
	move	$s1	$v0
########	=		FunRet_~46		n
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
	subi	$sp	$sp	16
	jal	swap
	lw	$sp	-8	($sp)
########	call complete_flower_num
	sw	$sp	-24	($sp)
	subi	$sp	$sp	16
	jal	complete_flower_num
	lw	$sp	-8	($sp)
########	func main -> NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	Label end
end:
