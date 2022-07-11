# This question is an exercise of working with byte arrays
# The byte array and its size is hardcoded
# Please comment your work

	.data
	
array: 		.byte 'E','N','W','S','E','E','S'
size:		.word 7

output_1:	.asciiz	"("
output_2:	.asciiz	","
output_3:	.asciiz	")"

	.text
	.globl main

main:
	la   $t1, array		# to the first element of the array
	lw   $t2, size
	li   $t3, 0		#x
	li   $t4, 0		#y
Loop:
	ble  $t2, 0, End
	lb   $t5, 0($t1)
	bne  $t5, 'E', South
	addi $t3, $t3, 1	#x+1
	j    next
South:
	bne  $t5, 'S', West
	addi $t4, $t4, -1	#y-1
	j    next
West:
	bne  $t5, 'W', North
	addi $t3, $t3, -1	#x-1
	j    next
North:
	bne  $t5, 'N', next
	addi $t4, $t4, 1	#y+1
next:
	addi $t1, $t1, 1
	addi $t2, $t2, -1
	j    Loop
End:
       li   $v0, 4		# print the output 
       la   $a0, output_1
       syscall
       
       li   $v0, 1		# print the output
       move  $a0, $t3
       syscall
       
       li   $v0, 4		# print the output 
       la   $a0, output_2
       syscall
       
       li   $v0, 1		# print the output
       move  $a0, $t4
       syscall
       
       li   $v0, 4		# print the output 
       la   $a0, output_3
       syscall
       

       	li $v0, 10		# terminate program
       	syscall      

