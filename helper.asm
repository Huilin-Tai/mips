# Student ID = 260962725
.text
.globl image_copy
.globl image_alike
.globl image_access
.globl memcpy

memcpy:
    addi $sp $sp -12
	sw $ra 0($sp)
	# a0 dest
	# a1 src
	# a2 length
memcpy.loop: 
    ble $a2 $0 memcpy.end
    addi $a2 $a2 -1
    lb $t1 0($a1)
    sb $t1 0($a0)
    addi $a0 $a0 1
    addi $a1 $a1 1
	j memcpy.loop
	
memcpy.end:	
	lw $ra 0($sp)
	addi $sp $sp 12
	jr $ra

image_alike:
	addi $sp $sp -12
	sw $ra 0($sp)
	sw $s1 4($sp)
	sw $s2 8($sp)
    # a0 is an image
    # v0 output a new image with the same shape
    move $s1 $a0
    lw $t1 0($s1)
    lw $t2 4($s1)
    mul $t1 $t1 $t2
    addi $t1 $t1 12
    move $a0 $t1
    jal malloc
    move $s2 $v0
    
    move $a0 $s2
    move $a1 $s1
    li $a2 12
    jal memcpy
    
    move $v0 $s2
	lw $ra 0($sp)
	lw $s1 4($sp)
	lw $s2 8($sp)
	addi $sp $sp 12
	jr $ra

	
image_copy:
	addi $sp $sp -12
	sw $ra 0($sp)
	sw $s1 4($sp)
	sw $s2 8($sp)
	
	move $s1 $a0
	jal image_alike
	move $s2 $v0
	
	lw $t1 0($s1)
    lw $t2 4($s1)
    mul $t1 $t1 $t2
    addi $t1 $t1 12
    
    move $a0 $s2
    move $a1 $s1
    move $a2 $t1
    jal memcpy
	
    move $v0 $s2
	lw $ra 0($sp)
	lw $s1 4($sp)
	lw $s2 8($sp)
	addi $sp $sp 12
	jr $ra

		
image_access:
.data
   background: .word 0
.text   
    addi $sp $sp -12
	sw $ra 0($sp)
	# a0 image
	# a1 line
	# a2 col
	# v0 -> the address of image[line, col]
   
	
	blt $a2 $0 access.invalid
	blt $a1 $0 access.invalid
	lw $t1 0($a0)
	bge $a2 $t1 access.invalid
	lw $t1 4($a0)
	bge $a1 $t1 access.invalid
	
	lw $t2 0($a0)
    mul $a1 $a1 $t2
    add $a1 $a1 $a2
    addi $a1 $a1 12
    add $v0 $a1 $a0
    
    j access.ret
    
access.invalid:
    sw $0 background
    la $v0 background
    
access.ret:    
	lw $ra 0($sp)
	addi $sp $sp 12
	jr $ra