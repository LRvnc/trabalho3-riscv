.data
msg1:	.asciz	"Type a string: "
msg2:	.asciz	"Upper case string: "

string:	.space	256

.text
	li a7, 4	# Syscall to print
	la a0, msg1
	ecall		# Print
	
	li a7, 8	# Syscall to read string
	la a0, string
	li a1, 256
	ecall		# Read string
	
loop_string:
	lbu a3, 0(a0)	# Pega um byte da string
	jal is_char	# Vai para verificação se o caracter é uma letra
	beq a3, zero, fim
	addi a0, a0, 1
	b loop_string
	
# Verifica se o caractere está no range das letras
is_char:
	li t0, 64
	and t1, a3, t0
	beq t1, t0, is_special
	ret

#Verifica se o caractere é uma letra ou um símbolo especial
is_special:
	li t0, 64	# é @ ?
	beq a3, t0, yes
	
	li t0, 91	# é [ ?
	beq a3, t0, yes
	
	li t0, 92	# é \ ?
	beq a3, t0, yes
	
	li t0, 93	# é ] ?
	beq a3, t0, yes
	
	li t0, 94	# é ^ ?
	beq a3, t0, yes
	
	li t0, 95	# é _ ?
	beq a3, t0, yes
	
	li t0, 96	# é ` ?
	beq a3, t0, yes
	
	li t0, 123	# é { ?
	beq a3, t0, yes
	
	li t0, 124	# é | ?
	beq a3, t0, yes
	
	li t0, 125	# é } ?
	beq a3, t0, yes
	
	li t0, 126	# é ~ ?
	beq a3, t0, yes
	
	li t0, 127	# é   ?
	beq a3, t0, yes
	
	li t0, 96
	bgtu a3, t0, converter	# Se o if chegar até aqui é porque é uma letra minúscula
	ret			# Se o jump anterior não for realizado, volta pro loop da string
	
yes:
	ret		# Retorna para o loop
	
converter:
	li t0, 32
	sub a3, a3, t0	# Converte lower case para uper case
	sb a3, 0(a0)
	ret
	
fim:
	li a7, 4	# Syscall to print
	la a0, msg2	
	ecall		# Print
	li a7, 4	# Syscall to print
	la a0, string	
	ecall		# Print