.data
	newline:	.asciiz "\n"
.text
	jal	main
	j	end
########	func fun()
fun:
########	para in func: n
########	func fun -> Retreturn  retValue:n
	move	$v0	$a1
	jr	$ra
########	func main()
main:
	sw	$ra	-4	($sp)
########	protect env
########	push 3
	li	$a1	3
########	call fun
	sw	$sp	-20	($sp)
	addi	$sp	$sp	-12
	jal	fun
	lw	$sp	-8	($sp)
########	FunRet_~0 = retValue
	move	$s0	$v0
########	=		FunRet_~0		a
	sw	$s0	-12	($sp)
########	func main -> NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	Label end
end:

