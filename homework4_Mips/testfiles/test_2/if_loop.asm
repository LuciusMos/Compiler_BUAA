.data
	newline:	.asciiz "\n"
.text
	move	$gp	$sp
	subi	$sp	$sp	20
	move	$fp	$sp
	j	main
########	Label main
main:
########	var char char_c
########	=		98		char_c
	li	$t0	98
	sw	$t0	-4	($fp)
########	printf char_c
	lw	$t0	-4	($fp)
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
