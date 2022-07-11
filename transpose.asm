# Student ID = 260962725
##########################image transpose##################
.data
.text
.globl transpose
##########################image transpose##################
transpose:
	# $a0 -> image struct
	###############return################
	# $v0 -> image struct s.t. contents containing the transpose image.
	# Note that you need to rewrite width, height and max_value information
	
	
	# Adds your codes here 

    addi $sp $sp -20
	sw $ra 0($sp)
	sw $s1 4($sp) # image
	sw $s2 8($sp) # label image
	
	move $s1 $a0
	jal image_copy
	move $s2 $v0
	lw $t1 0($s1)
	sw $t1 4($s2)
	lw $t1 4($s1)
	sw $t1 0($s2)
    
.data
    cw: .word 0
    ch: .word 0
    ci: .word 0
    cj: .word 0
    laddr: .word 0
    point: .word 0
.text    
    lw $t1 0($s1)
    sw $t1 cw
    lw $t1 4($s1)
    sw $t1 ch
    
    sw $0 ci    
p1.outer:
    lw $t1 ci
    lw $t2 ch
    beq $t1 $t2 p1.end
    
    sw $0 cj
p1.inner:
    lw $t1 cj
    lw $t2 cw
    beq $t1 $t2 p1.inner.end
    
    move $a0 $s1
    lw   $a1 ci
    lw   $a2 cj
    jal image_access
    lb $t1 0($v0)
    sw $t1 point
    
    move $a0 $s2
    lw   $a1 cj
    lw   $a2 ci
    jal image_access
    lw $t1 point
    sb $t1 0($v0)
 
    

p1.inner.incr:    
    lw $t1 cj
    addi $t1 $t1 1
    sw $t1 cj
    j p1.inner
p1.inner.end:
    lw $t1 ci
    addi $t1 $t1 1
    sw $t1 ci
    j p1.outer

p1.end:
    sw $0 ci    
transpose.return:
	move $v0 $s2
    lw $ra 0($sp)
	lw $s1 4($sp)
	lw $s2 8($sp)
	addi $sp $sp 20
	jr $ra