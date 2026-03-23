global print_num_bin
global print_char
global print_num_dec
global print_num_oct
global print_num_hex
global print_string
global exit

PRINT_BUFF_SIZE equ 128

section .text 
global _start
global _my_printf_
; сделать буферизацию (вместо syscall, lodsb в буффер)
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
	mov rsi, [rbp]
	mov rdi, buff_print
 
	_print_string:
		call parsing_string ; значение сразу кладется в rdx 
		xor rbx, rbx

		cmp byte [rsi], `\0` 
		je exit
		
		inc rcx ; подумать куда вставлять увеличение счетчика
		inc rsi ; убираем %	
		mov bl, [rsi]

		cmp bl, '%'
		jne .table
		
		lodsb
		stosb
		call check_print_buff
		
		jmp _print_string		

		.table:
		sub rbx, 'a'
		inc rsi
		
		jmp [spec_table + rbx * 8]

		jmp _print_string 

	
	exit:
	sub rdi, buff_print
	mov rdx, rdi
	inc rdx ;!!!!!!!!!!!!
	mov rax, 1
	mov rdi, 1
	mov rsi, buff_print
	syscall 
		
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
	push rax
	push rcx

	mov bl, `\0`
	mov bh, '%'
	mov rcx, 50 ; определить через макрос максимальный размер буффера

	.strchr:
	
		cmp byte [rsi], bh
		je .exit

		cmp byte [rsi], bl
		je .exit
	
		lodsb
		stosb

		call check_print_buff

		jmp .strchr
	
	.exit:  
	
	pop rcx 
	pop rax
	ret

print_char:
	mov rax, [rbp + 8 * rcx]
	stosb
	call check_print_buff	
	jmp _print_string

print_string:
	push rsi

	mov rsi, [rbp + 8 * rcx] 

	.cpy_byte:
		lodsb
		stosb
		call check_print_buff
		cmp byte [rsi], 0
		jne .cpy_byte	
	
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
	push rdi

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

	; буфферизация	
	sub rdi, rsi
	mov rdx, rdi

	pop rdi
	
	call make_buff_rev

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
	add rdi, rdx
	push rdi
	dec rdi 
	mov rcx, rdx	
	
	.byte_cpy:
		cld
		lodsb
		std
		stosb
		cld
		call check_print_buff
		loop .byte_cpy	

	pop rdi
	pop rcx
	ret

print_num_dec:
	push rsi
	push rcx
	push rdi

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
	pop rdi

	call make_buff_rev

	pop rcx
	pop rsi
	jmp _print_string 

check_print_buff:
	push rax
	push rdx
	push rsi
	push rcx

	cmp rdi, end_of_buff

	jne .end_fun
		mov rax, 1
		mov rdi, 1
		mov rdx, PRINT_BUFF_SIZE
		mov rsi, buff_print
		syscall
	
	mov rdi, buff_print
	
	.end_fun:	
	pop rcx
	pop rsi
	pop rdx
	pop rax	
	
	ret

%include "data.s" 
