.data
	newline:	.asciiz "\n"
.text
	jal	main
	j	end
########	const int ia = 1
########	const char ca = 'a'
########	var int ga
########	Label main
main:
	sw	$ra	-4	($sp)
########	var char c
########	=		'a'		c
	li	$t0	97
	sw	$t0	-12	($sp)
########	printf c
	lw	$t0	-12	($sp)
	move	$a0	$t0
	li	$v0	11
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	+		c		1		~0
	lw	$t0	-12	($sp)
	li	$t1	1
	add	$t2	$t0	$t1
	sw	$t2	-16	($sp)
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
