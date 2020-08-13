.data
	string0:	.asciiz "_begini = "
	string1:	.asciiz "Let's have fun."
	string2:	.asciiz "My stunum is : "
	string3:	.asciiz "17060000"
	string4:	.asciiz "a is : "
	string5:	.asciiz "Congratulations"
	newline:	.asciiz "\n"
.text
	move	$gp	$sp
	move	$fp	$sp
	j	main
########	Label main:
main:
########	var int a
	subi	$sp	$sp	8
########	printf string0
	la	$a0	string0
	li	$v0	4
	syscall
########	printf _begini
	li	$t0	0
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	scanf i
	li	$v0	5
	syscall
	sw	$v0	-8	($fp)
########	=		i		a
	lw	$t0	-8	($fp)
	sw	$t0	-4	($fp)
########	printf a
	lw	$t0	-4	($fp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=		-6		a
	li	$t0	-6
	sw	$t0	-4	($fp)
########	printf a
	lw	$t0	-4	($fp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	+		a		18		~0
	lw	$t0	-4	($fp)
	li	$t1	18
	add	$t2	$t0	$t1
	sw	$t2	-12	($fp)
########	+		~0		-6		~1
	lw	$t0	-12	($fp)
	li	$t1	-6
	add	$t2	$t0	$t1
	sw	$t2	-16	($fp)
########	=		~1		a
	lw	$t0	-16	($fp)
	sw	$t0	-4	($fp)
########	printf a
	lw	$t0	-4	($fp)
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
########	=		1		a
	li	$t0	1
	sw	$t0	-4	($fp)
########	+		a		1700		~2
	lw	$t0	-4	($fp)
	li	$t1	1700
	add	$t2	$t0	$t1
	sw	$t2	-20	($fp)
########	+		~2		5		~3
	lw	$t0	-20	($fp)
	li	$t1	5
	add	$t2	$t0	$t1
	sw	$t2	-24	($fp)
########	*		~3		1000		~4
	lw	$t0	-24	($fp)
	li	$t1	1000
	mult	$t0	$t1
	mflo	$t2
	sw	$t2	-28	($fp)
########	=		~4		a
	lw	$t0	-28	($fp)
	sw	$t0	-4	($fp)
########	printf a
	lw	$t0	-4	($fp)
	move	$a0	$t0
	li	$v0	1
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
########	printf string3
	la	$a0	string3
	li	$v0	4
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=		-54		a
	li	$t0	-54
	sw	$t0	-4	($fp)
########	printf string4
	la	$a0	string4
	li	$v0	4
	syscall
########	printf a
	lw	$t0	-4	($fp)
	move	$a0	$t0
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
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
