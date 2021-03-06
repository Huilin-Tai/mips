# TODO: modify the info below
# Student ID: 123456789
# Name: Your Name
# TODO END
########### COMP 273, Winter 2022, Assignment 4, Question 3 - Snake ###########

# Constant definition. You can use them like using an immediate.
# color definition:
.eqv BLACK	0x00000000
.eqv RED	0x00ff0000
.eqv GREEN	0x0000ff00
.eqv BLUE	0x000000ff
.eqv YELLOW	0x00ffff00
.eqv BROWN	0x00994c00
.eqv GRAY	0x00f0f0f0
.eqv WHITE	0x00ffffff

# tile definition
.eqv EMPTY	BLACK
.eqv SNAKE	WHITE
.eqv FOOD	YELLOW
.eqv RED_PILL	RED
.eqv BLUE_PILL	BLUE
.eqv WALL	BROWN

# Direction definition
.eqv DIR_RIGHT	0
.eqv DIR_DOWN	1
.eqv DIR_LEFT	2
.eqv DIR_UP  3

# game state definition
.eqv STATE_NORMAL	0
.eqv STATE_PAUSE	1
.eqv STATE_RESTART	2
.eqv STATE_EXIT		3

# some constants for buffer
.eqv WIDTH	64
.eqv HEIGHT	32
.eqv DISPLAY_BUFFER_SIZE	0x2000
.eqv SNAKE_BUFFER_SIZE		0x2000

# initial postion of the snake
.eqv INIT_HEAD_X	32
.eqv INIT_HEAD_Y	16
.eqv INIT_TAIL_X	31
.eqv INIT_TAIL_Y	16

# initial length of the snake
.eqv INIT_LENGTH	2

# maximum number of pills
.eqv MAX_NUM_PILLS	10

# TODO: add any constants here you if you need


# TODO END


.data
infile: .asciiz "map.txt" #
displayBuffer:	.space	DISPLAY_BUFFER_SIZE	# 64x32 display buffer. Each pixel takes 4 bytes.
snakeSegment:	.space	SNAKE_BUFFER_SIZE	# Array to store the offsets of the snake segments in the display buffer.
						# E.g., head_offset, 2nd_segment_offset, ..., tail_offset
						# Each offset takes 4 bytes.
snakeLength:	.word	INIT_LENGTH		# length of the snake
headX:		.word	INIT_HEAD_X		# head position x
headY:		.word	INIT_HEAD_Y		# head position y
numPills:	.word	0	# number of pills (red and blue)
direction:	.word	0	# moving direction of the snake head:
				#	0: right
				#	1: down
				#	2: left
				#	3: up
state:		.word	0	# game state:
				#	0: normal
				#	1: pause
				#	2: retstart
				#	3: exit
score:		.word	0	# score in the game. increase by 1 everying time eating a regular food
msgScore:	.asciiz "Score: "
.align 2
timeInterval:	.word   100
incSpeed:	.float 0.833333
decSpeed:	.float 1.25

# TODO: add any variables here you if you need
.eqv LETTER_a 97
.eqv LETTER_d 100
.eqv LETTER_w 119
.eqv LETTER_s 115
KEYBOARD_EVENT_PENDING:
	.word	0x0
KEYBOARD_EVENT:
	.space 256
	
.kdata

	.ktext 0x80000180

__kernel_entry:
	mfc0 $k0, $13		
	andi $k1, $k0, 0x7c	
	srl  $k1, $k1, 2	
	beq $zero, $k1, _interrupt  
	
	b __exit_exception
	
_interrupt:
	andi $k1, $k0, 0x0100	
	bne $k1, $zero, _keyboard_interrupt	 
	
	b __exit_exception	

	
_keyboard_interrupt:
	addi $k0,$zero,1 
	la $k1,KEYBOARD_EVENT_PENDING 
	sw $k0,0($k1)                   
	la $k0,0xffff0004
	lw $k1,0($k0)   
	la $k0,KEYBOARD_EVENT 
	sw $k1,0($k0)                   

