# TODO: modify the info below
# Student ID: 123456789
# Name: Your Name
# TODO END
########### COMP 273, Winter 2022, Assignment 4, Question 1 - Tower of Hanoi ###########

.data
# TODO: add any variables here you if you need

stepmsg:.asciiz "Step "
mvdisk:.asciiz ": move disk "
from:.asciiz " from "
to:.asciiz " to "
nStep:.word 0
# TODO END

.text
main:
        # read the integer n from the standard input
	jal readInt
	# now $v0 contains the number of disk n
	
# TODO:
#       Use a recursive algorithm described to print the solution steps. Make sure you follow the output format.
#       You can design any functions you need (e.g., the recurisve procedure described in the handout) and put them in the next TODO block.
#       There are some helper functions for IO at the end of this file, which might be helpful for you.

	move $a0,$v0
	li $a1,'A'
	li $a2,'C'
	li $a3,'B'
	jal MoveHanoi
# TODO END
	
	li $v0, 10	# exit the program
	syscall


# TODO: your functions here

MoveHanoi:
	addiu   $sp, $sp, -24
	sw      $ra, 0($sp)
	sw      $s0, 4($sp)
	sw      $s1, 8($sp)
	sw      $s2, 12($sp)
	sw      $s3, 16($sp)
	sw      $s4, 20($sp)
	
	
	
	move $s0,$a0
	move $s1,$a1
	move $s2,$a2
	move $s3,$a3
	
	beq $s0,1,onlyOne
	addi $a0,$s0,-1
	move $a1,$s1
	move $a2,$s3
	move $a3,$s2
	jal MoveHanoi
	
	lw $t0,nStep
	addi $s4,$t0,1
	sw $s4,nStep
	
	la $a0,stepmsg
	jal printStr
	move $a0,$s4
	jal printInt
	la $a0,mvdisk
	jal printStr
	
	move $a0,$s0
	jal printInt
	
	la $a0,from
	jal printStr
	move $a0,$s1
	jal printChar
	la $a0,to
	jal printStr
	move $a0,$s2
	jal printChar
	li $a0,'\n'
	jal printChar
	
	beq $s0,1,onlyOne
	addi $a0,$s0,-1
	move $a1,$s3
	move $a2,$s2
	move $a3,$s1
	jal MoveHanoi
	j MoveHanoi.return
onlyOne:
	
	lw $t0,nStep
	addi $s4,$t0,1
	sw $s4,nStep
	
	la $a0,stepmsg
	jal printStr
	move $a0,$s4
	jal printInt
	la $a0,mvdisk
	jal printStr
	li $a0,1
	jal printInt
	
	la $a0,from
	jal printStr
	move $a0,$s1
	jal printChar
	la $a0,to
	jal printStr
	move $a0,$s2
	jal printChar
	li $a0,'\n'
	jal printChar
	
MoveHanoi.return:

	lw      $s4, 20($sp)
	lw      $s3, 16($sp)
	lw      $s2, 12($sp)
	lw      $s1, 8($sp)
	lw      $s0, 4($sp)
	lw      $ra, 0($sp)
	addiu   $sp, $sp, 24
	jr $ra


# TODO END


########### Helper functions for IO ###########

# read an integer
# int readInt()
readInt:
	li $v0, 5
	syscall
	jr $ra
	
# print an integer
# printInt(int n)
printInt:

	li $v0, 1
	syscall

	jr $ra

# print a character
# printChar(char c)
printChar:

	li $v0, 11
	syscall

	jr $ra
	
# print a null-ended string
# printStr(char *s)
printStr:

	li $v0, 4
	syscall

	jr $ra
