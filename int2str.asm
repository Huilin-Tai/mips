# Student ID = 260962725
###############################int2str######################
.data
.align 2
int2strBuffer:	.space 36
.text
.globl int2str
###############################int2str######################
int2str:
	# $a0 <- integer to convert
	##############return#########
	# $v0 <- space terminated string 
	# $v1 <- length or number string + 1(for space)
	###############################
	# Add code here
	addi $sp $sp -4
	sw $ra 0($sp)
	la $t0 int2strBuffer
	move $t1 $a0
	li $v1 0
int2str.loop:
    beq $t1 $0 int2str.endloop
    rem $t2 $t1 10
    addi $t2 $t2 '0'
    sb $t2 0($t0)
    div $t1 $t1 10
    addi $t0 $t0 1
    addi $v1 $v1 1
    j int2str.loop
int2str.endloop:
    beq $v1 $0 int2str.zerocase
    j int2str.nonzero
int2str.zerocase:   
    li $t1 '0'
    sw $t1 int2strBuffer($0)
    addi $t0 $t0 1
    li $v1 1
int2str.nonzero:
    addi $a0 $v1 1
    jal malloc
    move $t1 $v0
    li $t2 0
    subi $t0 $t0 1
int2str.loop2:
    beq $t2 $v1 int2str.endloop2
    lb $t3 0($t0)
    sb $t3 0($t1)
    subi $t0 $t0 1
    addi $t1 $t1 1
    addi $t2 $t2 1 
    j int2str.loop2
int2str.endloop2:
    li $t2 ' '
    sb $t2 0($t1)
    addi $v1 $v1 1
int2str.return:
    lw $ra 0($sp)
    addi $sp $sp 4
	jr $ra