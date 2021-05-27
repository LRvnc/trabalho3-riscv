.data
msg1:	.asciz	"Qual é o número inteiro que estou pensando?"
msg2: 	.asciz	"Meu número é menor!"
msg3:	.asciz	"Meu número é maior!"
msg4:	.asciz	"Acertou! Meu número era "


.text

gerador:
	li a7, 42		# SYSCALL para random integer [0, 20]
	li a1, 20
	ecall			# Integer salvo em a0
	add a2, a0, zero	# salvando o integer em a2
	
perguntar:
	li a7, 51	# SYSCALL para perguntar "Qual é meu número?" => salva o inteiro em a0
	la a0, msg1
	ecall
	
	bgtu a0, a2, errou_maior
	bltu a0, a2, errou_menor
	beq a0, a2, acertou
	
errou_maior:
	li a7, 50
	la a0, msg2
	ecall
	b perguntar

errou_menor:
	li a7, 50
	la a0, msg3
	ecall
	b perguntar

acertou:
	li a7, 56
	la a0, msg4
	add a1, a2, zero
	ecall