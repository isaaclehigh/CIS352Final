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
	mov esi, 1
	mov [rbp-24], esi
	mov esi, 2
	mov [rbp-16], esi
	mov esi, [rbp-24]
	mov [rbp-8], esi
	mov edi, [rbp-16]
	mov eax, [rbp-8]
	add eax, edi
	mov [rbp-8], eax
	mov esi, [rbp-8]
	lea rdi, [rel int_format]
	mov eax, 0
	call _printf
	mov rax, 0
	jmp finish_up
finish_up:	add rsp, 48
	leave 
	ret 

