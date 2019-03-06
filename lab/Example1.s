.data	# String constants for messages.
	pr1: .asciiz "Please enter a string:"
	pr2: .asciiz "You entered:"
	msg: .asciiz "Welcome to class CS350/CS402!\n"
	buf: .space 200	 # Space for the input string.
	.globl	main
.text	
	main:					
		li	$v0, 4		# Print prompt string.	
		la	$a0, pr1	
		syscall	
		li	$v0, 8		# Read string.	
		la	$a0, buf	# Buffer	
		li	$a1, 200	# Length of buffer	
		syscall			# Print the messages and the string		
		li	$v0, 4	
		la	$a0, pr2	
		syscall	
		li	$v0, 4	
		la	$a0, buf	
		syscall	
		li	$v0, 4	
		la	$a0, msg	
		syscall		
		li 	$v0, 10      	# system call code for exit (end of program)
		syscall       		# call system call