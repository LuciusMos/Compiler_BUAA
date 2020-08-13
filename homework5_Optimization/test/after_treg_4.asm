.data
	newline:	.asciiz "\n"
.text
	jal	main
	j	end
########	func main()
main:
########	[]=		1		0		str
	li	$t8	1
	li	$t9	0
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$t8	-48	($t9)
########	[]=		2		1		abc
	li	$t8	2
	li	$t9	1
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$t8	-88	($t9)
########	[]=		3		2		str
	li	$t8	3
	li	$t9	2
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$t8	-48	($t9)
########	[]=		4		3		abc
	li	$t8	4
	li	$t9	3
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$t8	-88	($t9)
########	[]=		5		4		str
	li	$t8	5
	li	$t9	4
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$t8	-48	($t9)
########	[]=		6		5		abc
	li	$t8	6
	li	$t9	5
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$t8	-88	($t9)
########	=[]		str		4		~0
	li	$t8	4
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t0	-48	($t8)
########	=[]		abc		~0		~0
	move	$t8	$t0
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t0	-88	($t8)
########	[]=		7		~0		str
	li	$t8	7
	move	$t9	$t0
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$t8	-48	($t9)
########	=[]		str		2		~1
	li	$t8	2
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t1	-48	($t8)
########	=[]		abc		~1		~1
	move	$t8	$t1
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t1	-88	($t8)
########	=[]		str		~1		~1
	move	$t8	$t1
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t1	-48	($t8)
########	=[]		abc		~1		~1
	move	$t8	$t1
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t1	-88	($t8)
########	=[]		str		~1		~1
	move	$t8	$t1
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t1	-48	($t8)
########	=[]		str		2		~2
	li	$t8	2
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t2	-48	($t8)
########	=[]		abc		~2		~2
	move	$t8	$t2
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t2	-88	($t8)
########	=[]		str		~2		~2
	move	$t8	$t2
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t2	-48	($t8)
########	=[]		abc		~2		~2
	move	$t8	$t2
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t2	-88	($t8)
########	=[]		str		~2		~2
	move	$t8	$t2
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t2	-48	($t8)
########	=[]		str		2		~3
	li	$t8	2
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t3	-48	($t8)
########	=[]		abc		~3		~3
	move	$t8	$t3
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t3	-88	($t8)
########	=[]		str		~3		~3
	move	$t8	$t3
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t3	-48	($t8)
########	=[]		abc		~3		~3
	move	$t8	$t3
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t3	-88	($t8)
########	+		~2		~3		~2
	add	$t2	$t2	$t3
########	[]=		~2		~1		abc
	move	$t9	$t1
	sll	$t9	$t9	2
	add	$t9	$t9	$sp
	sw	$t2	-88	($t9)
########	=[]		abc		1		~4
	li	$t8	1
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t4	-88	($t8)
########	+		5		~4		~4
	li	$t8	5
	add	$t4	$t8	$t4
########	-		~4		5		~4
	li	$t9	5
	sub	$t4	$t4	$t9
########	=[]		str		~4		~4
	move	$t8	$t4
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t4	-48	($t8)
########	*		6		~4		~4
	li	$t8	6
	mult	$t8	$t4
	mflo	$t4
########	/		~4		2		~4
	li	$t9	2
	div 	$t4	$t9
	mflo	$t4
########	/		~4		3		~4
	li	$t9	3
	div 	$t4	$t9
	mflo	$t4
########	=[]		abc		~4		~4
	move	$t8	$t4
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t4	-88	($t8)
########	*		1		~4		~4
	li	$t8	1
	mult	$t8	$t4
	mflo	$t4
########	=[]		str		~4		~4
	move	$t8	$t4
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t4	-48	($t8)
########	+		4		~4		~4
	li	$t8	4
	add	$t4	$t8	$t4
########	=[]		str		2		~5
	li	$t8	2
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t5	-48	($t8)
########	=[]		abc		~5		~5
	move	$t8	$t5
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t5	-88	($t8)
########	-		~4		~5		~4
	sub	$t4	$t4	$t5
########	=[]		abc		~4		~4
	move	$t8	$t4
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t4	-88	($t8)
########	=[]		str		~4		~4
	move	$t8	$t4
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t4	-48	($t8)
########	=[]		abc		~4		~4
	move	$t8	$t4
	sll	$t8	$t8	2
	add	$t8	$t8	$sp
	lw	$t4	-88	($t8)
########	printf ~4
	move	$a0	$t4
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	func main -> NonRetreturn
	jr	$ra
########	func main -> NonRetreturn
	jr	$ra
########	Label end
end:
