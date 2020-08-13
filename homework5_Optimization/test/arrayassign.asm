.data
	newline:	.asciiz "\n"
.text
	jal	main
	j	end
########	func main()
main:
########	[]=		2		1		arr
	li	$t8	2
	li	$t9	1
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$t8	-428	($t9)
########	[]=		3		2		arr
	li	$t8	3
	li	$t9	2
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$t8	-428	($t9)
########	[]=		4		3		arr
	li	$t8	4
	li	$t9	3
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$t8	-428	($t9)
########	[]=		5		4		arr
	li	$t8	5
	li	$t9	4
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$t8	-428	($t9)
########	[]=		6		5		arr
	li	$t8	6
	li	$t9	5
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$t8	-428	($t9)
########	[]=		7		6		arr
	li	$t8	7
	li	$t9	6
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$t8	-428	($t9)
########	[]=		8		7		arr
	li	$t8	8
	li	$t9	7
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$t8	-428	($t9)
########	[]=		9		8		arr
	li	$t8	9
	li	$t9	8
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$t8	-428	($t9)
########	[]=		10		9		arr
	li	$t8	10
	li	$t9	9
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$t8	-428	($t9)
########	[]=		11		10		arr
	li	$t8	11
	li	$t9	10
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$t8	-428	($t9)
########	[]=		12		11		arr
	li	$t8	12
	li	$t9	11
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$t8	-428	($t9)
########	=[]		arr		1		~0
	li	$t8	1
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-428	($t8)
	sw	$t9	-432	($sp)
########	=[]		arr		~0		~1
	lw	$t8	-432	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-428	($t8)
	sw	$t9	-436	($sp)
########	=[]		arr		~1		~2
	lw	$t8	-436	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-428	($t8)
	sw	$t9	-440	($sp)
########	=[]		arr		~2		~3
	lw	$t8	-440	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-428	($t8)
	sw	$t9	-444	($sp)
########	=[]		arr		~3		~4
	lw	$t8	-444	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-428	($t8)
	sw	$t9	-448	($sp)
########	=[]		arr		~4		~5
	lw	$t8	-448	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-428	($t8)
	sw	$t9	-452	($sp)
########	=[]		arr		~5		~6
	lw	$t8	-452	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-428	($t8)
	sw	$t9	-456	($sp)
########	=[]		arr		~6		~7
	lw	$t8	-456	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-428	($t8)
	sw	$t9	-460	($sp)
########	=[]		arr		~7		~8
	lw	$t8	-460	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-428	($t8)
	sw	$t9	-464	($sp)
########	=[]		arr		~8		~9
	lw	$t8	-464	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-428	($t8)
	sw	$t9	-468	($sp)
########	=[]		arr		~9		~10
	lw	$t8	-468	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t9	-428	($t8)
	sw	$t9	-472	($sp)
########	=		~10		a
	lw	$t8	-472	($sp)
	sw	$t8	-16	($sp)
########	printf a
	lw	$a0	-16	($sp)
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	func main -> NonRetreturn
	jr	$ra
########	Label end
end:
