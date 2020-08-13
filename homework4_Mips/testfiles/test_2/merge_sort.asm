.data
	string0:	.asciiz "17373248"
	newline:	.asciiz "\n"
.text
	jal	main
	j	end
########	func void merge()
merge:
	sw	$ra	-4	($sp)
########	var int i
########	=		0		i
	li	$t0	0
	sw	$t0	-28	($sp)
########	=		0		j
	li	$t0	0
	sw	$t0	-32	($sp)
########	=		s1		k
	lw	$t0	-12	($sp)
	sw	$t0	-36	($sp)
########	Label while_0_begin
while_0_begin:
########	bge		i		l1		while_0_end
	lw	$t0	-28	($sp)
	lw	$t1	-16	($sp)
	bge	$t0	$t1	while_0_end
########	bge		j		l2		if_0_end
	lw	$t0	-32	($sp)
	lw	$t1	-24	($sp)
	bge	$t0	$t1	if_0_end
########	+		s1		i		~0
	lw	$t0	-12	($sp)
	lw	$t1	-28	($sp)
	add	$t2	$t0	$t1
	sw	$t2	-40	($sp)
########	=[]		arr		~0		~0
	lw	$t0	-40	($sp)
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-4000	($t0)
	sw	$t1	-40	($sp)
########	+		s2		j		~1
	lw	$t0	-20	($sp)
	lw	$t1	-32	($sp)
	add	$t2	$t0	$t1
	sw	$t2	-44	($sp)
########	=[]		arr		~1		~1
	lw	$t0	-44	($sp)
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-4000	($t0)
	sw	$t1	-44	($sp)
########	ble		~0		~1		if_1_end
	lw	$t0	-40	($sp)
	lw	$t1	-44	($sp)
	ble	$t0	$t1	if_1_end
########	+		s2		j		~2
	lw	$t0	-20	($sp)
	lw	$t1	-32	($sp)
	add	$t2	$t0	$t1
	sw	$t2	-48	($sp)
########	=[]		arr		~2		~2
	lw	$t0	-48	($sp)
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-4000	($t0)
	sw	$t1	-48	($sp)
########	[]=		~2		k		tmp
	lw	$t0	-48	($sp)
	lw	$t1	-36	($sp)
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-8000	($t1)
########	+		j		1		~3
	lw	$t0	-32	($sp)
	li	$t1	1
	add	$t2	$t0	$t1
	sw	$t2	-52	($sp)
########	=		~3		j
	lw	$t0	-52	($sp)
	sw	$t0	-32	($sp)
########	j else_1_end
	j	else_1_end
########	Label if_1_end
if_1_end:
########	+		s1		i		~4
	lw	$t0	-12	($sp)
	lw	$t1	-28	($sp)
	add	$t2	$t0	$t1
	sw	$t2	-56	($sp)
########	=[]		arr		~4		~4
	lw	$t0	-56	($sp)
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-4000	($t0)
	sw	$t1	-56	($sp)
########	[]=		~4		k		tmp
	lw	$t0	-56	($sp)
	lw	$t1	-36	($sp)
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-8000	($t1)
########	+		i		1		~5
	lw	$t0	-28	($sp)
	li	$t1	1
	add	$t2	$t0	$t1
	sw	$t2	-60	($sp)
########	=		~5		i
	lw	$t0	-60	($sp)
	sw	$t0	-28	($sp)
########	Label else_1_end
else_1_end:
########	+		k		1		~6
	lw	$t0	-36	($sp)
	li	$t1	1
	add	$t2	$t0	$t1
	sw	$t2	-64	($sp)
########	=		~6		k
	lw	$t0	-64	($sp)
	sw	$t0	-36	($sp)
########	j else_0_end
	j	else_0_end
########	Label if_0_end
if_0_end:
########	Label while_1_begin
while_1_begin:
########	bge		i		l1		while_1_end
	lw	$t0	-28	($sp)
	lw	$t1	-16	($sp)
	bge	$t0	$t1	while_1_end
########	+		s1		i		~7
	lw	$t0	-12	($sp)
	lw	$t1	-28	($sp)
	add	$t2	$t0	$t1
	sw	$t2	-68	($sp)
########	=[]		arr		~7		~7
	lw	$t0	-68	($sp)
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-4000	($t0)
	sw	$t1	-68	($sp)
########	[]=		~7		k		tmp
	lw	$t0	-68	($sp)
	lw	$t1	-36	($sp)
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-8000	($t1)
########	+		k		1		~8
	lw	$t0	-36	($sp)
	li	$t1	1
	add	$t2	$t0	$t1
	sw	$t2	-72	($sp)
########	=		~8		k
	lw	$t0	-72	($sp)
	sw	$t0	-36	($sp)
########	+		i		1		~9
	lw	$t0	-28	($sp)
	li	$t1	1
	add	$t2	$t0	$t1
	sw	$t2	-76	($sp)
########	=		~9		i
	lw	$t0	-76	($sp)
	sw	$t0	-28	($sp)
########	j while_1_begin
	j	while_1_begin
########	Label while_1_end
while_1_end:
########	Label else_0_end
else_0_end:
########	j while_0_begin
	j	while_0_begin
########	Label while_0_end
while_0_end:
########	Label while_2_begin
while_2_begin:
########	bge		j		l2		while_2_end
	lw	$t0	-32	($sp)
	lw	$t1	-24	($sp)
	bge	$t0	$t1	while_2_end
########	+		s2		j		~10
	lw	$t0	-20	($sp)
	lw	$t1	-32	($sp)
	add	$t2	$t0	$t1
	sw	$t2	-80	($sp)
########	=[]		arr		~10		~10
	lw	$t0	-80	($sp)
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-4000	($t0)
	sw	$t1	-80	($sp)
########	[]=		~10		k		tmp
	lw	$t0	-80	($sp)
	lw	$t1	-36	($sp)
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-8000	($t1)
########	+		k		1		~11
	lw	$t0	-36	($sp)
	li	$t1	1
	add	$t2	$t0	$t1
	sw	$t2	-84	($sp)
########	=		~11		k
	lw	$t0	-84	($sp)
	sw	$t0	-36	($sp)
########	+		j		1		~12
	lw	$t0	-32	($sp)
	li	$t1	1
	add	$t2	$t0	$t1
	sw	$t2	-88	($sp)
########	=		~12		j
	lw	$t0	-88	($sp)
	sw	$t0	-32	($sp)
########	j while_2_begin
	j	while_2_begin
########	Label while_2_end
while_2_end:
########	=		s1		i
	lw	$t0	-12	($sp)
	sw	$t0	-28	($sp)
########	Label for_0_begin
for_0_begin:
########	bge		i		k		for_0_end
	lw	$t0	-28	($sp)
	lw	$t1	-36	($sp)
	bge	$t0	$t1	for_0_end
########	=[]		tmp		i		~13
	lw	$t0	-28	($sp)
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-8000	($t0)
	sw	$t1	-92	($sp)
########	[]=		~13		i		arr
	lw	$t0	-92	($sp)
	lw	$t1	-28	($sp)
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-4000	($t1)
########	+		i		1		~14
	lw	$t0	-28	($sp)
	li	$t1	1
	add	$t2	$t0	$t1
	sw	$t2	-96	($sp)
########	=		~14		i
	lw	$t0	-96	($sp)
	sw	$t0	-28	($sp)
########	j for_0_begin
	j	for_0_begin
########	Label for_0_end
for_0_end:
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	func void inner_merge_sort()
inner_merge_sort:
	sw	$ra	-4	($sp)
########	var int tmp
########	bgt		length		1		if_2_end
	lw	$t0	-16	($sp)
	li	$t1	1
	bgt	$t0	$t1	if_2_end
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	Label if_2_end
if_2_end:
########	bne		length		2		if_3_end
	lw	$t0	-16	($sp)
	li	$t1	2
	bne	$t0	$t1	if_3_end
########	=[]		arr		start		~15
	lw	$t0	-12	($sp)
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-4000	($t0)
	sw	$t1	-28	($sp)
########	+		start		1		~16
	lw	$t0	-12	($sp)
	li	$t1	1
	add	$t2	$t0	$t1
	sw	$t2	-32	($sp)
########	=[]		arr		~16		~16
	lw	$t0	-32	($sp)
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-4000	($t0)
	sw	$t1	-32	($sp)
########	ble		~15		~16		if_4_end
	lw	$t0	-28	($sp)
	lw	$t1	-32	($sp)
	ble	$t0	$t1	if_4_end
########	=[]		arr		start		~17
	lw	$t0	-12	($sp)
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-4000	($t0)
	sw	$t1	-36	($sp)
########	=		~17		tmp
	lw	$t0	-36	($sp)
	sw	$t0	-20	($sp)
########	+		start		1		~18
	lw	$t0	-12	($sp)
	li	$t1	1
	add	$t2	$t0	$t1
	sw	$t2	-40	($sp)
########	=[]		arr		~18		~18
	lw	$t0	-40	($sp)
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-4000	($t0)
	sw	$t1	-40	($sp)
########	[]=		~18		start		arr
	lw	$t0	-40	($sp)
	lw	$t1	-12	($sp)
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-4000	($t1)
########	+		start		1		~19
	lw	$t0	-12	($sp)
	li	$t1	1
	add	$t2	$t0	$t1
	sw	$t2	-44	($sp)
########	[]=		tmp		~19		arr
	lw	$t0	-20	($sp)
	lw	$t1	-44	($sp)
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-4000	($t1)
########	Label if_4_end
if_4_end:
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	Label if_3_end
if_3_end:
########	/		length		2		~20
	lw	$t0	-16	($sp)
	li	$t1	2
	div	$t0	$t1
	mflo	$t2
	sw	$t2	-48	($sp)
