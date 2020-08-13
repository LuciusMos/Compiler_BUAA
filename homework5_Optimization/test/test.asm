.data
	newline:	.asciiz "\n"
.text
	jal	main
	j	end
########	func main()
main:
########	/		x		y		~0
	lw	$t8	-12	($sp)
	lw	$t9	-16	($sp)
	div 	$t8	$t9
	mflo	$t0
########	*		~0		y		~0
	lw	$t9	-16	($sp)
	mult	$t0	$t9
	mflo	$t0
########	-		x		~0		~0
	lw	$t8	-12	($sp)
	sub	$t0	$t8	$t0
########	=		~0		x
	sw	$t0	-12	($sp)
########	func main -> NonRetreturn
	jr	$ra
########	func main -> NonRetreturn
	jr	$ra
########	Label end
end:
