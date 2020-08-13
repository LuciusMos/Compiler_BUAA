.data
	newline:	.asciiz "\n"
.text
	jal	main
	j	end
							########	func abs()
abs:
							########	para in func: a
							########	bge		a		0		if_0_end
	bge	$a1	0	if_0_end
							########	-		0		a		~0
	li	$t8	0
	sub	$t0	$t8	$a1
							########	+		~0		0		~0
	addi	$t0	$t0	0
							########	func abs -> Retreturn  retValue:~0
	move	$v0	$t0
	jr	$ra
							########	Label if_0_end
if_0_end:
							########	+		a		0		~1
	addi	$t1	$a1	0
							########	func abs -> Retreturn  retValue:~1
	move	$v0	$t1
	jr	$ra
							########	func times()
times:
							########	para in func: a
							########	para in func: b
							########	*		a		b		~2
	mult	$a1	$a2
	mflo	$t2
							########	func times -> Retreturn  retValue:~2
	move	$v0	$t2

							########	func sum4()
sum4:
							########	para in func: a
							########	para in func: b
							########	para in func: c
							########	para in func: d
							########	+		a		b		~3
	add	$t0	$a1	$a2
							########	+		~3		c		~3
	add	$t0	$t0	$a3
							########	+		~3		d		~3
	add	$t0	$t0	$s0
							########	func sum4 -> Retreturn  retValue:~3
	move	$v0	$t0

							########	func main()
main:
	sw	$ra	-4	($sp)
							########	protect env
							########	push 2
	li	$a1	2
							########	push -2
	li	$a2	-2
							########	call times
	addi	$sp	$sp	-8
							########	func times()
							########	para in func: a
							########	para in func: b
							########	*		a		b		~2
	mult	$a1	$a2
	mflo	$t2
							########	func times -> Retreturn  retValue:~2
	move	$v0	$t2
	addi	$sp	$sp	8
							########	FunRet_~4 = retValue
	move	$s0	$v0
							########	protect env
							########	push FunRet_~4
	move	$a1	$s0
							########	call abs
	addi	$sp	$sp	-12
	jal	abs
	addi	$sp	$sp	12
							########	FunRet_~5 = retValue
	move	$s1	$v0
							########	protect env
							########	push -1
	li	$a1	-1
							########	call abs
	addi	$sp	$sp	-16
	jal	abs
	addi	$sp	$sp	16
							########	FunRet_~6 = retValue
	move	$s2	$v0
							########	protect env
							########	push -3
	li	$a1	-3
							########	call abs
	addi	$sp	$sp	-20
	jal	abs
	addi	$sp	$sp	20
							########	FunRet_~7 = retValue
	move	$s3	$v0
							########	protect env
							########	push 22
	li	$a1	22
							########	call abs
	addi	$sp	$sp	-24
	jal	abs
	addi	$sp	$sp	24
							########	FunRet_~8 = retValue
	move	$s0	$v0
							########	protect env
							########	push FunRet_~5
	move	$a1	$s1
							########	push FunRet_~6
	move	$a2	$s2
							########	push FunRet_~7
	move	$a3	$s3
							########	push FunRet_~8
							########	call sum4
	addi	$sp	$sp	-28
							########	func sum4()
							########	para in func: a
							########	para in func: b
							########	para in func: c
							########	para in func: d
							########	+		a		b		~3
	add	$t0	$a1	$a2
							########	+		~3		c		~3
	add	$t0	$t0	$a3
							########	+		~3		d		~3
	add	$t0	$t0	$s0
							########	func sum4 -> Retreturn  retValue:~3
	move	$v0	$t0
	addi	$sp	$sp	28
							########	FunRet_~9 = retValue
	move	$s0	$v0
							########	printf FunRet_~9
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
							########	Label end
end:
