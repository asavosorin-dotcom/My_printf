section .text 

global _start 
_start: 
 	push _string_	
	call _my_printf_ 
	push _string_	
	call _my_printf_ 

	mov rax, 0x3c 
	xor rdi, rdi
 	syscall 

;================================================================
; Notes: порядок аргументов от вершины стека: строка
;================================================================
_my_printf_:
	push rbp
	mov rbp, rsp
	add rbp, 16 ;указывает на строку (если длина адреса все таки 8 байт)

	mov rax, 0x01
	mov rdi, 1
	mov rsi, [rbp]
	push _string_	

	call get_string_len ; значение сразу кладется в rdx 
	add rsp, 8 ; убираем строку из стека не засоряя регистры

	;mov rdx, _string_len  
	syscall

	pop rbp
	ret

;================================================================
; Start: строка находится в стеке
; Return: rdx - количество символов в строке
;================================================================


get_string_len:
	push rbp
	mov rbp, rsp
	add rbp, 16
		
	mov rdx, [rbp]; сохраняем начало строки 
	.count:   	
		inc rdx
		cmp byte [rdx], '$'
		jne .count
	
	sub rdx, [rbp]
	pop rbp
	ret

 
section .data
;_string_: db `Hello\n` 
_string_: db `Hello \nI'm Yasha!!!\n$`
_string_len equ $ - _string_
