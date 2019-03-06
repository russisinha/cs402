.data
 	 array:	.word 3, 0, 1, 5, 10, -2
	.globl  main
.text
	main:   
        	li    $v1,0              # zero the sum
        	li    $t1,0              # init index to 0
        	li    $t2,0              # init loop counter
        
	for:    beq   $t2,6,endfor       # for ( i=0; i < 6 ;i++ )
        	lw    $v0,array($t1)
        	addu  $v1,$v1,$v0        #     sum = sum+array[i]
        	addi  $t1,$t1,4          #     increment index
        	addi  $t2,$t2,1          #     increment counter
        	b     for
 
	endfor:
		move $a0, $v1	 	# a0 = v1 or addu $a0, $v1, 0 
		li $v0, 1		# Print Integer	
		syscall	
        	li $v0,10             	# exit
        	syscall
