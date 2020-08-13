.data
	newline:	.asciiz "\n"
.text
	j	main
########	Label main
main:
########	var char char_c
########	=		98		char_c
	li	$t0	98
	sw	$t0	-4	($sp)
########	printf char_c
	lw	$t0	-4	($sp)
	move	$a0	$t0
	li	$v0	11
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=		98		gd
	li	$t0	98
	sw	$t0	-20	($gp)
########	printf gd
	lw	$t0	-20	($gp)
	move	$a0	$t0
	li	$v0	11
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	printf 97
	li	$t0	97
	move	$a0	$t0
	li	$v0	11
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=		8		ga
	li	$t0	8
	sw	$t0	-4	($gp)
########	=		2		gb
	li	$t0	2
	sw	$t0	-8	($gp)
########	[]=		5		0		gc
	li	$t0	5
	sw	$t0	-16	($gp)
########	[]=		0		1		gc
	li	$t0	0
	sw	$t0	-12	($gp)
########	+		ga		gb		~0
	lw	$t0	-4	($gp)
	lw	$t1	-8	($gp)
	add	$t2	$t0	$t1
	sw	$t2	-8	($sp)
########	=[]		gc		0		~1
	lw	$t0	-16	($gp)
	sw	$t0	-12	($sp)
########	+		~0		~1		~0
	lw	$t0	-8	($sp)
	lw	$t1	-12	($sp)
	add	$t2	$t0	$t1
	sw	$t2	-8	($sp)
########	=[]		gc		1		~2
	lw	$t0	-12	($gp)
	sw	$t0	-16	($sp)
########	+		~0		~2		~0
	lw	$t0	-8	($sp)
	lw	$t1	-16	($sp)
	add	$t2	$t0	$t1
	sw	$t2	-8	($sp)
########	printf ~0
	lw	$t0	-8	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
