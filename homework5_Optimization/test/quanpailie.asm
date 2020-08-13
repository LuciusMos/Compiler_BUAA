.data
	string0:	.asciiz "\\n"
	newline:	.asciiz "\n"
.text
	jal	main
	j	end
########	func swap()
swap:
########	var int temp
########	=[]		arr		i		~0
	move	$t8	$a1
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-20	($t8)
	sw	$t9	-24	($sp)
########	=		~0		temp
	lw	$t8	-24	($sp)
	sw	$t8	-20	($sp)
########	=[]		arr		j		~1
	move	$t8	$a2
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-20	($t8)
	sw	$t9	-28	($sp)
########	[]=		~1		i		arr
	lw	$t8	-28	($sp)
	move	$t9	$a1
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-20	($t9)
########	[]=		temp		j		arr
	lw	$t8	-20	($sp)
	move	$t9	$a2
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-20	($t9)
########	func swap -> NonRetreturn
	jr	$ra
########	func printArray()
printArray:
########	var int i
########	=		0		i
	li	$t8	0
	sw	$t8	-16	($sp)
########	Label for_0_begin
for_0_begin:
########	bge		i		len		for_0_end
	lw	$t8	-16	($sp)
	bge	$t8	$a1	for_0_end
########	=[]		arr		i		~2
	lw	$t8	-16	($sp)
	sll	$t8	$t8	2
	add	$t8	$t8	$gp
	lw	$t9	-20	($t8)
	sw	$t9	-20	($sp)
########	printf ~2
	lw	$a0	-20	($sp)
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	+		i		1		~3
	lw	$t8	-16	($sp)
	li	$t9	1
	add	$t8	$t8	$t9
	sw	$t8	-24	($sp)
########	=		~3		i
	lw	$t8	-24	($sp)
	sw	$t8	-16	($sp)
########	j for_0_begin
	j	for_0_begin
########	Label for_0_end
for_0_end:
########	printf string0
	la	$a0	string0
	li	$v0	4
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	func printArray -> NonRetreturn
	jr	$ra
########	func perm()
perm:
	sw	$ra	-4	($sp)
########	var int i
########	bne		p		q		if_0_end
	bne	$a1	$a2	if_0_end
########	+		q		1		~4
	li	$t9	1
	add	$t8	$a2	$t9
	sw	$t8	-24	($sp)
########	protect env
	sw	$a1	-12	($sp)
	sw	$a2	-16	($sp)
########	push ~4
	lw	$a1	-24	($sp)
########	call printArray
	sw	$sp	-32	($sp)
	subi	$sp	$sp	24
	jal	printArray
	lw	$sp	-8	($sp)
	lw	$a1	-12	($sp)
	lw	$a2	-16	($sp)
########	Label if_0_end
if_0_end:
########	=		p		i
	sw	$a1	-20	($sp)
########	Label for_1_begin
for_1_begin:
########	bgt		i		q		for_1_end
	lw	$t8	-20	($sp)
	bgt	$t8	$a2	for_1_end
########	protect env
	sw	$a1	-12	($sp)
	sw	$a2	-16	($sp)
########	push p
	move	$a1	$a1
########	push i
	lw	$a2	-20	($sp)
########	call swap
	sw	$sp	-32	($sp)
	subi	$sp	$sp	24
	jal	swap
	lw	$sp	-8	($sp)
	lw	$a1	-12	($sp)
	lw	$a2	-16	($sp)
########	+		p		1		~5
	li	$t9	1
	add	$t8	$a1	$t9
	sw	$t8	-28	($sp)
########	protect env
	sw	$a1	-12	($sp)
	sw	$a2	-16	($sp)
########	push ~5
	lw	$a1	-28	($sp)
########	push q
	move	$a2	$a2
########	call perm
	sw	$sp	-36	($sp)
	subi	$sp	$sp	28
	jal	perm
	lw	$sp	-8	($sp)
	lw	$a1	-12	($sp)
	lw	$a2	-16	($sp)
########	protect env
	sw	$a1	-12	($sp)
	sw	$a2	-16	($sp)
########	push p
	move	$a1	$a1
########	push i
	lw	$a2	-20	($sp)
########	call swap
	sw	$sp	-36	($sp)
	subi	$sp	$sp	28
	jal	swap
	lw	$sp	-8	($sp)
	lw	$a1	-12	($sp)
	lw	$a2	-16	($sp)
########	+		i		1		~6
	lw	$t8	-20	($sp)
	li	$t9	1
	add	$t8	$t8	$t9
	sw	$t8	-32	($sp)
########	=		~6		i
	lw	$t8	-32	($sp)
	sw	$t8	-20	($sp)
########	j for_1_begin
	j	for_1_begin
########	Label for_1_end
for_1_end:
########	func perm -> NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	func main()
main:
	sw	$ra	-4	($sp)
########	[]=		1		0		arr
	li	$t8	1
	li	$t9	0
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-20	($t9)
########	[]=		2		1		arr
	li	$t8	2
	li	$t9	1
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-20	($t9)
########	[]=		3		2		arr
	li	$t8	3
	li	$t9	2
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-20	($t9)
########	[]=		4		3		arr
	li	$t8	4
	li	$t9	3
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-20	($t9)
########	[]=		5		4		arr
	li	$t8	5
	li	$t9	4
	sll	$t9	$t9	2
	add	$t9	$t9	$gp
	sw	$t8	-20	($t9)
########	protect env
########	push 0
	li	$a1	0
########	push 4
	li	$a2	4
########	call perm
	sw	$sp	-16	($sp)
	subi	$sp	$sp	8
	jal	perm
	lw	$sp	-8	($sp)
########	func main -> NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	Label end
end:
