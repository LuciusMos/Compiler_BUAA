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
########	[]=		1		0		gc
	li	$t0	1
	sw	$t0	-16	($gp)
########	[]=		2		1		gc
	li	$t0	2
	sw	$t0	-12	($gp)
########	=[]		gc		0		~0
	lw	$t0	-16	($gp)
	sw	$t0	-12	($sp)
########	=[]		gc		1		~1
	lw	$t0	-12	($gp)
	sw	$t0	-16	($sp)
########	+		~0		~1		~0
	lw	$t0	-12	($sp)
	lw	$t1	-16	($sp)
	add	$t2	$t0	$t1
	sw	$t2	-12	($sp)
########	[]=		~0		1		gc
	lw	$t0	-12	($sp)
	sw	$t0	-12	($gp)
########	=[]		gc		1		~2
	lw	$t0	-12	($gp)
	sw	$t0	-20	($sp)
########	printf ~2
	lw	$t0	-20	($sp)
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
