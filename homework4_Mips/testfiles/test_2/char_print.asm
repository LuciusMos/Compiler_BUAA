.data
	newline:	.asciiz "\n"
.text
	jal	main
	j	end
########	Label main
main:
	sw	$ra	-4	($sp)
########	[]=		'a'		0		global_char_array_1
	li	$t0	97
	li	$t1	0
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-20	($t1)
########	=[]		global_char_array_1		0		~0
	li	$t0	0
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-20	($t0)
	sw	$t1	-12	($sp)
########	printf ~0
	lw	$t0	-12	($sp)
	move	$a0	$t0
	li	$v0	11
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	=		'b'		global_char_1
	li	$t0	98
	sw	$t0	-24	($gp)
########	printf global_char_1
	lw	$t0	-24	($gp)
	move	$a0	$t0
	li	$v0	11
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
