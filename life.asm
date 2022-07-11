# TODO: modify the info below
# Student ID: 123456789
# Name: Your Name
# TODO END
########### COMP 273, Winter 2022, Assignment 4, Question 2 - Game of Life ###########

.data
# You should use following two labels for opening input/output files
# DO NOT change following 2 lines for your submission!
inputFileName:	.asciiz	"life-input.txt"
outputFileName:	.asciiz "life-output.txt"
errmsg:	.asciiz "file not found!\n"
# TODO: add any variables here you if you need
 buffer: .space 100
 cells: .space 100
.text
	li $v0, 13 # Service 13: open file
	la $a0, inputFileName # inputFileName
	li $a1, 0 # read-only 
	syscall # Open file
	blt $v0,1,erropen
	move $s6,$v0
	b openOk
erropen:
	la $a0,errmsg
	li $v0,4
	syscall
	li $v0, 10	# exit the program
	syscall
openOk:
	li $v0, 14              # system call for read from file
	move $a0, $s6     
	la $a1, buffer          # address of buffer from which to read
	li $a2, 100            # hardcoded buffer length
	syscall                 # read from file
	 
	li $v0, 4           # syscall for printing a string
	la $a0, buffer          # load read data in $a0
	#syscall
	

	
	
	li  $s1, 6             # s1 = 4
	li  $s2, 0             # i = 0
loop1:
	beq  $s2, $s1, end1    # if (i >= 4) break
	li   $s3, 0            # j = 0
loop2:
	beq  $s3, 6, end2    # if (j >= 4) break
	mul  $t0, $s2, 6      # off = 4*4*i + 4*j
	mul  $t1, $s3, 1       #  cells[i][j] is
	add  $s7, $t0, $t1     #  done as *(cells+off)
	
	lb   $s4, buffer($s7)  # t0 = cells[i][j]
	sb $s4,cells($s7)
	addi $t0,$s7,1
	sb $zero,cells($t0)
	beq $s4,'\n',nextG
	addi $a0,$s4,0
	li $v0,11 
	#syscall
	li  $s0, 0             # sum = 0
	
	addi $a0,$s2,-1 #i-1,j
	addi $a1,$s3,0
	jal getCell
	add  $s0, $s0, $v0
	
	addi $a0,$s2,1 #i+1,j
	addi $a1,$s3,0
	jal getCell
	add  $s0, $s0, $v0
	
	addi $a0,$s2,0 #i,j+1
	addi $a1,$s3,1
	jal getCell
	add  $s0, $s0, $v0
	
	addi $a0,$s2,0 #i,j-1
	addi $a1,$s3,-1
	jal getCell
	add  $s0, $s0, $v0
	
	addi $a0,$s2,-1 #i-1,j-1
	addi $a1,$s3,-1
	jal getCell
	add  $s0, $s0, $v0
	
	addi $a0,$s2, 1 #i+1,j+1
	addi $a1,$s3, 1
	jal getCell
	add  $s0, $s0, $v0
	
	addi $a0,$s2, -1 #i-1,j+1
	addi $a1,$s3, 1
	jal getCell
	add  $s0, $s0, $v0
	
	addi $a0,$s2, 1 #i+1,j-1
	addi $a1,$s3, -1
	jal getCell
	add  $s0, $s0, $v0
	
	move $a0,$s0
	li $v0,1
	#syscall
	li $a0,'\n'
	li $v0,11
	#syscall
	
	
	beq $s4,'0',died
	blt $s0,2,makeDied
	bgt $s0,3,makeDied
	j nextG
makeDied:
	li $t0,'0'
	sb $t0,cells($s7)
	j nextG
makeAlive:
	li $t0,'1'
	sb $t0,cells($s7)
	j nextG
died:
	beq $s0,3,makeAlive
	j nextG
	
nextG:
	addi $s3, $s3, 1       # j++
	j    loop2
end2:
	addi $s2, $s2, 1       # i++
	j    loop1
end1:

	li      $v0,4      
	la      $a0,cells 
	syscall            

	 
	li $v0, 13 # Service 13: open file
	la $a0, outputFileName # Output file name
	li $a1, 1 # Write-only with create
	syscall # Open file
	move $s6,$v0
	
	move $s0, $v0 # $s0 = file descriptor
	li $v0, 15 # Service 15: write to file
	move $a0, $s0 # $a0 = file descriptor
	la $a1, cells # $a1 = address of buffer
	li $a2, 30 # $a2 = number of characters to write
	syscall # Write to file
	
	
	li $v0, 16 # Service 16: close file
	move $a0, $s0 # $a0 = file descriptor
	syscall # Close file
	
	li $v0, 10	# exit the program
	syscall
	
getCell:
	addiu   $sp, $sp, -24
	sw      $ra, 0($sp)
	sw      $s0, 4($sp)
	sw      $s1, 8($sp)
	sw      $s2, 12($sp)
	sw      $s3, 16($sp)
	sw      $s4, 20($sp)
	
	blt $a0,1,skip
	bge $a0,5,skip
	blt $a1,1,skip
	bge $a1,5,skip
	mul  $t0, $a0, 6      # off = 4*4*i + 4*j
	mul  $t1, $a1, 1       #  cells[i][j] is
	add  $t0, $t0, $t1     #  done as *(cells+off)
	
	lb   $v0, buffer($t0)  # t0 = cells[i][j]
	
	beq $v0,'\n',skip
	beq $v0,'0',skip
	li $v0,1
	j getCell.return
skip:
	li $v0,0
getCell.return:

	lw      $s4, 20($sp)
	lw      $s3, 16($sp)
	lw      $s2, 12($sp)
	lw      $s1, 8($sp)
	lw      $s0, 4($sp)
	lw      $ra, 0($sp)
	addiu   $sp, $sp, 24
	jr $ra
########### Helper functions for IO ###########

# read an integer
# int readInt()
readInt:
	li $v0, 5
	syscall
	jr $ra