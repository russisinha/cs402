.data	# Constants for messages.
	pr_a: .asciiz "Please enter decimal value:"
	res: .asciiz "Binary:"
	binary: .space 32
	.globl	main
.text	
	main:				
		li	$v0, 4		# Print message for decimal input
		la	$a0, pr_a	
		syscall			
		li	$v0, 5		# Read decimal input
		syscall			
		add $s0, $v0, $0
		li $s1, 2
		la $s2, binary
		la $s3, binary
		
	convert:
		slti $t2, $s0, 1
		beq $t2, 1, output
		divu $s0, $s1
		mfhi $t0		# remainder
		mflo $t1		# next value
		sb $t0, 0($s3)
		addi, $s3, $s3, 1
		move $s0, $t1
		j convert

	output:
		li	$v0, 4		# Print message for result
		la	$a0, res	
		syscall			
		addi, $s3, $s3, -1
		
	print:
		slt $t2, $s3, $s2
		beq $t2, 1, exit
		li	$v0, 1		# Print byte
		lb	$a0, 0($s3)
		syscall
		addi, $s3, $s3, -1
		j print
	
	exit:
		li 	$v0, 10		# exit program
		syscall			
		
