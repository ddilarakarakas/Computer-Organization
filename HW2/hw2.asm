.data 
array: .space 400
arrayBonus: .space 400
arrayBonusSize: .word 0
strPos: .asciiz "\nPossible!"
strNot: .asciiz "\nNot Possible!"
strSize: .asciiz "Enter size: "
strInsert: .asciiz "\nEnter Value\n"
strTarget: .asciiz "\nEnter Target: "
strSpace: .asciiz " "

.text
.globl main

main:
	li $v0, 4
	la $a0, strSize
	syscall
	li $v0, 5
	syscall
	move $a1, $v0		#size
	li $v0, 4
	la $a0, strTarget
	syscall
	li $v0, 5 
	syscall
	move $a2, $v0		#target
	li $v0, 4
	la $a0, strInsert
	syscall
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	addi $s0, $s0, 0		# i=0 
	jal InsertLoop		#For loop
	
	lw $s0 0($sp)
	addi $sp, $sp, 4
	jal CheckSumPossibility
	move $a3, $v0
	jal Print
	li $v0, 10		#exit
	syscall

InsertLoop:
	slt $t0, $s0, $a1	#if(i<size)
	beq $t0, $zero, LoopExit
	la $t1, array
	sll $t2, $s0, 2	
	add $t1, $t1, $t2     	#array[i]
	li $v0, 5
	syscall
	move $t3, $v0		#value
	sw $t3, 0($t1)		# array[i] = value
	addi $s0, $s0,1		#i++
	j InsertLoop	
		  
	 
	
BonusPrint:
	addi $t5, $t5, 1   #i++
	slt $t3, $t5, $t1	#i < arrayBonusSize
	beq $t3, $zero, Exit
	sll $t6, $t5, 2
	la $t2, arrayBonus
	add $t2, $t2, $t6
	lw $a0, 0($t2)
	li $v0,1
	syscall
	li $v0, 4
    	la $a0, strSpace
    	syscall
    	j BonusPrint
	 
Exit:
	li $v0, 4
	la $a0, strPos
	syscall
	jr $ra
LoopExit:
	jr $ra
		  
Print:
	slti $t0, $a3, 1
	beq $t0, $zero, PrintTrue
	li $v0, 4
	la $a0, strNot
	syscall
	jr $ra
	
PrintTrue:
	addi $t5, $t5, -1
	lw $t1, arrayBonusSize
	j BonusPrint	
			
CheckSumPossibility:	
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a1, 4($sp)  #size
	sw $a2, 8($sp)	#target
	
	beq $a2, $zero, return1
	beq $a1, $zero, return0
	
	addi $t0, $a1, -1
	sll $t0, $t0, 2
	la $t1, array
	add $t1, $t1, $t0
	lw $t0, 0($t1)		#array[size-1] = t0
	#
	slt $t1, $a2, $t0
	beq $t1, 1, recursive1
	
	addi $a1, $a1, -1 
	jal CheckSumPossibility
	beq $v0, 1 , return1 
	# second case of the or
	
	add $t0, $a1, $zero
	sll $t0, $t0, 2
	la $t1, array
	add $t1, $t1, $t0
	lw $t0, 0($t1)		#array[size-1] = t0
	sub $a2, $a2, $t0
	move $s7, $t0		# store for bones case
	addi $sp, $sp, -4
	sw $s7, 0($sp)
	jal CheckSumPossibility	
	lw $s7, 0($sp)
	addi $sp, $sp, 4
	beq $v0, 1, BonusCase 	#if return == 1
	j return0
	
BonusCase:
	la $t0, arrayBonus
	lw $t1, arrayBonusSize			#store array[size-1] in bonusArray				
	sll $t4, $t1, 2
	add $t0, $t0, $t4
	sw $s7, 0($t0)
	addi $t1, $t1, 1
	sw $t1, arrayBonusSize
	j return1

recursive1:
	addi $a1, $a1, -1 
	jal CheckSumPossibility
	beq $v0, $zero, return0
	j return1
	
return1:
	lw $ra, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	addi $sp, $sp, 12
	li $v0, 1
	jr $ra
	
return0:
	lw $ra, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	addi $sp, $sp, 12
	li $v0, 0
	jr $ra		
