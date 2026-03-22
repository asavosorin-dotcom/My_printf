global print_num_bin
global print_char
global print_num_dec
global print_num_oct
global print_num_hex
global print_string
global exit

section .text 
global _start

_start: 
	;push 'L'
 	push 1
	push 2
	push 3
	push 10
	push 20
	push _string2_	

	call _my_printf_ 

	mov rax, 0x3c 
	xor rdi, rdi
 	syscall

;=================================================================================
; Notes: порядок аргументов от вершины стека: строка со спецификаторами, аргументы
; Registers: rcx - счетчик аргументов
;=================================================================================

_my_printf_:
	push rbp
	mov rbp, rsp
	add rbp, 16 
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
		cmp byte [rsi], '$'
		je exit
		
		inc rcx ; подумать куда вставлять увеличение счетчика
		inc rsi	
		mov bl, [rsi]
		sub rbx, 'a'
		inc rsi

		jmp [spec_table + rbx * 8]

		jmp _print_string 
		
	exit:
	pop rbp
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
	mov al, '$'
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
	mov al, '$'
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
	mov rax, [rbp + 8 * rcx] ; забрали число
	
	mov rdi, buff_num
	mov rsi, rdi

	.converting_num:	
		push rax
		and rax, 1
		call get_asci_code_reg
		pop rax
		shr rax, 1
		test rax, rax
		jnz .converting_num
	
	sub rdi, rsi
	mov rdx, rdi
	call make_buff_rev
	mov rsi, buff_rev

	mov rdi, 1	

	mov rax, 1	
	push rcx
	syscall
	pop rcx

	pop rsi
	jmp _print_string
	
print_num_dec:
print_num_oct:
print_num_hex:
jmp _print_string
; перенести первые 2 mov в print_num rdi-rsi=rdx обнуление можно не делать, так как сами задаем количество символов для печати
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
 
%include "data.s" 