__exit_exception:
	eret

# TODO END


.text
main:
	la $t0, 0xffff0000	
	lb $t1, 0($t0)
	ori $t1, $t1, 0x02	
	sb $t1, 0($t0) 
	
	jal initGame
gameLoop:
	li $v0, 32
	lw $a0, timeInterval
	syscall
	
# TODO: objective 1, Handle Keyboard Input using MMIO 
	la $t0, KEYBOARD_EVENT_PENDING
	lw $t1, 0($t0)
	beq $t1, $zero, noKey 
	
	
	sw $zero,0($t0) #KEYBOARD_EVENT_PENDING
	
	la $t0,KEYBOARD_EVENT 
	lw $t1,0($t0)  
	
	
	
	
	beq $t1,LETTER_a,A_KEY  
	
	beq $t1,LETTER_d,D_KEY  

	beq $t1,LETTER_w,W_KEY  

	beq $t1,LETTER_s,S_KEY 
	beq $t1,113,Q_KEY #q
	beq $t1,114,R_KEY #r
	beq $t1,112,P_KEY #p
	
	b gameLoop 
	
	A_KEY:  
		li $t0, DIR_LEFT
		sw $t0, direction
		b  noKey
	D_KEY: 
		li $t0, DIR_RIGHT
		sw $t0, direction
		b  noKey
	W_KEY: 
		li $t0, DIR_UP
		sw $t0, direction
		b  noKey
	S_KEY: 
		li $t0, DIR_DOWN
		sw $t0, direction
		b  noKey
	Q_KEY: 
		li $t0, STATE_EXIT
		sw $t0, state
		b  noKey
	R_KEY: 
		li $t0, STATE_RESTART
		sw $t0, state
		b  noKey
	P_KEY: 
		lw $t0, state
		beq $t0,STATE_NORMAL,dopasue
		li $t0, STATE_NORMAL
		sw $t0, state
		j dopasue_end
dopasue:
		li $t0, STATE_PAUSE
		sw $t0, state
dopasue_end:

		sw $t0, state
		b  noKey
noKey:	

# TODO END
	
	lw $t0, state
	beq $t0, STATE_NORMAL, main.normal
	beq $t0, STATE_PAUSE, main.pause
	beq $t0, STATE_RESTART, main.restart
	j main.exit
main.normal:
	jal updateDisplay	
	j gameLoop
main.pause:
	j gameLoop
main.restart:
	jal initGame
	j gameLoop	
main.exit:
	la $a0, msgScore
	li $v0, 4
	syscall
	lw $a0, score
	li $v0, 1
	syscall
	li $v0, 10
	syscall
	
	
# void initGame()
initGame:
	sub $sp, $sp, 4
	sw $ra, ($sp)
	
	la $a0, displayBuffer
	li $a1, DISPLAY_BUFFER_SIZE
	jal clearBuffer
	
	jal initMap
	
	# initialize variables
	li $t0, INIT_LENGTH
	sw $t0, snakeLength
	li $t0, INIT_HEAD_X
	sw $t0, headX
	li $t0, INIT_HEAD_Y
	sw $t0, headY
	li $t0, DIR_RIGHT
	sw $t0, direction
		
	li $a0, INIT_HEAD_X
	li $a1, INIT_HEAD_Y
	jal pos2offset
	li $t0, SNAKE
	sw $t0, displayBuffer($v0)	# draw head pixel
	sw $v0, snakeSegment		# head offset

	li $a0, INIT_TAIL_X
	li $a1, INIT_TAIL_Y
	jal pos2offset
	li $t0, SNAKE
	sw $t0, displayBuffer($v0)	# draw tail pixel
	sw $v0, snakeSegment+4		# tail offset
	
	sw $zero, numPills
	li $t0, STATE_NORMAL
	sw $t0, state
	sw $zero, score
	
	# set seed for corresponding pseudorandom number generator using system time
	li $v0, 30
	syscall
	move $a1, $a0
	li $a0, 0	# ID = zero
	li $v0, 40
	syscall	
	
	# spawn food
	jal spawnFood
	jal spawnRedPills
	jal spawnPills

	lw $ra, ($sp)
	add $sp, $sp, 4	
	jr $ra
	
	
