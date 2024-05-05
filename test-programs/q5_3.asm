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
	sub rsp, 144
	mov esi, 1
	mov [rbp-40], esi
	mov esi, [rbp-40]
	mov [rbp-48], esi
	mov esi, 2
	mov [rbp-32], esi
	mov esi, [rbp-32]
	mov [rbp-56], esi
	mov esi, 3
	mov [rbp-24], esi
	mov esi, [rbp-24]
	mov [rbp-16], esi
	mov esi, 0
	mov [rbp-8], esi
	mov edi, [rbp-8]
	mov eax, [rbp-48]
	cmp eax, edi
	mov [rbp-48], eax
	jz lab1264
	jmp lab1265
lab1264:	mov esi, [rbp-56]
	lea rdi, [rel int_format]
	mov eax, 0
	call _printf
	mov rax, 0
	jmp finish_up
lab1265:	mov esi, [rbp-16]
	lea rdi, [rel int_format]
	mov eax, 0
	call _printf
	mov rax, 0
	jmp finish_up
finish_up:	add rsp, 144
	leave 
	ret 

