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
	sub rsp, 224
	mov esi, 1
	mov [rbp-56], esi
	mov esi, 0
	mov [rbp-8], esi
	mov edi, [rbp-8]
	mov eax, [rbp-56]
	cmp eax, edi
	mov [rbp-56], eax
	jz lab1267
	jmp lab1273
lab1267:	mov esi, 1
	mov [rbp-48], esi
	mov esi, 2
	mov [rbp-40], esi
	mov esi, 3
	mov [rbp-32], esi
	mov esi, [rbp-40]
	mov [rbp-112], esi
	mov edi, [rbp-32]
	mov eax, [rbp-112]
	imul eax, edi
	mov [rbp-112], eax
	mov esi, [rbp-48]
	mov [rbp-104], esi
	mov edi, [rbp-112]
	mov eax, [rbp-104]
	add eax, edi
	mov [rbp-104], eax
	mov esi, [rbp-104]
	lea rdi, [rel int_format]
	mov eax, 0
	call _printf
	mov rax, 0
	jmp finish_up
lab1273:	mov esi, 1
	mov [rbp-96], esi
	mov esi, 3
	mov [rbp-88], esi
	mov esi, 4
	mov [rbp-80], esi
	mov esi, [rbp-88]
	mov [rbp-16], esi
	mov edi, [rbp-80]
	mov eax, [rbp-16]
	add eax, edi
	mov [rbp-16], eax
	mov esi, [rbp-96]
	mov [rbp-72], esi
	mov edi, [rbp-16]
	mov eax, [rbp-72]
	sub eax, edi
	mov [rbp-72], eax
	mov esi, [rbp-72]
	lea rdi, [rel int_format]
	mov eax, 0
	call _printf
	mov rax, 0
	jmp finish_up
finish_up:	add rsp, 224
	leave 
	ret 

