.data
msg1:	.asciz	"Type a string: "
msg2:	.asciz	"String é palíndroma\n"
msg3:	.asciz	"String não é palíndroma\n"

string:		.space	256
str_no_ws:	.space 	256
ans:		.space	256

.text

# 1 - DEIXAR A STRING EM LETRAS MAIUSCULAS
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
	beq a3, zero, clear_spaces
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

# 2 - LIMPAR OS ESPAÇOS DA STRING E CARACTERES ESPECIAIS
clear_spaces:
	la a0, string
	la a2, str_no_ws
	li t0, 32	# Espaço em ASCII
	li t1, 45	# - em ASCII
	li t2, 44	# , em ASCII
	li t3, 46	# . em ASCII
	
loop_clear_spaces:
	lbu a3, 0(a0)
	addi a0, a0, 1
	beq a3, t0, loop_clear_spaces	# Verifica se o byte corresponde a uma vírgula, ponto, hífen ou espaço
	beq a3, t1, loop_clear_spaces
	beq a3, t2, loop_clear_spaces
	beq a3, t3, loop_clear_spaces
	beq a3, zero, inversao		# Verifica se chegou no fim da string => se sim, vai para a inversão
	sb a3, 0(a2)
	addi a2, a2, 1
	b loop_clear_spaces
	
# 3- INVERTER A STRING
inversao:
	la a0, str_no_ws
	
contar:
	lbu a3, 0(a0)
	beq a3, zero, corrigir
	addi a0, a0, 1
	b contar
	
corrigir:
	addi a0, a0, -1
	la a4, ans
	la a5, str_no_ws
	
loop_inverter:
	addi a0, a0, -1
	lbu a3, 0(a0)
	sb a3, 0(a4)
	addi a4, a4, 1
	bne a0, a5, loop_inverter
	
	li a3, 10
	sb a3, 0(a4)

# 4 - VERIFICAR SE A STRING É PALÍNDROMA
verificar:
	la a0, ans		# Carrega o endereço da string invertida (maiúscula e sem espaços)
	la a1, str_no_ws	# Carrega o endereço da string normal (maiúscula e sem espaços)
	
loop_verificar:
	lbu a2, 0(a0)
	lbu a3, 0(a1)
	bne a2, a3, not_palindroma	# Se os bytes forem diferentes, não é palíndroma
	addi a0, a0, 1
	addi a1, a1, 1
	beq a2, zero, is_palindroma	# Se a string acabar e não cair em 'not_palindroma', ela é palíndroma
	b loop_verificar

is_palindroma:
	li a7, 4	# Syscall to print
	la a0, msg2
	ecall		# Print
	li a7, 10	# Exit program
	ecall

not_palindroma:
	li a7, 4	# Syscall to print
	la a0, msg3
	ecall		# Print
	