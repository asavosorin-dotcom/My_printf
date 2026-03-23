global print_num_bin
global print_char
global print_num_dec
global print_num_oct
global print_num_hex
global print_string
global exit

section .text 
global _start
global _my_printf_
; можно сделать буфер с реверсом, а перед ним буфер для вывода или просто 0x, 0b и использовать его соответственно только для вывода

;_start:
;	;push 'L'
;	;push 103
;	;push 103
;	;push 103
;	;push 103
;
;	;push _string2_	
;
;	;call _my_printf_ 
;
;	mov rax, 0x3c 
;	xor rdi, rdi
; 	syscall

;==========================================================================================================================================
; Notes: первые 6 аргументов пушатся в стек, поэтому все аргменты в процессе вывода берутся из стека в прямом порядке от вершины
; В целях удобного доступа к 7, 8 и так далее аргументам в стеке, адрес возврата достается из стека в r10 и возвращается перед ret 
; Registers: rcx - счетчик аргументов, r10 - лежит адрес возврата (НЕ ТРОГАТЬ НЕ ПРИ КАКИХ ОБСТОЯТЕЛЬСТВАХ)
;=========================================================================================================================================

_my_printf_:
	pop r10 ; забрали адрес возврата
	push r9
	push r8
	push rcx
	push rdx
	push rsi
	push rdi

	push rbp
	mov rbp, rsp
	;add rbp, 16
	add rbp, 8 
	xor rcx, rcx
	mov rdi, 1
	mov rsi, [rbp]
 
	_print_string:
		mov rax, 1
		push rsi
		call parsing_string ; значение сразу кладется в rdx 
		add rsp, 8 ; убираем строку из стека не засоряя регистры

		push rcx
		syscall
		pop rcx

		add rsi, rdx ; сдвинули указатель на символ
		cmp byte [rsi], `\0` 
		je exit
		
		inc rcx ; подумать куда вставлять увеличение счетчика
		inc rsi	
		mov bl, [rsi]

		cmp bl, '%'
		jne .table
		
		mov rax, 1
		mov rdi, 1
		mov rdx, 1
		push rcx
		syscall
		pop rcx
		inc rsi
		jmp _print_string		

		.table:
		sub rbx, 'a'
		inc rsi
		
		jmp [spec_table + rbx * 8]

		jmp _print_string 
		
	exit:
	pop rbp
	add rsp, 48
	push r10
	ret

;================================================================
; Start: строка находится в стеке
; Return: rdx - количество символов в строке
;================================================================

get_string_len:
	push rbp
	push rdi
	push rax
	push rcx

	lea rbp, [rsp + 40]
		
	mov rdi, [rbp]; сохраняем начало строки
	mov al, `\0`
	mov rcx, 50 ; определить через макрос максимальный размер буффера

	repne scasb

	sub rcx, 50
	not rcx
	mov rdx, rcx

	pop rcx 
	pop rax
	pop rdi 	
	pop rbp
	ret


;================================================================
; Start: строка в стеке
; Return: длина строки до одного из специальных символов
;================================================================

parsing_string:
	push rbp
	push rdi
	push rax
	push rcx

	lea rbp, [rsp + 40]
		
	mov rdi, [rbp]; сохраняем начало строки
	mov al, `\0`
	mov ah, '%'
	mov rcx, 50 ; определить через макрос максимальный размер буффера

	.strchr:
	
		cmp byte [rdi], ah
		je .exit

		cmp byte [rdi], al
		je .exit
	
		inc rdi
		dec rcx
		jmp .strchr
	
	.exit:  
	
	sub rcx, 50
	not rcx
	mov rdx, rcx
	inc rdx

	pop rcx 
	pop rax
	pop rdi 	
	pop rbp
	ret

print_char:
	push rsi
	lea rsi, [rbp + 8 * rcx] 
	mov rdx, 1                                                     
	mov rax, 1

	push rcx
	syscall 
	pop rcx		
								       
	pop rsi
	jmp _print_string

print_string:
	push rsi
	mov rsi, [rbp + 8 * rcx]
	
	push rsi
	call get_string_len
	pop rsi

	mov rax, 1

	push rcx
	syscall
	pop rcx

	pop rsi
	jmp _print_string

print_num_bin:
	push rsi
	push rcx
	push rbx
	
	mov rax, [rbp + 8 * rcx] ; забрали число
	
	mov cl, 1
	mov rbx, 1
	jmp print_num_main

print_num_oct:
	push rsi
	push rcx
	push rbx
	
	mov rax, [rbp + 8 * rcx] ; забрали число
	
	mov cl, 3
	mov rbx, 7
	jmp print_num_main

print_num_hex:
	push rsi
	push rcx
	push rbx
	
	mov rax, [rbp + 8 * rcx] ; забрали число
	
	mov cl, 4
	mov rbx, 0fh
	jmp print_num_main

print_num_main:
	mov rdi, buff_num
	mov rsi, rdi

	.converting_num:	
		push rax
		and rax, rbx ; тут регистр с маской
		call get_asci_code_reg
		pop rax
		shr rax, cl ; тут регистр со сдвигом
		test rax, rax
		jnz .converting_num
	
	sub rdi, rsi
	mov rdx, rdi
	call make_buff_rev
	mov rsi, buff_rev

	mov rdi, 1	

	mov rax, 1	
	syscall

	pop rbx
	pop rcx
	pop rsi
	jmp _print_string
	
get_asci_code_reg:
	cmp al, 10
	jge .letter
		add al, '0'
		stosb
		ret

	.letter:
		lea rax, ['A' + rax - 10]
		stosb
		ret

make_buff_rev:
	push rcx
	lea rdi, [buff_rev + rdx - 1]
	mov rcx, rdx	
	
	.byte_cpy:
		cld
		lodsb
		std
		stosb
		loop .byte_cpy	

	cld
	pop rcx
	ret

print_num_dec:
	push rsi
	push rcx
	mov rdi, buff_num 
	mov rsi, rdi

	mov rax, [rbp + 8 * rcx]
	
	mov rcx, 10
	.converting_num:
		xor rdx, rdx
		div rcx			
		push rax
		mov rax, rdx
		call get_asci_code_reg
		pop rax
		test rax, rax
		jnz .converting_num
	
	sub rdi, rsi
	mov rdx, rdi
	call make_buff_rev
	mov rsi, buff_rev

	mov rax, 1
	mov rdi, 1
	syscall
	pop rcx
	pop rsi
	jmp _print_string 

%include "data.s" 
