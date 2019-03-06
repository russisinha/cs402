.data
	hello: .asciiz "\n hello world, CS350/402 students"
.globl main
.text
	main:
		li $v0, 4 	# system call code for Print String
		la $a0, hello	# load address of prompt into $a0
		syscall        # call system call
		li $v0,10      # system call code for exit (end of program)
		syscall        # call system call