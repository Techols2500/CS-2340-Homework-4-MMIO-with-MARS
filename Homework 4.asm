# Tyler Echols
# Assignment 4 
# CS 2340.004 - Computer Architecture - F20
# Karen Mazidi
########################################################################################
# Objective:  To gain experience working with memory-mapped I/O.
######################################################################################## 

# Instructions: 
#   Connect bitmap display:
#         set pixel dim to 4x4
#         set display dim to 256x256
#	use $gp as base address
#   Connect keyboard and run
#	use w (up), s (down), a (left), d (right), space (exit)
#	all other keys are ignored


.data  
# hight of screen in pixels
.eqv	HIGHT 64
# hight of screen of pixels (0, 0)
.eqv	WIDTH 64	

# Colors 
.eqv	RED 	0x00FF0000
.eqv	GREEN	0x0000FF00
.eqv	BLUE	0x000000FF
.eqv	WHITE	0x00FFFFFF
.eqv	YELLOW	0x00FFFF00
.eqv	CYAN	0x0000FFFF
.eqv	MAGENTA	0x00FF00FF 

.data 
Array: .word	MAGENTA CYAN YELLOW WHITE BLUE GREEN RED 
 

.text 
main: 
#$a1 = holding our X position
#$a2 = Holding our Y position 
#$s1 = folding Pixel Position 

	la $t0, WIDTH	# loading width into $t0
	la $t1, HIGHT  # loading height into $t1 
	div $a1, $t0, 2  # divide $t0, and 2 into $a1 
	div $a2, $t1, 2  # divide $$1, and 2 into $a2 
	li $t2, 0	# $t2 is ittreator to loop through colors 
	li $t3, 0 	# $t3 is check to see if we hit the number of pixels we have set to display, the line   
	li $t4, 0	# $t4 starting value for marqee effect, the array 
							
	PixelDirection: 
	jal PixelPrint1 
	
	lw $t5, 0xffff0000 # $t5 is the holding value of user input 
	beq $t5, 0, PixelDirection 
	
	 # process input
	lw 	$s1, 0xffff0004
	beq	$s1, 32, exit		# input space
	beq	$s1, 119, ShiftUp 	# input w
	beq	$s1, 115, ShiftDown 	# input s
	beq	$s1, 97, ShiftLeft 	# input a
	beq	$s1, 100, ShiftRight	# input d
	
	# invalid input, ignore
	j	PixelDirection   
						   								   								   								   								   								   							
	PixelPrint1: 
	mul	$s1, $a2, WIDTH # storing WIDTH and value of $a2 into $s1 
	add 	$s1, $s1, $a1 	# taking hight of 64, and hight of 64/2 storei into $s1 
	mul	$s1, $s1, 4	# add to base address 
	add	$s1, $s1, $gp 	# $gp and $s1 in new $s1
	mul 	$a3, $t2, 4 	# 
	
	lw	$a3, Array($a3) # this is saying take the color from the array and keep it in $a3    
	sw	$a3, 0($s1) # storing $s1 to print out in $a3 
	
	# checks to see how many times we print out 
	beq 	$t3, 7, ResetItoritor2 # when program loops 7 times exit loop
	bge	$t4, 6, ResetStartColor  # whenever we hit the end of array set $t4 to 0 
	addi 	$t3, $t3, 1 # this is adding 1 to our counter ($t3)
	addi 	$a1, $a1, 1 # adds 1 to our x
	add 	$t2, $t2, 1 # looping through the array 
	
	bge	$t2, 7, ResetColor # looping through whole array 
	  
	li 	$v0, 32
	li	$a0, 5
	syscall
	      
	j 	PixelPrint1   
	
	PixelPrint2: 
	mul	$s1, $a2, WIDTH # storing WIDTH and value of $a2 into $s1 
	add 	$s1, $s1, $a1 # taking hight of 64, and hight of 64/2 storei into $s1 
	mul	$s1, $s1, 4	# add to base address 
	add	$s1, $s1, $gp 	# $gp and $s1 in new $s1
	mul 	$a3, $t2, 4 	# 
	
	lw	$a3, Array($a3)    
	sw	$a3, 0($s1) # storing to print out
	
	# checks to see how many times we print out  
	beq 	$t3, 7, ResetItoritor3 # when program loops 7 times exit loop 
	addi 	$t3, $t3, 1 # this is adding 1 to our counter ($t3)
	addi 	$a2, $a2, 1 # adds 1 to our x
	add 	$t2, $t2, 1 # looping through the array 
	
	bge	$t2, 7, ResetColor2 
	
	li 	$v0, 32
	li	$a0, 5
	syscall 
	      
	j 	PixelPrint2
	
	
	PixelPrint3: 
	mul	$s1, $a2, WIDTH # storing WIDTH and value of $a2 into $s1 
	add 	$s1, $s1, $a1 # taking hight of 64, and hight of 64/2 storei into $s1 
	mul	$s1, $s1, 4	# add to base address 
	add	$s1, $s1, $gp 	# $gp and $s1 in new $s1
	mul 	$a3, $t2, 4 	# 
	
	lw	$a3, Array($a3)    
	sw	$a3, 0($s1) # storing to print out
	
	# checks to see how many times we print out 
	beq 	$t3, 7, ResetItoritor4 # when program loops 7 times exit loop 
	addi 	$t3, $t3, 1 # this is adding 1 to our counter ($t3)
	subi 	$a1, $a1, 1 # adds 1 to our x
	addi 	$t2, $t2, 1 # looping through the array 
	
	bge	$t2, 7, ResetColor3  
	
	li 	$v0, 32
	li	$a0, 5
	syscall 
	      
	j 	PixelPrint3
	
	
	PixelPrint4: 
	mul	$s1, $a2, WIDTH # storing WIDTH and value of $a2 into $s1 
	add 	$s1, $s1, $a1 # taking hight of 64, and hight of 64/2 storei into $s1 
	mul	$s1, $s1, 4	# add to base address 
	add	$s1, $s1, $gp 	# $gp and $s1 in new $s1
	mul 	$a3, $t2, 4 	# 
	
	lw	$a3, Array($a3)     
	sw	$a3, 0($s1) # storing to print out
	
	# checks to see how many times we print out 
	beq 	$t3, 7, ResetItoritor1 # when program loops 7 times exit loop 
	addi 	$t3, $t3, 1 # this is adding 1 to our counter ($t3)
	subi 	$a2, $a2, 1 # adds 1 to our x
	addi 	$t2, $t2, 1 # looping through the array 
	
	bge	$t2, 7, ResetColor4 
	
	li 	$v0, 32
	li	$a0, 5
	syscall  
	      
	j 	PixelPrint4
	
	
	ShiftUp: 
	jal 	BlackOut1 
	subi 	$a2, $a2, 1 # adds 1 to our x 
	j	PixelDirection   
	
	 
	ShiftDown: 
	jal	BlackOut1 
	addi 	$a2, $a2, 1 # adds 1 to our x 
	j	PixelDirection  
	
	ShiftLeft: 
	jal 	BlackOut1 
	subi 	$a1, $a1, 1 # adds 1 to our x 
	j	PixelDirection   
	
	ShiftRight: 
	jal 	BlackOut1 
	addi 	$a1, $a1, 1 # adds 1 to our x 
	j	PixelDirection       
	   				   								   				
	BlackOut1:
	mul	$s1, $a2, WIDTH # storing WIDTH and value of $a2 into $s1 
	add 	$s1, $s1, $a1 	# taking hight of 64, and hight of 64/2 storei into $s1 
	mul	$s1, $s1, 4	# add to base address 
	add	$s1, $s1, $gp 	# $gp and $s1 in new $s1
	# mul 	$a3, $t2, 4 	# 
	
	li 	$a3, 0 # this is black at $a3    
	sw	$a3, 0($s1) # storing $s1 to print out in $a3 
	
	# checks to see how many times we print out  
	beq 	$t3, 7, ResetBlackOut2 # when program loops 7 times exit loop
	addi 	$t3, $t3, 1 # this is adding 1 to our counter ($t3)
	addi 	$a1, $a1, 1 # adds 1 to our x
	
	      
	j 	BlackOut1    
	
	BlackOut2: 
	mul	$s1, $a2, WIDTH # storing WIDTH and value of $a2 into $s1 
	add 	$s1, $s1, $a1 # taking hight of 64, and hight of 64/2 storei into $s1 
	mul	$s1, $s1, 4	# add to base address 
	add	$s1, $s1, $gp 	# $gp and $s1 in new $s1
	# mul 	$a3, $t2, 4 	# 
	
	li	$a3, 0   
	sw	$a3, 0($s1) # storing to print out
	
	# checks to see how many times we print out  
	beq 	$t3, 7, ResetBlackOut3 # when program loops 7 times exit loop 
	addi 	$t3, $t3, 1 # this is adding 1 to our counter ($t3)
	addi 	$a2, $a2, 1 # adds 1 to our x
	    
	j 	BlackOut2
	
	BlackOut3: 
	mul	$s1, $a2, WIDTH # storing WIDTH and value of $a2 into $s1 
	add 	$s1, $s1, $a1 # taking hight of 64, and hight of 64/2 storei into $s1 
	mul	$s1, $s1, 4	# add to base address 
	add	$s1, $s1, $gp 	# $gp and $s1 in new $s1
	# mul 	$a3, $t2, 4 	# 
	
	li	$a3, 0     
	sw	$a3, 0($s1) # storing to print out
	# checks to see how many times we print out 
	 
	beq 	$t3, 7, ResetBlackOut4 # when program loops 7 times exit loop 
	addi 	$t3, $t3, 1 # this is adding 1 to our counter ($t3)
	subi 	$a1, $a1, 1 # adds 1 to our x
	      
	j 	BlackOut3 
	
	BlackOut4: 
	mul	$s1, $a2, WIDTH # storing WIDTH and value of $a2 into $s1 
	add 	$s1, $s1, $a1 # taking hight of 64, and hight of 64/2 storei into $s1 
	mul	$s1, $s1, 4	# add to base address 
	add	$s1, $s1, $gp 	# $gp and $s1 in new $s1
	# mul 	$a3, $t2, 4 	# 
	
	li	$a3, 0    
	sw	$a3, 0($s1) # storing to print out
	# checks to see how many times we print out 
	 
	beq 	$t3, 7, BackToColor # when program loops 7 times exit loop 
	addi 	$t3, $t3, 1 # this is adding 1 to our counter ($t3)
	subi 	$a2, $a2, 1 # adds 1 to our x
	      
	j 	BlackOut4
	
	BackToColor:
	li 	$t3, 0
	jr	$ra
	
	
	ResetBlackOut2:
	li 	$t3, 0
	j 	BlackOut2  
	
	ResetBlackOut3:
	li 	$t3, 0
	j 	BlackOut3 
	
	ResetBlackOut4:
	li 	$t3, 0
	j 	BlackOut4
	
	
	# Resetcolor rester's itoritor of the array 
	ResetColor: 
	li 	$t2, 0 
	j 	PixelPrint1
	
	ResetColor2:
	li	$t2, 0 
	j PixelPrint2 
	  
	ResetColor3:
	li	$t2, 0 
	j PixelPrint3 
	
	ResetColor4:
	li	$t2, 0 
	j PixelPrint4  
	
	ResetItoritor1:
	li	$t3, 0
	addi 	$t4, $t4, 1  # $t4 is marking the starting index of which colors we want to print 
	addi	$t2, $t4, 0 # Reset the index of the $t2 by assignint it to be $t4 whole 
	jr	$ra                   
	
	ResetItoritor2: 
	li 	$t3, 0
	addi	$t2, $t4, 0 
	j 	PixelPrint2 
	
	ResetItoritor3: 
	li 	$t3, 0 
	addi	$t2, $t4, 0
	j 	PixelPrint3 
	
	ResetItoritor4: 
	li 	$t3, 0 
	addi	$t2, $t4, 0
	j 	PixelPrint4
	
	ResetStartColor: 
	li	$t4, 0	# $t4 has been reset to 0 
	j	PixelPrint1  
	
 exit:	
	li $v0, 10
	syscall
