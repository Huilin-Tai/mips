# This question is an exercise of working with and manipulating strings in MIPS 
# The input string is hardcoded. The program should print the input string, perform the requested manipulation,
# then print the output string
# Please comment your work

		.data
inputstring: 	.asciiz "HHh kk mm l"
outputstring:	.space 100
blank: 		.asciiz "\n" 


	.text
	.globl main
	
main:  	la  $t1, inputstring		# to the first element of the string
       li  $v0, 4		# print the original string
       la  $a0, inputstring
       syscall
       
       li  $v0, 4		# print a blank line
       la  $a0, blank
       syscall
       
loop:   lb $t3, 0($t1)
	beq $t3, ' ', Next
 	beq $t3, $0, end
 	blt $t3, 'a', ToLow #check upcase or not
 	bgt $t3,'Z', ToUp
 Next:
 	addi $t1, $t1, 1
 	j loop
ToUp:
 	addi $t3, $t3, -32
 	sb $t3,0($t1)
 	addi $t1,$t1,1
 	j loop
 ToLow:	
 	addi $t3,$t3,32
 	sb $t3,0($t1)
 	addi $t1,$t1,1
 	j loop
end: 
	addi $v0,$zero,4
	la $a0,inputstring
	syscall
	
       	li $v0, 10		# terminate program
       	syscall      
       
       
