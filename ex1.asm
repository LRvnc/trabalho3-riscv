.data
ask:	.asciz	"Type a string: "
string:	.space	256
ans:	.space	256
msg:	.asciz	"Inverted string: "

.text
	li a7, 4	# Syscall to print
	la a0, ask
	ecall		# Print
	
	li a7, 8	# Syscall to read string
	la a0, string
	li a1, 256
	ecall		# Read string
	
contar:
	# Levando a0 para último byte da string
	lbu a3, 0(a0)
	beq a3, zero, corrigir
	addi a0, a0, 1
	b contar
	
corrigir:
	addi a0, a0, -1
	la a4, ans
	la a5, string
	
inverter:
	addi a0, a0, -1
	lbu a3, 0(a0)
	sb a3, 0(a4)
	addi a4, a4, 1
	bne a0, a5, inverter
	
	li a3, 10
	sb a3, 0(a4)

fim:
	li a7, 4	# Syscall to print
	la a0, msg
	ecall		# Print
	li a7, 4	# Syscall to print
	la a0, ans
	ecall		# Print	