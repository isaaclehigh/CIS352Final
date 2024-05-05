section .data
	int_format db "%ld",10,0


	global _main
	extern _printf
section .text


_start:	call _main
	mov rax, 60
	xor rdi, rdi
	syscall


_main:	push rbp
	mov rbp, rsp
	sub rsp, 96
	mov esi, 1
	mov [rbp-24], esi
	mov esi, 0
	mov [rbp-32], esi
	mov edi, [rbp-32]
	mov eax, [rbp-24]
	cmp eax, edi
	mov [rbp-24], eax
	jz lab1259
	jmp lab1261
lab1259:	mov esi, 1
	mov [rbp-16], esi
	mov esi, [rbp-16]
	lea rdi, [rel int_format]
	mov eax, 0
	call _printf
	mov rax, 0
	jmp finish_up
lab1261:	mov esi, 2
	mov [rbp-8], esi
	mov esi, [rbp-8]
	lea rdi, [rel int_format]
	mov eax, 0
	call _printf
	mov rax, 0
	jmp finish_up
finish_up:	add rsp, 96
	leave 
	ret 