# void updateDisplay()
updateDisplay:
	sub $sp, $sp, 8
	sw $ra, ($sp)
	sw $s0, 4($sp)
	
	lw $a0, headX
	lw $a1, headY
	lw $t0, direction
	beq $t0, DIR_RIGHT, updateDisplay.goRight
	beq $t0, DIR_DOWN, updateDisplay.goDown
	beq $t0, DIR_LEFT, updateDisplay.goLeft
	beq $t0, DIR_UP, updateDisplay.goUp
updateDisplay.goRight:
	add $a0, $a0, 1
	blt $a0, WIDTH, updateDisplay.headUpdateDone
	sub $a0, $a0, WIDTH	# wrap over if exceeds boundary
	j updateDisplay.headUpdateDone
updateDisplay.goDown:
	add $a1, $a1, 1
	blt $a1, HEIGHT, updateDisplay.headUpdateDone
	sub $a1, $a1, HEIGHT	# wrap over if exceeds boundary
	j updateDisplay.headUpdateDone
updateDisplay.goLeft:
	sub $a0, $a0, 1
	bge $a0, 0, updateDisplay.headUpdateDone
	add $a0, $a0, WIDTH	# wrap over if exceeds boundary
	j updateDisplay.headUpdateDone
updateDisplay.goUp:
	sub $a1, $a1, 1
	bge $a1, 0, updateDisplay.headUpdateDone
	add $a1, $a1, HEIGHT	# wrap over if exceeds boundary
	j updateDisplay.headUpdateDone
updateDisplay.headUpdateDone:
	sw $a0, headX
	sw $a1, headY
	jal pos2offset
	move $s0, $v0		# store the head offset because we need it later

	lw $t0, displayBuffer($s0) # what is in the next posion of head?
	beq $t0, EMPTY, updateDisplay.empty
	beq $t0, FOOD, updateDisplay.food
	beq $t0, RED_PILL, updateDisplay.redPill
	beq $t0, BLUE_PILL, updateDisplay.bluePill
	# else hit into bad thing
	li $t0, STATE_EXIT
	sw $t0, state
	j updateDisplay.ObjectDetectionDone
	
updateDisplay.empty:	# nothing
	li $t0, SNAKE
	sw $t0, displayBuffer($s0)	# draw head pixel
	
	# erase old tail in display (set color to black)
	lw $t0, snakeLength
	sub $t0, $t0, 1
	sll $t0, $t0, 2
	lw $t1, snakeSegment($t0)	# load the tail offset
	li $t2, EMPTY
	sw $t2, displayBuffer($t1)
	
	j updateDisplay.ObjectDetectionDone
	
updateDisplay.food:	#regular food
	li $t0, SNAKE
	sw $t0, displayBuffer($s0)	# draw head pixel
	lw $t0, snakeLength
	add $t0, $t0, 1
	sw $t0, snakeLength	# increase snake length
	
	jal spawnFood
	lw $t0, score
	add $t0, $t0, 1
	sw $t0, score
	
	j updateDisplay.ObjectDetectionDone
	
updateDisplay.redPill:
	li $t0, SNAKE
	sw $t0, displayBuffer($s0)	# draw head pixel
	
	# erase old tail in display (set color to black)
	lw $t0, snakeLength
	sub $t0, $t0, 1
	sll $t0, $t0, 2
	lw $t1, snakeSegment($t0)	# load the tail offset
	li $t2, EMPTY
	sw $t2, displayBuffer($t1)
	
	lw $t0, numPills
	sub $t0, $t0, 1
	sw $t0, numPills
	
	# increase game speed
	lw $t0, timeInterval
	mtc1 $t0, $f0
	cvt.s.w $f0, $f0
	l.s $f1, incSpeed
	mul.s $f0, $f0, $f1
	cvt.w.s $f0, $f0
	mfc1 $t0, $f0
	sw $t0, timeInterval
	
	
	jal spawnRedPills
	lw $t0, numPills
	add $t0, $t0, 1
	sw $t0, numPills
	
	
	j updateDisplay.ObjectDetectionDone
	
