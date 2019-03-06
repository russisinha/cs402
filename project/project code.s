.data	# Constants for messages.
	res_space: .space 32	# to store result value
	buffer: .space 32		# to store input value
	# menu 1
	menu1: .asciiz "\n\nMIPS Calculator Menu\n====================\n1. Addition\n2. Subraction\n3. Multiplication\n4. Division\n5. Conversions\n6. Exit\n\nEnter your choice: "
	# menu 2
	menu2: .asciiz "\nMIPS Conversions Menu\n=====================\n1. Decimal to Binary\n2. Decimal to Hexa\n3. Binary to Decimal\n4. Binary to Hexa\n5. Hexa to Decimal\n6. Hexa to Binary\n7. Back to Main Menu\n8. Exit\n\nEnter your choice: "
	op1: .asciiz "First operand:"	# operand 1 message
	op2: .asciiz "Second operand:"	# operand 2 message
	inp_dec: .asciiz "Provide decimal value:" # decimal input message
	inp_hex: .asciiz "Provide hexadecimal value(8 characters max):"		# hexadecimal input message
	inp_bin: .asciiz "Provide binary value(32 bits max):"	# binary input message
	res: .asciiz "\nResult:"	# result message
	remn: .asciiz "\nRemainder:"	# Remainder message(only for division operation)
	exit_msg: .asciiz "\nGoodbye!"	# exit message
	error_msg: .asciiz "Invalid input. Please try again!"	# error message
	hex_table: .byte '0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'	# hexadecimal list
	print_type: .space 1	# to store the print type for different output type
	.globl	main
