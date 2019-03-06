.data	# Constants for messages.
	res_space: .space 32
	buffer: .space 32
	pr_prompt: .asciiz "\n\nSelect a feature:\n"
	pr_1: .asciiz "1. Hexa to binary\n"
	pr_2: .asciiz "2. Decimal to hexa\n"
	pr_exit: .asciiz "3. Exit\n"
	inp_dec: .asciiz "Provide decimal value:"
	inp_hex: .asciiz "Provide hexadecimal value(8 characters required):"
	res: .asciiz "Result:"
	exit_msg: .asciiz "Goodbye!"
	hex_table: .byte '0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'
	.globl	main
.text
	main:				
		li	$v0, 4		# Print message for option selection
		la	$a0, pr_prompt	
		syscall			
		la	$a0, pr_1	# option 1
		syscall			
		la	$a0, pr_2	# option 2
		syscall			
		la	$a0, pr_exit	# option 3(exit)
		syscall			
		
		li	$v0, 5		# Read option input
		syscall			
		
		la $s2, res_space
		la $s3, res_space
		la $s4, hex_table
		
		beq $v0, 1, hexinput
		beq $v0, 2, decinput
		beq $v0, 3, exit
		
		j main
		
	
	hexinput:
		li	$v0, 4		# Print message for hexadecimal input
		la	$a0, inp_hex
		syscall
		li	$v0, 8		# Read hexadecimal input
		la $a0, buffer
		syscall			
		addi $s0, $a0, 8
		li $s6, 8		#counter for bytes
		#lw $s0, 0($s0)
		li $s1, 2
		j hextobinary

	decinput:
		li	$v0, 4		# Print message for decimal input
		la	$a0, inp_dec
		syscall
		li	$v0, 5		# Read decimal input
		syscall			
		add $s0, $v0, $0
		li $s1, 16
		j decimaltohex
		
	hextobinary:
		addi $s0, $s0, -1
		lb $t0, 0($s0)
		addi $s6, $s6, -1
		add $s7, $s4, $zero
		jal finddecimal
		sub $t1, $s7, $s4
		li $s5, 4		#counter for bits
		jal converttobinary
		ble $s0, $a0, output1
		j hextobinary
	
	finddecimal:
		lb $t7, 0($s7)
		addi $s7, $s7, 1
		#addi $s6, $s6, -1
		bne $t7, $t0, finddecimal
		addi $s7, $s7, -1
		j $ra
		
	converttobinary:
		slti $t2, $t1, 1
		bne $t2, 1, continue
	fillup:
		ble $s5, 0, back
		addi $s5, $s5, -1
		li $t0, 0
		sb $t0, 0($s3)
		addi, $s3, $s3, 1
		j fillup
	back:
		j $ra
		#andi $t1, $t0, 0xF
	continue:
		addi $s5, $s5, -1
		divu $t1, $s1
		mfhi $t0		# remainder
		mflo $t1		# next value
		sb $t0, 0($s3)
		addi, $s3, $s3, 1
		j converttobinary
	
	decimaltohex:
		slti $t2, $s0, 1
		beq $t2, 1, output2
		divu $s0, $s1
		mfhi $t0		# remainder
		mflo $t1		# next value
		add $t4, $s4, $t0
		lb $t0, 0($t4)
		sb $t0, 0($s3)
		addi, $s3, $s3, 1
		move $s0, $t1
		j decimaltohex

	output1:
		li	$v0, 4		# Print message for result
		la	$a0, res	
		syscall			
		addi, $s3, $s3, -1
		
	print1:
		slt $t2, $s3, $s2
		beq $t2, 1, main
		li	$v0, 1		# Print int
		lb	$a0, 0($s3)
		syscall
		addi, $s3, $s3, -1
		j print1
	
	
	output2:
		li	$v0, 4		# Print message for result
		la	$a0, res	
		syscall			
		addi, $s3, $s3, -1
		
	print2:
		slt $t2, $s3, $s2
		beq $t2, 1, main
		li	$v0, 11		# Print byte
		lb	$a0, 0($s3)
		syscall
		addi, $s3, $s3, -1
		j print2
	
	exit:
		li 	$v0, 4
		la	$a0, exit_msg
		syscall			
		li 	$v0, 10		# exit program
		syscall			
		