updateDisplay.bluePill:
	li $t0, SNAKE
	sw $t0, displayBuffer($s0)	# draw head pixel
	
	# erase old tail in display (set color to black)
	lw $t0, snakeLength
	sub $t0, $t0, 1
	sll $t0, $t0, 2
	lw $t1, snakeSegment($t0)	# load the tail offset
	li $t2, EMPTY
	sw $t2, displayBuffer($t1)
	
	lw $t0, numPills
	sub $t0, $t0, 1
	sw $t0, numPills
	
	# decrease game speed
	lw $t0, timeInterval
	mtc1 $t0, $f0
	cvt.s.w $f0, $f0
	l.s $f1, decSpeed
	mul.s $f0, $f0, $f1
	cvt.w.s $f0, $f0
	mfc1 $t0, $f0
	sw $t0, timeInterval
	
	jal spawnPills
	lw $t0, numPills
	add $t0, $t0, 1
	sw $t0, numPills
	
	
	j updateDisplay.ObjectDetectionDone

updateDisplay.ObjectDetectionDone:
	
	
	# update snake segments
	# for i = length-1 to 1
	#	snakeSegment[i] = snakeSegment[i-1]
	# snakeSegment[0] = new head position (stored in $s0)
	lw $t0, snakeLength	# index i
updateDisplay.snakeUpdateLoop:
	sub $t0, $t0, 1
	blt $t0, 1, updateDisplay.snakeUpdateLoopDone
	sll $t1, $t0, 2		# convert index to offset
	sub $t2, $t1, 4		# offset of previous segment
	lw $t4, snakeSegment($t2)
	sw $t4, snakeSegment($t1) # snakeSegment[i] = snakeSegment[i-1]
	j updateDisplay.snakeUpdateLoop
updateDisplay.snakeUpdateLoopDone:
	sw $s0, snakeSegment	# update head offset in snakeSegment
	
	lw $ra, ($sp)
	lw $s0, 4($sp)
	add $sp, $sp, 8
	jr $ra
	

# int pos2offset(int x, int y)
# offset = (y * WIDTH + x) * 4
# Note that each pixel takes 4 bytes!
pos2offset:
	mul $v0, $a1, WIDTH
	add $v0, $v0, $a0
	sll $v0, $v0, 2
	jr $ra


# void spawnFood()
spawnFood:
	sub $sp, $sp, 4
	sw $ra, ($sp)
	
	# spawn regular food (yellow)
spawnFood.regular:
	li $a0, WIDTH	# range: 0 <= x < WIDTH
	jal randInt
	move $t0, $v0,	# position x
	li $a0, HEIGHT	# range: 0 <= y < HEIGHT
	jal randInt
	move $t1, $v0,	# position y
	move $a0, $t0
	move $a1, $t1
	jal pos2offset
	lw $t0, displayBuffer($v0)		# get "thing" on (x, y)
	bne $t0, EMPTY, spawnFood.regular	# find another place if it is not empty
	li $t0 FOOD
	sw $t0, displayBuffer($v0)	# put the food
	
	
	lw $ra, ($sp)
	add $sp, $sp, 4
	jr $ra
spawnPills:
	sub $sp, $sp, 4
	sw $ra, ($sp)
	
	# spawn regular food (yellow)
spawnPills.regular:
	li $a0, WIDTH	# range: 0 <= x < WIDTH
	jal randInt
	move $t0, $v0,	# position x
	li $a0, HEIGHT	# range: 0 <= y < HEIGHT
	jal randInt
	move $t1, $v0,	# position y
	move $a0, $t0
	move $a1, $t1
	jal pos2offset
	lw $t0, displayBuffer($v0)		# get "thing" on (x, y)
	bne $t0, EMPTY, spawnPills.regular	# find another place if it is not empty
	li $t0 BLUE_PILL
	sw $t0, displayBuffer($v0)	# put the food
	

# TODO END
	
	lw $ra, ($sp)
	add $sp, $sp, 4
	jr $ra
	
spawnRedPills:
	sub $sp, $sp, 4
	sw $ra, ($sp)
	
	# spawn regular food (yellow)
spawnRedPills.regular:
	li $a0, WIDTH	# range: 0 <= x < WIDTH
	jal randInt
	move $t0, $v0,	# position x
	li $a0, HEIGHT	# range: 0 <= y < HEIGHT
	jal randInt
	move $t1, $v0,	# position y
	move $a0, $t0
	move $a1, $t1
	jal pos2offset
	lw $t0, displayBuffer($v0)		# get "thing" on (x, y)
	bne $t0, EMPTY, spawnRedPills.regular	# find another place if it is not empty
	li $t0 RED_PILL
	sw $t0, displayBuffer($v0)	# put the food
	

# TODO END
	
	lw $ra, ($sp)
	add $sp, $sp, 4
	jr $ra

# void clearBuffer(char* buffer, int size)
clearBuffer:
	li $t0, 0
clearBuffer.loop:
	bge $t0, $a1, clearBuffer.return
	add $t1, $a0, $t0
	sb $zero, ($t1)
	add $t0, $t0, 1
	j clearBuffer.loop
clearBuffer.return:
	jr $ra


# int randInt(int max)
# generate an random integer n where 0 <= n < max
randInt:
	move $a1, $a0
	li $a0, 0
	li $v0, 42
	syscall
	move $v0, $a0
	jr $ra
	
# void initMap()
initMap:
# TODO: objective 3, Add Walls
# load the map file you create and add wall to displayBuffer
	addiu   $sp, $sp, -24
	sw      $ra, 0($sp)
	sw      $s0, 4($sp)
	sw      $s1, 8($sp)
	sw      $s2, 12($sp)
	sw      $s3, 16($sp)
	sw      $s4, 20($sp)
	
	li $a0,2048
	li $v0,9
	syscall
	move $s7,$v0
	li $v0, 13 # Service 13: open file
	la $a0, infile # Output file name
	li $a1, 0 # Write-only with create
	syscall # Open file
	move $s6,$v0
	

	li $v0, 14              # system call for read from file
	move $a0, $s6      
	move $a1, $s7      
	li $a2, 2048            # hardcoded buffer length
	syscall                 # read from file
	 
	li $v0, 4           # syscall for printing a string
	move $a0, $s7   
	#syscall
	
	li  $s1, 64             # s1 = 4
	li  $s2, 0             # i = 0
loop1:
	beq  $s2, 31, end1    # if (i >= 4) break
	li   $s3, 0            # j = 0
loop2:
	beq  $s3, 64, end2     # if (j >= 4) break
	mul  $t0, $s2, 65      # off = 4*4*i + 4*j
	mul  $t1, $s3, 1       #  cells[i][j] is
	add  $t0, $t0, $t1     #  done as *(cells+off)
	add  $t0, $t0, $s7
	lb   $s4, 0($t0)  # t0 = cells[i][j]
	
	move $a0,$s4
	li $v0,11
	syscall
	
	
beq $s4,'\n',skipdraw
beq $s4,'0',skipdraw
 
	move $a0, $s3
	move $a1, $s2
	jal pos2offset
	
	li $t0 WALL
	sw $t0, displayBuffer($v0)	# put the food
	
skipdraw:
	addi $s3, $s3, 1       # j++
	j    loop2
end2:
	addi $s2, $s2, 1       # i++
	j    loop1
end1:
# TODO END
	lw      $s4, 20($sp)
	lw      $s3, 16($sp)
	lw      $s2, 12($sp)
	lw      $s1, 8($sp)
	lw      $s0, 4($sp)
	lw      $ra, 0($sp)
	addiu   $sp, $sp, 24
	jr $ra
	
# TODO: add any helper functions here you if you need



# TODO END
