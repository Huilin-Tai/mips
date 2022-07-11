# Student ID = 260962725
###############################connected components######################
.data
equiv_label: .byte 0,1,2,3,2,2,3,3,4,4,4,4,5,5,5,5
             .space 1000
label_count: .word 0
.text
.globl connected_components
########################## connected components ##################
find_root:
	addi $sp $sp -20
	sw $ra 0($sp)
    sw $s1 4($sp)
    
    move $s1 $a0
    lb $v0 equiv_label($s1)
    beq $v0 $s1 root
    
    move $a0 $v0
    jal find_root
root:
    sb $v0 equiv_label($s1)
    lw $ra 0($sp)
    lw $s1 4($sp)
	addi $sp $sp 20
    jr $ra
    
merge_root:
    addi $sp $sp -20
	sw $ra 0($sp)
    sw $s1 4($sp)
    sw $s2 8($sp)
    move $s1 $a0
    move $s2 $a1
    
    move $a0 $s1
    jal find_root
    move $s1 $v0
    
    move $a0 $s2
    jal find_root
    move $s2 $v0
	
    blt $s1 $s2 less
    j merge
less:    
    move $t0 $s1
    move $s1 $s2
    move $s2 $t0
    
merge:
    sb $s2 equiv_label($s1)
    move $v0 $s2
    lw $ra 0($sp)
    lw $s1 4($sp)
    lw $s2 8($sp)
	addi $sp $sp 20
    jr $ra
    
connected_components:
	# $a0 -> image struct
	############return###########
	# $v0 -> image struct with labelled connected components
	# $v1 -> number of connected components (equivalent to number of unique labels)
	addi $sp $sp -20
	sw $ra 0($sp)
	sw $s1 4($sp) # image
	sw $s2 8($sp) # label image
	
	move $s1 $a0
	jal image_copy
	move $s2 $v0
    
	li $t0 256
	la $t1 equiv_label
	addi $t1 $t1 256
fillloop:
    beq $t0 $0 fillloop.end
    sb $t0 0($t1)
    addi $t0 $t0 -1
    addi $t1 $t1 -1    
fillloop.end:
    sw $0 label_count
    
.data
    cw: .word 0
    ch: .word 0
    ci: .word 0
    cj: .word 0
    point: .word 0
    laddr: .word 0
    ltop:  .word 0
    lleft:  .word 0
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
    
    beq $t1 $0 p1.inner.incr
    sw $t1 point
    
    move $a0 $s2
    lw   $a1 ci
    lw   $a2 cj
    jal image_access
    sw $v0 laddr
    
    
    move $a0 $s2
    lw   $a1 ci
    addi $a1 $a1 -1
    lw   $a2 cj
    jal image_access
    lb $t1 0($v0)
    sw $t1 ltop
    
    move $a0 $s2
    lw   $a1 ci
    lw   $a2 cj
    addi $a2 $a2 -1
    jal image_access
    lb $t1 0($v0)
    sw $t1 lleft
    
    
    lw $t1 ltop
    lw $t2 lleft
    beq $t1 $0 p1.ltop.zero
    j p1.ltop.nonzero
    
    
p1.ltop.nonzero:
    beq $t2 $0 p1.copylabel
    beq $t2 $t1 p1.copylabel
    j p1.equivlabel
    
p1.ltop.zero: 
    beq $t2 $0 p1.newlabel
    move $t1 $t2 
    j p1.copylabel
    
p1.newlabel:
    lw $t1 label_count
    addi $t1 $t1 1
    sw $t1 label_count
    lw $t2 laddr
    sb $t1 0($t2)
    j p1.inner.incr
    
p1.copylabel:
    lw $t2 laddr
    sb $t1 0($t2)
    j p1.inner.incr

p1.equivlabel:
    move $a0 $t1
    move $a1 $t2
    jal merge_root
    lw $t2 laddr
    sb $v0 0($t2)
    j p1.inner.incr
    
    
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
p2.outer:
    lw $t1 ci
    lw $t2 ch
    beq $t1 $t2 p2.end
    
    sw $0 cj
p2.inner:
    lw $t1 cj
    lw $t2 cw
    beq $t1 $t2 p2.inner.end
    
    move $a0 $s2
    lw   $a1 ci
    lw   $a2 cj
    jal image_access
    lb $t1 0($v0)
    sw $t1 point
    
    move $a0 $s2
    lw   $a1 ci
    lw   $a2 cj
    jal image_access
    sw $v0 laddr
    
    lw $a0 point
    jal find_root
    sb $v0 laddr
    
    lw $t1 ci
    lw $t2 cj
    add $t1 $t1 $t2
    rem $t1 $t1 10
    sb $t1 laddr
    
p2.inner.incr:    
    lw $t1 cj
    addi $t1 $t1 1
    sw $t1 cj
    
    j p2.inner
p2.inner.end:
    lw $t1 ci
    addi $t1 $t1 1
    sw $t1 ci
    j p2.outer

p2.end:    
connected_components.return:
    move $v0 $s2
    lw $v1 label_count
    lw $ra 0($sp)
	lw $s1 4($sp)
	lw $s2 8($sp)
	addi $sp $sp 20
	
	jr $ra