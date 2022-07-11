# Student ID = 260962725
#########################Read Image#########################
.data
tmpword: .space 36
tmpchar: .space 10
read_image.ret: .word 0
.text
.globl read_image
#########################Read Image#########################
read_char:
	addi $sp $sp -12
	sw $ra 0($sp)
	sw $s1 4($sp)
    # a0 handle
    # -> v0 return char
    la $a1 tmpchar
    li $a2 1
    li $v0 14
    syscall
    lb $v0 tmpchar
	lw $ra 0($sp)
	lw $s1 4($sp)
    addi $sp $sp 12
    jr $ra

read_number:
	addi $sp $sp -12
	sw $ra 0($sp)
	sw $s1 4($sp)
	sw $s2 8($sp)
    # $a0 filehandle
    # ret $v0 the number
    
    move $s1 $a0
    la $s2 tmpword
read_number.space_loop:    
    move $a0 $s1
    jal read_char
    li $t1 ' '
    beq $v0 $t1 read_number.space_loop
    li $t1 10
    beq $v0 $t1 read_number.space_loop
    li $t1 9
    beq $v0 $t1 read_number.space_loop
    j read_number.judge
read_number.loop:
    move $a0 $s1
    jal read_char
read_number.judge:
    sb $v0 0($s2)
    li $t1 '0'
    blt $v0 $t1 read_number.done
    li $t1 '9'
    bgt $v0 $t1 read_number.done
    addi $s2 $s2 1
    j read_number.loop
read_number.done:    
    sb $0 0($s2)
    la $a0 tmpword
    jal str2int
    lw $ra 0($sp)
    lw $s1 4($sp)
    lw $s2 8($sp)
    addi $sp $sp 12
    jr $ra
    
read_image:
	# $a0 -> input file name, it will be either P2 or P5 file
        # You need to check the char after 'P' to determine the image type. 
	################# return #####################
	# $v0 -> Image struct :
	# struct image {
	#	int width;
	#       int height;
	#	int max_value;
	#	char contents[width*height];
	#	}
	##############################################
	# Add code here
	addi $sp $sp -20
	sw $ra 0($sp)
	sw $s1 4($sp)
	li $a1 0
	li $a2 0
	li $v0 13
	syscall
	move $s1 $v0  # file handle
	#For P2 you need to use str2int
	move $a0 $s1
	jal read_char   # P
	move $a0 $s1
	jal read_char
	addi $v0 $v0 -50 # '2'
	beq $v0 $0 read_p2
	j read_p5    

read_image.return:
    move $a0 $s1
    li $v0 16
    syscall
    lw $v0 read_image.ret
    lw $ra 0($sp)
    lw $s1 4($sp)
    addi $sp $sp 20
	jr $ra
	
	
	
read_p2:
.data
read_p2.w:     .word 0
read_p2.h:     .word 0
read_p2.max:   .word 0
read_p2.data:  .word 0
read_p2.count: .word 0
read_p2.pos:   .word 0
.text
    
    move $a0 $s1
    jal read_number
	sw $v0 read_p2.w
	
	move $a0 $s1
    jal read_number
	sw $v0 read_p2.h
	
	move $a0 $s1
    jal read_number
	sw $v0 read_p2.max
	
	lw $t1 read_p2.w
	lw $t2 read_p2.h
	mul $t1 $t1 $t2
	sw $t1 read_p2.count
	addi $a0 $t1 12
	jal malloc
	sw $v0 read_p2.data
	
	lw $t3 read_p2.w
	lw $t4 read_p2.data
	sw $t3 0($t4)
	lw $t3 read_p2.h
	lw $t4 read_p2.data
	sw $t3 4($t4)
	lw $t3 read_p2.max
	lw $t4 read_p2.data
	sw $t3 8($t4)
	
	sw $0 read_p2.pos
read_p2.loop:
    lw $t1 read_p2.pos
    lw $t2 read_p2.count
    beq $t1 $t2 read_p2.loop_end
    
    move $a0 $s1
    jal read_number
    lw $t1 read_p2.pos
    lw $t2 read_p2.data
    addi $t2 $t2 12
    add $t2 $t2 $t1    
    sb $v0 0($t2)
    addi $t1 $t1 1
    sw $t1 read_p2.pos
    j read_p2.loop
read_p2.loop_end:
    lw $t0 read_p2.data
    sw $t0 read_image.ret
    j read_image.return 
    
read_p5:	
.data
read_p5.w:     .word 0
read_p5.h:     .word 0
read_p5.max:   .word 0
read_p5.data:  .word 0
.text
    move $a0 $s1
    jal read_number
	sw $v0 read_p5.w
	
	move $a0 $s1
    jal read_number
	sw $v0 read_p5.h
	
	move $a0 $s1
    jal read_number
	sw $v0 read_p5.max
	
	move $a0 $s1
	jal read_char
	
	lw $t1 read_p5.w
	lw $t2 read_p5.h
	mul $t1 $t1 $t2
	sw $t1 read_p2.count
	addi $a0 $t1 12
	jal malloc
	sw $v0 read_p5.data
	
	move $a0 $s1
	addi $a1 $v0 12
    move $a2 $t1
    li $v0 14
    syscall
    
    lw $t3 read_p5.w
	lw $t4 read_p5.data
	sw $t3 0($t4)
	lw $t3 read_p5.h
	lw $t4 read_p5.data
	sw $t3 4($t4)
	lw $t3 read_p5.max
	lw $t4 read_p5.data
	sw $t3 8($t4)
    
    lw $t0 read_p5.data
    sw $t0 read_image.ret
    j read_image.return
	 
	
	
	
	