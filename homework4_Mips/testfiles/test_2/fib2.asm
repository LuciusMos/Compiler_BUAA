.data
	newline:	.asciiz "\n"
.text
	jal	main
	j	end
########	func int Fibnaci()
Fibnaci:
	sw	$ra	-4	($sp)
########	bne		n		1		if_0_end
	lw	$t0	-12	($sp)
	li	$t1	1
	bne	$t0	$t1	if_0_end
########	Retreturn  retValue:1
	lw	$ra	-4	($sp)
	li	$v0	1
	jr	$ra
########	j else_0_end
	j	else_0_end
########	Label if_0_end
if_0_end:
########	bne		n		2		if_1_end
	lw	$t0	-12	($sp)
	li	$t1	2
	bne	$t0	$t1	if_1_end
########	Retreturn  retValue:1
	lw	$ra	-4	($sp)
	li	$v0	1
	jr	$ra
########	j else_1_end
	j	else_1_end
########	Label if_1_end
if_1_end:
########	-		n		1		~0
	lw	$t0	-12	($sp)
	li	$t1	1
	sub	$t2	$t0	$t1
	sw	$t2	-16	($sp)
########	push ~0
	lw	$t0	-16	($sp)
	sw	$t0	-28	($sp)
########	call Fibnaci
	sw	$sp	-24	($sp)
	subi	$sp	$sp	16
	jal	Fibnaci
	lw	$sp	-8	($sp)
########	~1 = retValue
	sw	$v0	-20	($sp)
########	-		n		2		~2
	lw	$t0	-12	($sp)
	li	$t1	2
	sub	$t2	$t0	$t1
	sw	$t2	-24	($sp)
########	push ~2
	lw	$t0	-24	($sp)
	sw	$t0	-36	($sp)
########	call Fibnaci
	sw	$sp	-32	($sp)
	subi	$sp	$sp	24
	jal	Fibnaci
	lw	$sp	-8	($sp)
########	~3 = retValue
	sw	$v0	-28	($sp)
########	+		~1		~3		~1
	lw	$t0	-20	($sp)
	lw	$t1	-28	($sp)
	add	$t2	$t0	$t1
	sw	$t2	-20	($sp)
########	Retreturn  retValue:~1
	lw	$ra	-4	($sp)
	lw	$v0	-20	($sp)
	jr	$ra
########	Label else_1_end
else_1_end:
########	Label else_0_end
else_0_end:
########	Label main
main:
	sw	$ra	-4	($sp)
########	var int a
########	=		6		a
	li	$t0	6
	sw	$t0	-12	($sp)
########	*		a		a		~4
	lw	$t0	-12	($sp)
	lw	$t1	-12	($sp)
	mult	$t0	$t1
	mflo	$t2
	sw	$t2	-16	($sp)
########	*		~4		a		~4
	lw	$t0	-16	($sp)
	lw	$t1	-12	($sp)
	mult	$t0	$t1
	mflo	$t2
	sw	$t2	-16	($sp)
########	*		~4		a		~4
	lw	$t0	-16	($sp)
	lw	$t1	-12	($sp)
	mult	$t0	$t1
	mflo	$t2
	sw	$t2	-16	($sp)
########	printf ~4
	lw	$t0	-16	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=		1		a
	li	$t0	1
	sw	$t0	-12	($sp)
########	Label for_0_begin
for_0_begin:
########	bge		a		9		for_0_end
	lw	$t0	-12	($sp)
	li	$t1	9
	bge	$t0	$t1	for_0_end
########	push a
	lw	$t0	-12	($sp)
	sw	$t0	-28	($sp)
########	call Fibnaci
	sw	$sp	-24	($sp)
	subi	$sp	$sp	16
	jal	Fibnaci
	lw	$sp	-8	($sp)
########	~5 = retValue
	sw	$v0	-20	($sp)
########	printf ~5
	lw	$t0	-20	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	+		a		1		~6
	lw	$t0	-12	($sp)
	li	$t1	1
	add	$t2	$t0	$t1
	sw	$t2	-24	($sp)
########	=		~6		a
	lw	$t0	-24	($sp)
	sw	$t0	-12	($sp)
########	j for_0_begin
	j	for_0_begin
########	Label for_0_end
for_0_end:
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	Label end
end:
