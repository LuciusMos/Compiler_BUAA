.data
	newline:	.asciiz "\n"
.text
	jal	main
	j	end
							########	func add()
add:
							########	para in func: a1
							########	para in func: a2
							########	para in func: a3
							########	para in func: a4
							########	para in func: a5
	lw	$t0	-32	($sp)
							########	+		a1		a2		~0
	add	$t0	$a1	$a2
							########	+		~0		a3		~0
	add	$t0	$t0	$a3
							########	+		~0		a4		~0
	add	$t0	$t0	$s1
							########	+		~0		a5		~0
	add	$t0	$t0	$s0
							########	func add -> Retreturn  retValue:~0
	move	$v0	$t0

							########	func main()
main:
	sw	$ra	-4	($sp)
							########	=		2		x
	li	$s1	2
							########	=		1		y
	li	$s0	1
	lw	$t1	-20	($sp)
							########	*		x		y		~1
	mult	$s1	$s0
	mflo	$t1
	lw	$t2	-24	($sp)
							########	-		x		y		~2
	sub	$t2	$s1	$s0
	lw	$t0	-28	($sp)
	sw	$t0	-32	($sp)
							########	/		x		y		~3
	div 	$s1	$s0
	mflo	$t0
	lw	$t1	-32	($sp)
	sw	$t1	-20	($sp)
							########	*		x		y		~4
	mult	$s1	$s0
	mflo	$t1
							########	*		~4		x		~4
	mult	$t1	$s1
	mflo	$t1
	lw	$t2	-36	($sp)
	sw	$t2	-24	($sp)
							########	*		y		5		~5
	li	$t9	5
	mult	$s0	$t9
	mflo	$t2
							########	-		x		~5		~5
	sub	$t2	$s1	$t2
							########	protect env
	lw	$t0	-20	($sp)
	sw	$t0	-28	($sp)
							########	push ~1
	move	$a1	$t0
	lw	$t1	-24	($sp)
	sw	$t1	-32	($sp)
							########	push ~2
	move	$a2	$t1
	lw	$t2	-28	($sp)
	sw	$t2	-36	($sp)
							########	push ~3
	move	$a3	$t2
	lw	$t0	-32	($sp)
	sw	$t0	-20	($sp)
							########	push ~4
	move	$s1	$t0
	lw	$t1	-36	($sp)
	sw	$t1	-24	($sp)
							########	push ~5
	move	$s0	$t1
							########	call add
	addi	$sp	$sp	-36
							########	func add()
							########	para in func: a1
							########	para in func: a2
							########	para in func: a3
							########	para in func: a4
							########	para in func: a5
	lw	$t2	-32	($sp)
	sw	$t2	-28	($sp)
							########	+		a1		a2		~0
	add	$t2	$a1	$a2
							########	+		~0		a3		~0
	add	$t2	$t2	$a3
							########	+		~0		a4		~0
	add	$t2	$t2	$s1
							########	+		~0		a5		~0
	add	$t2	$t2	$s0
							########	func add -> Retreturn  retValue:~0
	move	$v0	$t2
	addi	$sp	$sp	36
							########	FunRet_~6 = retValue
	move	$s0	$v0
							########	printf FunRet_~6
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
