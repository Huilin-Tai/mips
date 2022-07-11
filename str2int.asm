# Student ID = 260962725
###############################str2int######################
.data
.align 2
blank:		.asciiz "\n"
.text
.globl str2int
###############################str2int######################
str2int:
	# $a0 -> address of string, i.e "32", terminated with 0, EOS
	###### returns ########
	# $v0 -> return converted integer value
	# $v1 -> length of integer
	###########################################################
	li $v0 0
	li $v1 0
	li $t1 10
	li $t2 '0'
str2int.loop:
    lb $t0 0($a0)
    beq $t0 $0 str2int.return
    mul $v0 $v0 $t1
    add $v0 $v0 $t0
    sub $v0 $v0 $t2
    addi $a0 $a0 1
    addi $v1 $v1 1
    j str2int.loop
str2int.return:
	jr $ra