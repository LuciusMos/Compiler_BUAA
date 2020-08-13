.data
	string0:	.asciiz "aaaaa"
	newline:	.asciiz "\n"
.text
	move	$gp	$sp
	subi	$sp	$sp	16
	move	$fp	$sp
	j	main
########	Label main:
main:
########	var int a
	subi	$sp	$sp	28
########	scanf c
	li	$v0	5
	syscall
	sw	$v0	-8	($fp)
########	=		1		ga
	li	$t0	1
	sw	$t0	-4	($gp)
########	=		1		gb
	li	$t0	1
	sw	$t0	-8	($gp)
########	=		2		a
	li	$t0	2
	sw	$t0	-4	($fp)
########	[]=		5		0		gc
	li	$t0	5
	sw	$t0	-16	($gp)
########	-		0		ga		~0
	li	$t0	0
	lw	$t1	-4	($gp)
	sub	$t2	$t0	$t1
	sw	$t2	-32	($fp)
########	=[]		gc		0		~1
	lw	$t0	-16	($gp)
	sw	$t0	-36	($fp)
########	*		a		~1		~1
	lw	$t0	-4	($fp)
	lw	$t1	-36	($fp)
	mult	$t0	$t1
	mflo	$t2
	sw	$t2	-36	($fp)
########	+		~0		~1		~0
	lw	$t0	-32	($fp)
	lw	$t1	-36	($fp)
	add	$t2	$t0	$t1
	sw	$t2	-32	($fp)
########	-		~0		c		~0
	lw	$t0	-32	($fp)
	lw	$t1	-8	($fp)
	sub	$t2	$t0	$t1
	sw	$t2	-32	($fp)
########	[]=		~0		2		b
	lw	$t0	-32	($fp)
	sw	$t0	-20	($fp)
########	=[]		b		2		~2
	lw	$t0	-20	($fp)
	sw	$t0	-40	($fp)
########	=		~2		a
	lw	$t0	-40	($fp)
	sw	$t0	-4	($fp)
########	printf string0
	la	$a0	string0
	li	$v0	4
	syscall
########	printf newline
	la	$a0	newline
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
