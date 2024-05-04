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
	sub rsp, 48
	mov esi, 5
	mov [rbp-16], esi
	mov esi, 8
	mov [rbp-8], esi
	mov esi, 0
	mov [rbp-24], esi
	mov edi, [rbp-8]
	mov eax, [rbp-24]
	add eax, edi
	mov [rbp-24], eax
	mov edi, [rbp-16]
	mov eax, [rbp-24]
	add eax, edi
	mov [rbp-24], eax
	mov esi, [rbp-24]
	lea rdi, [rel int_format]
	mov eax, 0
	call _printf
finish_up:	add rsp, 48
	leave 
	ret 

