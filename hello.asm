.data
ask:	.asciz	"Type our name: "
hello:	.asciz	"Hello, "
name:	.space	256

.text
	la	a0, ask
	jal	print
	
	li	a7, 8	# ReadString
	la	a0, name
	li	a1, 256
	ecall
	
	la	a0, hello
	jal	print
	
	la	a0, name
	jal	print
	
	li	a7, 10	# Exit
	ecall
	
print:
	li	a7, 4	# PrintString
	ecall
	ret