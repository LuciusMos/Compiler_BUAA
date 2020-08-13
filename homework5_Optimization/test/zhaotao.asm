.data
	newline:	.asciiz "\n"
.text
	jal	main
	j	end
							########	func add()
add:
							########	para in func: x
							########	para in func: y
							########	para in func: a
							########	para in func: b
							########	para in func: c
							########	para in func: d
							########	beq		0		1		if_0_end
	li	$t8	0
	beq	$t8	1	if_0_end
							########	+		x		y		~0
	add	$t0	$a1	$a2
							########	+		~0		a		~0
	add	$t0	$t0	$a3
							########	+		~0		b		~0
	add	$t0	$t0	$s1
							########	+		~0		c		~0
	add	$t0	$t0	$s2
							########	+		~0		d		~0
	add	$t0	$t0	$s0
							########	func add -> Retreturn  retValue:~0
	move	$v0	$t0
	jr	$ra
							########	Label if_0_end
if_0_end:
							########	func fun()
fun:
							########	para in func: c
							########	func fun -> Retreturn  retValue:c
	move	$v0	$a1

							########	func main()
main:
	sw	$ra	-4	($sp)
							########	=		2		x
	li	$s1	2
							########	=		1		y
	li	$s0	1
							########	*		x		y		~1
	mult	$s1	$s0
	mflo	$t1
							########	-		0		~1		~1
	li	$t8	0
	sub	$t1	$t8	$t1
							########	+		x		1		~2
	addi	$t2	$s1	1
							########	+		~2		y		~2
	add	$t2	$t2	$s0
							########	/		x		y		~3
	div 	$s1	$s0
	mflo	$t3
							########	+		x		y		~4
	add	$t4	$s1	$s0
							########	*		y		2		~5
	li	$t9	2
	mult	$s0	$t9
	mflo	$t0
							########	-		x		~5		~5
	sub	$t0	$s1	$t0
							########	-		~5		x		~5
	sub	$t0	$t0	$s1
							########	*		0		y		~6
	sw	$t1	-20	($sp)
	li	$t8	0
	mult	$t8	$s0
	mflo	$t1
							########	+		x		~6		~6
	add	$t1	$s1	$t1
							########	protect env
							########	push ~1
	lw	$a1	-20	($sp)
							########	push ~2
	move	$a2	$t2
							########	push ~3
	move	$a3	$t3
							########	push ~4
	move	$s1	$t4
							########	push ~5
	move	$s2	$t0
							########	push ~6
	move	$s0	$t1
							########	call add
	addi	$sp	$sp	-40
	jal	add
	addi	$sp	$sp	40
							########	FunRet_~7 = retValue
	move	$s0	$v0
							########	printf FunRet_~7
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