.text

	main:		# main function
		li $v0, 4		# Print main menu
		la $a0, menu1
		syscall
		li $v0, 5		# Read user option
		syscall
		beq $v0, 1, addition			# branch to 'addition'
		beq $v0, 2, subtraction			# branch to 'subtraction'
		beq $v0, 3, multliplication		# branch to 'multiplication'
		beq $v0, 4, division			# branch to 'division'
		beq $v0, 5, displaymenu2		# branch to 'displaymenu2'. display conversion menu
		beq $v0, 6, exit				# exit program
		
		j error							# jump to error if no conditions satisfy
	
	error:					# error function
		li $v0, 4			# Print error message
		la $a0, error_msg	
		syscall
		j main				# return to main function
	
	addition:				# addition function
		jal getoperands		# jump to 'getoperands' functions to get user input for operands
		add $s0, $s0, $s1	# add operands
		j printresults		# jump to print function
		
	subtraction:			# subtraction function
		jal getoperands		# jump to 'getoperands' functions to get user input for operands
		sub $s0, $s0, $s1	# subtract operands
		j printresults		# jump to print function
	
	multliplication:		# multliplication function
		jal getoperands		# jump to 'getoperands' functions to get user input for operands
		mul $s0, $s0, $s1	# multiply operands
		j printresults		# jump to print function

	division:				# division function
		jal getoperands		# jump to 'getoperands' functions to get user input for operands
		div $s0, $s1		# divide operands
		mfhi $s0			# move remainder to $s0
		mflo $s1			# move result to $s1
		
		li $v0, 4			# Print message for result
		la $a0, res
		syscall
		li $v0, 1			# Print result value
		move $a0, $s1
		syscall
		
		li $v0, 4			# Print message for remainder
		la $a0, remn
		syscall
		li $v0, 1			# Print remainder value
		move $a0, $s0
		syscall
		
		j main				# return to main function
	
	getoperands:
		li $v0, 4			# Print message for first operand
		la $a0, op1
		syscall
		li $v0, 5			# accept first operand from user
		syscall
		move $s0, $v0		# store first operand in register
		li $v0, 4			# Print message for second operand
		la $a0, op2
		syscall
		li $v0, 5			# accept second operand from user
		syscall
		move $s1, $v0		# store second operand in register
		j $ra
		
	printresults:
		li $v0, 4			# Print message for result
		la $a0, res
		syscall
		li $v0, 1			# Print result value
		move $a0, $s0
		syscall
		j main
	
	displaymenu2:
		li $v0, 4			# Print conversion menu
		la $a0, menu2
		syscall
		li $v0, 5			# Read user option
		syscall
		la $s2, res_space	# get address to store result value
		la $s3, res_space	# get address to traverse through result value(for printing result)
		la $s4, hex_table	# get address to compare hex values
		
		beq $v0, 1, dectobin	# branch to 'dectobin'
		beq $v0, 2, dectohex	# branch to 'dectohex'
		beq $v0, 3, bintodec	# branch to 'bintodec'
		beq $v0, 4, bintohex	# branch to 'bintohex'
		beq $v0, 5, hextodec	# branch to 'hextodec'
		beq $v0, 6, hextobin	# branch to 'hextobin'
		beq $v0, 7, main		# return to main menu
		beq $v0, 8, exit		# exit program
		
		j error					# jump to error if no conditions satisfy
	
	hextobin:					# convert hexadecimal to binary
		li $s6, 0
		jal hexinput			# get hexadecimal input
		la $s0, buffer			# get address for user input string
		la $s1, buffer			# get address for user input string to traverse through the string
		jal findendaddress		# get address of last input byte
		jal setdefault			# set default values for conversion
		jal hextodec_c			# convert hex to decimal
		move $s0, $t1			# store decimal value in a different register for further conversion
		li $s1, 2				# store base value for conversion
		j dectobin_c			# convert the decimal value to binary
	
	hextodec:					# hexadecimal to binary conversion
		li $s6, 0
		jal hexinput			# get hexadecimal input
		la $s0, buffer			# get address for user input string
		la $s1, buffer			# get address for user input string to traverse through the string
		jal findendaddress		# get address of last input byte
		jal setdefault			# set default values for conversion
		jal hextodec_c			# convert hex to decimal
		j decimaloutput			# print the converted value
	
	hextodec_c:						# hexadecimal to binary conversion (continued)
		addi $s0, $s0, -1			# decrease address value from the last byte
		lb $t0, 0($s0)				# traverse through each input value
		sw $ra, 0($sp)				# store return address for further use
		add $s7, $s4, $zero			# copy hexadecimal list address for comparison
		jal finddecimal				# find address of hexadecimal value
		sub $t0, $s7, $s4			# subtract the values to get the actual value
		lw $ra, 0($sp)				# load return address
		mul $t2, $t0, $s6			# multiply hex value with the multiplier
		add $t1, $t1, $t2			# add above result to the sum
		sll $s6, $s6, 4				# increase value of the multiplier for next iteration
		bgt $s0, $s1, hextodec_c	# repeat if all hex values have not been traversed through
		j $ra
	
	bintohex:					# binary to hexadecimal conversion
		li $s6, 0
		jal bininput			# get binary input
		la $s0, buffer			# get address for user input string
		la $s1, buffer			# get address for user input string to traverse through the string
		jal findendaddress		# get address of last input byte
		jal setdefault			# set default values for conversion
		jal bintodec_c			# convert binary to decimal
		li $s1, 16				# store base value for conversion
		move $s0, $t1			# store decimal value in a different register for further conversion
		j dectohex_c			
	
	bintodec:					# binary to decimal conversion
		li $s6, 0
		jal bininput			# get binary input
		la $s0, buffer			# get address for user input string
		la $s1, buffer			# get address for user input string to traverse through the string
		jal findendaddress		# get address of last input byte
		jal setdefault			# set default values for conversion
		j bintodec_output		# print result
	
	setdefault:				# set default values in registers for use in conversions
		li $t1, 0
		li $s6, 1
		j $ra
	
	bintodec_c:						# binary to decimal conversion (continued)
		addi $s0, $s0, -1			# decrease address value from the last byte
		lb $t0, 0($s0)				# decrease address value from the last byte
		sw $ra, 0($sp)				# store return address for further use
		jal getbinvalue				# get binary value of input string
		lw $ra, 0($sp)				# load return address
		mul $t2, $t0, $s6			# multiply hex value with the multiplier
		add $t1, $t1, $t2			# add above result to the sum
		sll $s6, $s6, 1				# increase value of the multiplier for next iteration
		bgt $s0, $s1, bintodec_c	# repeat if all hex values have not been traversed through
		j $ra
	
	bintodec_output:				# output for binary to decimal conversion
		jal bintodec_c				# convert binary to decimal value
		j decimaloutput				# print result
	
	getbinvalue:					# get binary value from string input
		lb $t2, 0($s4)				# load input string byte
		bne $t2, $t0, nextval		# check if string equals to 1
		li $t0, 0					# set binary bit to 0
		j $ra
	nextval:						# if string equals to 0
		li $t0, 1					# set binary bit to 1
		j $ra
	
	findendaddress:					# find address of last byte of user input string
		lb $t0, 0($s0)				# load string byte to detect new line
		addi $s0, $s0, 1			# traverse through entire string input
		addi $s6, $s6, 1
		bne $t0, '\n', findendaddress	# detect end of input string (detect newline)
		addi $s0, $s0, -1			# go back to last user input string
		j $ra
	
	bininput:				# binary input function
		li $v0, 4			# Print message for binary input
		la $a0, inp_bin
		syscall
		li $v0, 8			# Read binary input
		la $a0, buffer		# store input in reserved space as string
		syscall
		j $ra
	
	hexinput:				# hexadecimal input function
		li $v0, 4			# Print message for hexadecimal input
		la $a0, inp_hex
		syscall
		li $v0, 8			# Read hexadecimal input
		la $a0, buffer		# store input in reserved space as string
		syscall
		#addi $s0, $a0, 8
		#li $s6, 8			#counter for bytes
		j $ra

	decinput:				# decimal input function
		li $v0, 4			# Print message for decimal input
		la $a0, inp_dec
		syscall
		li $v0, 5			# Read decimal input
		syscall
		add $s0, $v0, $0	# store decimal input value in register
		j $ra
	
	dectobin:						# decimal to binary conversion
		li $s1, 2
		jal decinput				# get decimal input
	dectobin_c:						# decimal to binary conversion (continued)
		blt $s0, 1, binaryoutput	# print output if result cannot be divided anymore
		divu $s0, $s1				# divide input by base value
		mfhi $t0					# remainder
		mflo $t1					# result - next value
		sb $t0, 0($s3)				# store remainder in memory
		addi, $s3, $s3, 1			# get next address to store binary bit
		move $s0, $t1				# make the result as input for next iteration
		j dectobin_c				# repeat funtion till result is 0
	
	finddecimal:					# find decimal value for string
		lb $t7, 0($s7)				# get value from hexadecimal list
		addi $s7, $s7, 1			# go to next address
		#addi $s6, $s6, -1
		bne $t7, $t0, finddecimal	# if value does not match input string, repeat the function
		addi $s7, $s7, -1			
		j $ra
			
	dectohex:					# decimal to hexadecimal conversion
		li $s1, 16				# set base value for conversion
		jal decinput			# het decimal input
	dectohex_c:					# decimal to hexadecimal conversion (continued)
		blt $s0, 1, hexoutput	# print output if result cannot be divided anymore
		divu $s0, $s1			# divide input by base value
		mfhi $t0				# remainder
		mflo $t1				# result - next value
		add $t4, $s4, $t0		# copy hedecimal list address location for remainder value
		lb $t0, 0($t4)			# get hex value from hexadecimal list
		sb $t0, 0($s3)			# store hex value in memory
		addi, $s3, $s3, 1		# get next address to store hexadecimal value
		move $s0, $t1			# make the result as input for next iteration
		j dectohex_c			# repeat funtion till result is 0
	
	decimaloutput:		# decimal output
		li $v0, 4		# Print message for result
		la $a0, res
		syscall
		li $v0, 1		# Print result
		move $a0, $t1
		syscall
		j main			# return to main function
	
	binaryoutput:			# set default values for binary output
		la $t8, print_type	# store print code (value = 1) in memory to print binary values
		li $t9, 1
		sb $t9, 0($t8)
		j output
	
	hexoutput:				# set default values for hexadecimal output
		la $t8, print_type	# store print code (value = 11) in memory to print hexadecimal values
		li $t9, 11
		sb $t9, 0($t8)
		j output
	
	output:
		li $v0, 4		# Print message for result
		la $a0, res
		syscall
		addi $s3, $s3, -1
		
	print:
		slt $t2, $s3, $s2
		beq $t2, 1, main	# if the result has been printed, go to main function
		la $t8, print_type	# load print code address 
		lb $t9, 0($t8)		# load print code value from memory (different for hexadecimal and binary)
		move $v0, $t9		# Print result
		lb $a0, 0($s3)		# load value to be printed 
		syscall
		addi $s3, $s3, -1	# next memory address for printing result
		j print				# iterate through all result values until everything is printed
	
	exit:					# exit function
		li $v0, 4
		la $a0, exit_msg	# print exit message
		syscall
		li $v0, 10			# exit program
		syscall
		
