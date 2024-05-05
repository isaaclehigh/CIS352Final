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
	mov esi, 3
	mov [rbp-24], esi
	mov esi, 4
	mov [rbp-16], esi
	mov esi, [rbp-24]
	mov [rbp-8], esi
	mov edi, [rbp-16]
	mov eax, [rbp-8]
	add eax, edi
	mov [rbp-8], eax
	mov esi, [rbp-8]
	mov [rbp-32], esi
	mov esi, 2
	mov [rbp-72], esi
	mov esi, [rbp-32]
	mov [rbp-64], esi
	mov edi, [rbp-72]
	mov eax, [rbp-64]
	sub eax, edi
	mov [rbp-64], eax
	mov esi, [rbp-64]
	mov [rbp-40], esi
	mov esi, [rbp-32]
	mov [rbp-56], esi
	mov edi, [rbp-40]
	mov eax, [rbp-56]
	add eax, edi
	mov [rbp-56], eax
	mov esi, [rbp-56]
	mov [rbp-48], esi
	mov esi, [rbp-48]
	lea rdi, [rel int_format]
	mov eax, 0
	call _printf
	mov rax, 0
	jmp finish_up
finish_up:	add rsp, 144
	leave 
	ret 

