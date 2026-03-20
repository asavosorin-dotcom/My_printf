section .text 
global _start 

_start: 
 	push _string_	
;	push '#'

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
		;можно вызывать parsing строки
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
	push rdi
	push rax
	push rcx

	mov rbp, rsp
	add rbp, 8 * 5 
		
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

 
section .data
;_string_: db `Hello\n` 
_string_: db `Hello %c !!!\n$`
_string_len equ $ - _string_
;vim:ft=nasm
