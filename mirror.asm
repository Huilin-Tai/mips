# Student ID = 260962725
########################## mirror #######################
.data
.text
.globl mirror_horizontally
########################## mirror #######################
mirror_horizontally:
	# $a0 -> image struct
	###############return################
	# $v0 -> image struct s.t. mirrored image horizontally. 
    addi $sp $sp -20
	sw $ra 0($sp)
	sw $s1 4($sp) # image
	sw $s2 8($sp) # label image
	
	move $s1 $a0
	jal image_copy
	move $s2 $v0

    
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
    lw   $a1 ci
    lw   $t1 cw
    lw   $a2 cj
    sub  $a2 $t1 $a2
    addi $a2 $a2 -1
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
    

mirror_horizontally.return:
    move $v0 $s2
    lw $ra 0($sp)
	lw $s1 4($sp)
	lw $s2 8($sp)
	addi $sp $sp 20
	jr $ra

