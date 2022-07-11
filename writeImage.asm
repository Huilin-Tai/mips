# Student ID = 260962725
####################################write Image#####################
.data
tmpwritechar: .word 0
tmpwritenumber: .space 36
image: .word 0
.text
.globl write_image
####################################write Image#####################
write_char:
	addi $sp $sp -12
	sw $ra 0($sp)
	sw $s1 4($sp)
    # a0 handle
    # a1 write char
    sb $a1 tmpwritechar
    la $a1 tmpwritechar
    li $a2 1
    li $v0 15
    syscall
    lw $ra 0($sp)
	lw $s1 4($sp)
    addi $sp $sp 12
    jr $ra
    
write_str:
	addi $sp $sp -12
	sw $ra 0($sp)
	sw $s1 4($sp)
	sw $s2 8($sp)
    # a0 handle
    # a1 str
    move $s1 $a0
    move $s2 $a1
write_str.loop:
    lb $t1 0($s2)
    beq $t1 $0 write_str.end
    li $t2 ' '
    beq $t1 $t2 write_str.end
    li $t2 10
    beq $t1 $t2 write_str.end
    move $a0 $s1
    move $a1 $t1
    jal write_char
    addi $s2 $s2 1
    j write_str.loop
write_str.end:    
    lw $ra 0($sp)
	lw $s1 4($sp)
	lw $s2 8($sp)
    addi $sp $sp 12
    jr $ra

    
write_number:
    addi $sp $sp -12
	sw $ra 0($sp)
	sw $s1 4($sp)
	sw $s2 8($sp)
	
	# a1 the number
	move $s1 $a0
	move $a0 $a1
	jal int2str
	move $a0 $s1
	move $a1 $v0
	jal write_str

    lw $ra 0($sp)
	lw $s1 4($sp)
	lw $s2 8($sp)
    addi $sp $sp 12
    jr $ra
    
write_image:
	# $a0 -> image struct
	# $a1 -> output filename
	# $a2 -> type (0 -> P5, 1->P2)
	################# returns #################
	# void
	# Add code here.
    addi $sp $sp -16
	sw $ra 0($sp)
	sw $s1 4($sp)
	sw $s2 8($sp)
	sw $s3 12($sp)
	move $s1 $a0
	move $a0 $a1
	move $s3 $a2
	
	li $a1 1
	li $a2 0
	li $v0 13
	syscall
	
	move $s2 $v0
	beq $s3 $0 write_p5
	j write_p2
write_image.return:
	move $a0 $s2
	li $v0 16
	syscall
	
	lw $ra 0($sp)
	lw $s1 4($sp)
	lw $s2 8($sp)
	lw $s3 12($sp)
	addi $sp $sp 16
    jr $ra
write_p2:
.data
    P2: .asciiz "P2"
    p2w: .word 0
    p2h: .word 0
    p2d: .word 0
    p2i: .word 0
    p2j: .word 0
.text
    move $a0 $s2
    la $a1 P2
    jal write_str
    
    move $a0 $s2
    li $a1 10
    jal write_char
    
    move $a0 $s2
    lw $a1 0($s1)
    sw $a1 p2w 
    jal write_number

    move $a0 $s2
    li $a1 ' '
    jal write_char
    
    move $a0 $s2
    lw $a1 4($s1)
    sw $a1 p2h
    jal write_number

    move $a0 $s2
    li $a1 10
    jal write_char
    
    move $a0 $s2
    lw $a1 8($s1)
    jal write_number

    move $a0 $s2
    li $a1 10
    jal write_char
    
    addi $a1 $s1 12
    sw $a1 p2d
    
    sw $0 p2i    
p2outer:
    lw $t1 p2i
    lw $t2 p2h
    beq $t1 $t2 write_image.return
    
    sw $0 p2j
p2inner:
    lw $t1 p2j
    lw $t2 p2w
    beq $t1 $t2 p2innerend
    
    move $a0 $s1
    lw $a1 p2i
    lw $a2 p2j
    jal image_access
    
    move $a0 $s2
    lb $a1 0($v0)
    jal write_number
    
    lw $t1 p2j
    addi $t1 $t1 1
    sw $t1 p2j
    
    lw $t2 p2w
    beq $t1 $t2 p2newline
    move $a0 $s2
    li $a1 ' '
    jal write_char
    j p2inner
p2newline:
    move $a0 $s2
    li $a1 10
    jal write_char
p2innerend:
    lw $t1 p2i
    addi $t1 $t1 1
    sw $t1 p2i
    j p2outer
write_p5:
.data
    P5: .asciiz "P5"
    p5w: .word 0
    p5h: .word 0
    p5d: .word 0
    p5i: .word 0
    p5j: .word 0
.text
    move $a0 $s2
    la $a1 P5
    jal write_str
    
    move $a0 $s2
    li $a1 10
    jal write_char
    
    move $a0 $s2
    lw $a1 0($s1)
    sw $a1 p5w 
    jal write_number

    move $a0 $s2
    li $a1 10
    jal write_char
    
    move $a0 $s2
    lw $a1 4($s1)
    sw $a1 p5h
    jal write_number

    move $a0 $s2
    li $a1 10
    jal write_char
    
    move $a0 $s2
    lw $a1 8($s1)
    jal write_number

    move $a0 $s2
    li $a1 10
    jal write_char
    
    
    
    move $a0 $s2
    addi $a1 $s1 12
    lw $a2 0($s1)
    lw $t1 4($s1)
    mul $a2 $a2 $t1
    li $v0 15
    syscall
    move $a0 $s2
    li $a1 10
    jal write_char
    
    move $a0 $s2
    li $a1 0
    jal write_char
    
    j write_image.return
