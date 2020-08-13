.data
	newline:	.asciiz "\n"
.text
	jal	main
	j	end
########	func char retChar()
retChar:
	sw	$ra	-4	($sp)
########	Retreturn  retValue:'k'
	lw	$ra	-4	($sp)
	li	$v0	107
	jr	$ra
########	Label main
main:
	sw	$ra	-4	($sp)
########	call retChar
	sw	$sp	-16	($sp)
	subi	$sp	$sp	8
	jal	retChar
	lw	$sp	-8	($sp)
########	~0 = retValue
	sw	$v0	-12	($sp)
########	printf ~0
	lw	$t0	-12	($sp)
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
