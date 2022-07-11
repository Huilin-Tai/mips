# This question is an exercise of working loops and user inputs
# Please comment your work

	.data

inputMes:	.asciiz    "please input a num:"

outputYes:	.asciiz	    " is power of 2."
outputNo:	.asciiz     " not is power of 2."

	.text
	.globl main

main:
	li  $v0, 4		# print the input messgae
       la  $a0, inputMes
       syscall
       
       li  $v0, 5
       syscall
       move $t1, $v0		#user input data
       
       li   $v0, 1		# print the output
       move  $a0, $t1
       syscall
       
       li  $t2, 2
       div $t1, $t2
       
       mfhi $t3
       beq  $t3, 0, PowerYes
       li  $v0, 4		# print the input messgae
       la  $a0, outputNo
       syscall
       j Exit
 PowerYes:      
       li  $v0, 4		# print the input messgae
       la  $a0, outputYes
       syscall	
Exit:
	li $v0, 10		# terminate program
       	syscall   