########	=		~20		mid
	lw	$t0	-48	($sp)
	sw	$t0	-24	($sp)
########	push start
	lw	$t0	-12	($sp)
	sw	$t0	-60	($sp)
########	push mid
	lw	$t0	-24	($sp)
	sw	$t0	-64	($sp)
########	call inner_merge_sort
	sw	$sp	-56	($sp)
	subi	$sp	$sp	48
	jal	inner_merge_sort
	lw	$sp	-8	($sp)
########	+		start		mid		~21
	lw	$t0	-12	($sp)
	lw	$t1	-24	($sp)
	add	$t2	$t0	$t1
	sw	$t2	-52	($sp)
########	-		length		mid		~22
	lw	$t0	-16	($sp)
	lw	$t1	-24	($sp)
	sub	$t2	$t0	$t1
	sw	$t2	-56	($sp)
########	push ~21
	lw	$t0	-52	($sp)
	sw	$t0	-68	($sp)
########	push ~22
	lw	$t0	-56	($sp)
	sw	$t0	-72	($sp)
########	call inner_merge_sort
	sw	$sp	-64	($sp)
	subi	$sp	$sp	56
	jal	inner_merge_sort
	lw	$sp	-8	($sp)
########	+		start		mid		~23
	lw	$t0	-12	($sp)
	lw	$t1	-24	($sp)
	add	$t2	$t0	$t1
	sw	$t2	-60	($sp)
########	-		length		mid		~24
	lw	$t0	-16	($sp)
	lw	$t1	-24	($sp)
	sub	$t2	$t0	$t1
	sw	$t2	-64	($sp)
########	push start
	lw	$t0	-12	($sp)
	sw	$t0	-76	($sp)
########	push mid
	lw	$t0	-24	($sp)
	sw	$t0	-80	($sp)
########	push ~23
	lw	$t0	-60	($sp)
	sw	$t0	-84	($sp)
########	push ~24
	lw	$t0	-64	($sp)
	sw	$t0	-88	($sp)
########	call merge
	sw	$sp	-72	($sp)
	subi	$sp	$sp	64
	jal	merge
	lw	$sp	-8	($sp)
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	Label main
main:
	sw	$ra	-4	($sp)
########	var int n
########	printf string0
	la	$a0	string0
	li	$v0	4
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	scanf n
	li	$v0	5
	syscall
	sw	$v0	-12	($sp)
########	=		0		i
	li	$t0	0
	sw	$t0	-16	($sp)
########	Label for_1_begin
for_1_begin:
########	bge		i		n		for_1_end
	lw	$t0	-16	($sp)
	lw	$t1	-12	($sp)
	bge	$t0	$t1	for_1_end
########	scanf a
	li	$v0	5
	syscall
	sw	$v0	-20	($sp)
########	[]=		a		i		arr
	lw	$t0	-20	($sp)
	lw	$t1	-16	($sp)
	sll	$t1	$t1	2
	add	$t1	$t1	$gp
	sw	$t0	-4000	($t1)
########	+		i		1		~25
	lw	$t0	-16	($sp)
	li	$t1	1
	add	$t2	$t0	$t1
	sw	$t2	-24	($sp)
########	=		~25		i
	lw	$t0	-24	($sp)
	sw	$t0	-16	($sp)
########	j for_1_begin
	j	for_1_begin
########	Label for_1_end
for_1_end:
########	push 0
	li	$t0	0
	sw	$t0	-36	($sp)
########	push n
	lw	$t0	-12	($sp)
	sw	$t0	-40	($sp)
########	call inner_merge_sort
	sw	$sp	-32	($sp)
	subi	$sp	$sp	24
	jal	inner_merge_sort
	lw	$sp	-8	($sp)
########	=		0		i
	li	$t0	0
	sw	$t0	-16	($sp)
########	Label for_2_begin
for_2_begin:
########	bge		i		n		for_2_end
	lw	$t0	-16	($sp)
	lw	$t1	-12	($sp)
	bge	$t0	$t1	for_2_end
########	=[]		arr		i		~26
	lw	$t0	-16	($sp)
	sll	$t0	$t0	2
	add	$t0	$t0	$gp
	lw	$t1	-4000	($t0)
	sw	$t1	-28	($sp)
########	printf ~26
	lw	$t0	-28	($sp)
	move	$a0	$t0
	li	$v0	1
	syscall
########	printf newline
	la	$a0	newline
	li	$v0	4
	syscall
########	+		i		1		~27
	lw	$t0	-16	($sp)
	li	$t1	1
	add	$t2	$t0	$t1
	sw	$t2	-32	($sp)
########	=		~27		i
	lw	$t0	-32	($sp)
	sw	$t0	-16	($sp)
########	j for_2_begin
	j	for_2_begin
########	Label for_2_end
for_2_end:
########	NonRetreturn
	lw	$ra	-4	($sp)
	jr	$ra
########	Label end
end:
