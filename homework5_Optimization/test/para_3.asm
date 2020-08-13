.data
	newline:	.asciiz "\n"
.text
	jal	main
	j	end
########	func f()
f:
	sw	$ra	-4	($sp)
########	const int con = 1
########	var int k
########	-		a		1		~0
	li	$t9	1
	sub	$t8	$a1	$t9
	sw	$t8	-36	($sp)
########	protect env
	sw	$a1	-12	($sp)
	sw	$a2	-16	($sp)
########	push ~0
	lw	$a1	-36	($sp)
########	push b
	move	$a2	$a2
########	call f
	sw	$sp	-44	($sp)
	subi	$sp	$sp	36
	jal	f
	lw	$sp	-8	($sp)
	lw	$a1	-12	($sp)
	lw	$a2	-16	($sp)
########	~1 = retValue
	sw	$v0	-40	($sp)
########	func f -> Retreturn  retValue:~1
	lw	$ra	-4	($sp)
	lw	$v0	-40	($sp)
	jr	$ra
########	func main()
main:
	sw	$ra	-4	($sp)
########	protect env
########	push 666
	li	$a1	666
########	push 520
	li	$a2	520
########	call f
	sw	$sp	-16	($sp)
	subi	$sp	$sp	8
	jal	f
	lw	$sp	-8	($sp)
########	~2 = retValue
	sw	$v0	-12	($sp)
########	func main -> NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	Label end
end:
