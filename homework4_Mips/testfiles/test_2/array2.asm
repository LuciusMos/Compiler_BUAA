.data
	newline:	.asciiz "\n"
.text
	jal	main
	j	end
########	Label main
main:
	sw	$ra	-4	($sp)
########	var int k
########	=		1		k
	li	$t0	1
	sw	$t0	-12	($sp)
########	[]=		3		k		a
	li	$t0	3
	lw	$t1	-12	($sp)
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-12	($t1)
########	=[]		a		k		~0
	lw	$t0	-12	($sp)
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-12	($t0)
	sw	$t1	-16	($sp)
########	printf ~0
	lw	$t0	-16	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	Label end
end:
