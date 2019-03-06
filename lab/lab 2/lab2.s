.data	# Constants for messages.
	pr_a: .asciiz "Please enter value of 'a':"
	pr_b: .asciiz "Please enter value of 'b':"
	pr_c: .asciiz "Please enter value of 'c':"
	pr_x: .asciiz "Please enter value of 'X':"

	res: .asciiz "Result:"
	.globl	main
.text	
	main:				
		li	$v0, 4		# Print message for input 'a'
		la	$a0, pr_a	
		syscall			
		li	$v0, 5		# Read input 'a'
		syscall			
		add $t0, $v0, $0
		
		li	$v0, 4		# Print message for input 'b'
		la	$a0, pr_b	
		syscall			
		li	$v0, 5		# Read input 'b'
		syscall			
		add $t1, $v0, $0
		
		li	$v0, 4		# Print message for input 'c'
		la	$a0, pr_c	
		syscall			
		li	$v0, 5		# Read input 'c'
		syscall			
		add $t2, $v0, $0
		
		li	$v0, 4		# Print message for input 'X'
		la	$a0, pr_x	
		syscall			
		li	$v0, 5		# Read input 'X'
		syscall			
		add $t3, $v0, $0
		
		mul $t4, $t3, $t3	# X*X
		mul $t4, $t0, $t4	# a*X*X
		mul $t5, $t1, $t3	# b*X
		add $t6, $t4, $t5	# a*X*X + b*X
		add $t6, $t6, $t2	# a*X*X + b*X + c
		
		li	$v0, 4		# Print message for result
		la	$a0, res	
		syscall			
		li	$v0, 1		# Print result
		move $a0, $t6	
		syscall			
		
		
		li 	$v0, 10		# exit program
		syscall			
		
