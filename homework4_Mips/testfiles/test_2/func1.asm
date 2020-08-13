.data
	string0:	.asciiz "oooo\\n"
	newline:	.asciiz "\n"
.text
	jal	main
	j	end
########	const int ia = 1
########	const char ca = 'a'
########	var int ga
########	func void myprint()
myprint:
	sw	$ra	-4	($sp)
########	scanf gd
	li	$v0	12
	syscall
	sw	$v0	-20	($gp)
########	printf gd
	lw	$t0	-20	($gp)
	move	$a0	$t0
	li	$v0	11
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf string0
	la	$a0	string0
	li	$v0	4
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	func int fun1()
fun1:
	sw	$ra	-4	($sp)
########	+		p1		p2		~0
	lw	$t0	-12	($sp)
	lw	$t1	-16	($sp)
	add	$t2	$t0	$t1
	sw	$t2	-24	($sp)
########	+		~0		p3		~0
	lw	$t0	-24	($sp)
	lw	$t1	-20	($sp)
	add	$t2	$t0	$t1
	sw	$t2	-24	($sp)
########	Retreturn  retValue:~0
	lw	$ra	-4	($sp)
	lw	$v0	-24	($sp)
	jr	$ra
########	Label main
main:
	sw	$ra	-4	($sp)
########	var int ca
########	printf ca
	lw	$t0	-12	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	push 1
	li	$t0	1
	sw	$t0	-24	($sp)
########	push 2
	li	$t0	2
	sw	$t0	-28	($sp)
########	push 3
	li	$t0	3
	sw	$t0	-32	($sp)
########	call fun1
	sw	$sp	-20	($sp)
	subi	$sp	$sp	12
	jal	fun1
	lw	$sp	-8	($sp)
########	~1 = retValue
	sw	$v0	-16	($sp)
########	push ca
	lw	$t0	-12	($sp)
	sw	$t0	-28	($sp)
########	push 2
	li	$t0	2
	sw	$t0	-32	($sp)
########	push ~1
	lw	$t0	-16	($sp)
	sw	$t0	-36	($sp)
########	call fun1
	sw	$sp	-24	($sp)
	subi	$sp	$sp	16
	jal	fun1
	lw	$sp	-8	($sp)
########	~2 = retValue
	sw	$v0	-20	($sp)
########	=		~2		gb
	lw	$t0	-20	($sp)
	sw	$t0	-8	($gp)
########	printf gb
	lw	$t0	-8	($gp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	call myprint
	sw	$sp	-28	($sp)
	subi	$sp	$sp	20
	jal	myprint
	lw	$sp	-8	($sp)
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	Label end
end:
