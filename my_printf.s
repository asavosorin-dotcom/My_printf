default rel

global print_num_bin
global print_char
global print_num_dec
global print_num_oct
global print_num_hex
global print_num_float
global print_string
global exit

PRINT_BUFF_SIZE equ 128
extern printf
section .text 
global _start
global _my_printf_

; Сделать вывод только до 6 знака и повысить точно при помощи rdx в умножении на 10 rax

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
; Registers: rcx - счетчик аргументов в стеке, r15 - лежит адрес возврата (НЕ ТРОГАТЬ НЕ ПРИ КАКИХ ОБСТОЯТЕЛЬСТВАХ), r10 - счетчик аргумент
; ов в векторе с float
;=========================================================================================================================================

_my_printf_:
	pop rax ; забрали адрес возврата
	push r9
	push r8
	push rcx
	push rdx
	push rsi
	push rdi

	push rbp
	push rbx

	lea r13, [rel buff_float]
	movups [r13], xmm0
	movups [r13 + 8], xmm1
	movups [r13 + 8 * 2], xmm2
	movups [r13 + 8 * 3], xmm3
	movups [r13 + 8 * 4], xmm4
	movups [r13 + 8 * 5], xmm5
	movups [r13 + 8 * 6], xmm6
	movups [r13 + 8 * 7], xmm7

	xor r10, r10

	lea r13, [rel adress_ret]	
	mov [r13], rax
	mov rbp, rsp
	add rbp, 16
	;add rbp, 8 
	xor rcx, rcx
	mov rsi, [rbp]
	lea rdi, [rel buff_print]
 
	_print_string:
		call parsing_string ;
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
		dec rcx
		call check_print_buff
		
		jmp _print_string		

		.table:
		
		inc rsi

		.below_8:
		
		lea r13, [rel spec_table]
		jmp [r13 + (rbx - 'a') * 8]
 
		; jmp [spec_table + rbx * 8 - 'a' * 8]
		; jmp [(spec_table - 'a' * 8) + rbx * 8]
		jmp _print_string 

	
	exit:
	lea r13, [rel buff_print]
	sub rdi, r13
	mov rdx, rdi
	;inc rdx ;!!!!!!!!!!!!
	mov rax, 1
	mov rdi, 1
	lea rsi, [rel buff_print]
	syscall 
	
	pop rbx		
	pop rbp

	pop rdi
	pop rsi
	pop rdx
	pop rcx
	pop r8
	pop r9

	;mov rax, 0
	call printf wrt ..plt 

	lea r13, [rel adress_ret]	
	push [r13]
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
	push rcx
	cmp r10, 8
	jb .below_8
	
		add rcx, r10
		sub rcx, 8

	.below_8:
	mov rax, [rbp + 8 * rcx]
	pop rcx
	stosb
	call check_print_buff	
	jmp _print_string

print_string:
	push rsi

	push rcx
	cmp rcx, 6
	jb .rcx_below_6
	cmp r10, 8
	jb .below_8
	
		add rcx, r10
		sub rcx, 8

	.below_8:
	.rcx_below_6:
	mov rsi, [rbp + 8 * rcx]
	pop rcx


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
	
	push rcx
	
	cmp rcx, 6
	jb .rcx_below_6
	cmp r10, 8
	jb .below_8
	
		add rcx, r10
		sub rcx, 8

	.below_8:
	.rcx_below_6:
	mov rax, [rbp + 8 * rcx]
	pop rcx
	
	mov cl, 1
	mov rbx, 1
	jmp print_num_main

print_num_oct:
	push rsi
	push rcx
	push rbx

	push rcx
	cmp r10, 8

	
	cmp rcx, 6
	jb .rcx_below_6
	cmp r10, 8
	jb .below_8

	
		add rcx, r10
		sub rcx, 8

	.below_8:
	.rcx_below_6:

	mov rax, [rbp + 8 * rcx]
	pop rcx
	
	mov cl, 3
	mov rbx, 7
	jmp print_num_main

print_num_hex:
	push rsi
	push rcx
	push rbx
	
	push rcx
	cmp r10, 8


	cmp rcx, 6
	jb .rcx_below_6
	cmp r10, 8
	jb .below_8

	
		add rcx, r10
		sub rcx, 8

	.below_8:
	.rcx_below_6:

	mov rax, [rbp + 8 * rcx]
	pop rcx
	
	mov cl, 4
	mov rbx, 0fh
	jmp print_num_main

print_num_main:
	push rdi

	lea rdi, [rel buff_num]
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

	lea r13, [rel end_of_buff_print]
	cmp rdi, r13
	jb no_flush
		call check_print_buff
		add rdi, rdx
	no_flush:
  
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
	
	push rcx
	
	cmp rcx, 6
	jb .rcx_below_6
	cmp r10, 8
	jb .below_8

	
		add rcx, r10
		sub rcx, 8

	.below_8:
	.rcx_below_6:

	mov rax, [rbp + 8 * rcx]
	pop rcx

	test rax, 1000000000000000000000000000000b ; 2 ^ 31; 32 бит
	jz plus 
	
	push rax
	mov rax, '-'
	stosb
	call check_print_buff	
	pop rax
	
	not eax 	
	inc eax
	plus:
	push rdi
	lea rdi, [rel buff_num] 
	mov rsi, rdi	
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

	lea r13, [rel end_of_buff_print]
	cmp rdi, r13

	jb .end_func
		mov rax, 1
		mov rdi, 1
		mov rdx, PRINT_BUFF_SIZE
		lea rsi, [rel buff_print]
		syscall
	
	lea rdi, [rel buff_print]
	
	.end_func:	
	pop rcx
	pop rsi
	pop rdx
	pop rax	
	
	ret

; будет счетчик вещественных чисел в их векторе
print_num_float:
	push rsi

	lea rsi, [rel buff_float]

	dec rcx
	
	cmp r10, 8
	jge get_double_from_stack
		lea r13, [rel buff_float]
		mov rbx, [r13 + r10 * 8] ; забрали double	
		jmp end_of_get_double		

	get_double_from_stack:
		cmp rcx, 6
		jb .below_6
		push rcx
		push r10
		;sub rcx, 6
		sub r10, 8
		add rcx, r10
		mov rbx, [rbp + rcx * 8 + 8]
		pop r10
		pop rcx
		jmp end_of_get_double
		.below_6:
			mov rbx, [rbp + 6 * 8 + r10 - 8]

	end_of_get_double:
	push rcx 
	inc r10
	bt rbx, 63
	jnc .without_minus
		
		mov rax, '-'
		stosb
		call check_print_buff

	.without_minus:
	push rdi ; сохраняем положение в buff_print
;===================== кладем экспоненту в rcx =================================
	push rbx
	mov rax, 7FF0000000000000h
	and rbx, rax 
	shr rbx, 52 ; оставляем только экспоненту
	mov rcx, rbx
	sub rcx, 1023 ; считаем реальную экспоненту
	pop rbx
;===============================================================================

; ===================== достаем мантиссу в rdx =================================
	push rbx
	mov rax, 0FFFFFFFFFFFFFh 
	mov rdx, rbx ; достаем мантиссу  
	and rdx, rax
	mov rax, 1 << 52
	or rdx, rax ; поставили 1 в 1.xxxxb
	pop rbx
; ==============================================================================
; если экспонента больше, чем 23, то у числа нет дробной части и можно вывести .0
; если экспонента больше 0, то сдвиг точки идет вправо и наобарот

	push rcx
	push rdx
	lea rdi, [rel buff_num]

	not rcx
        add rcx, 52 ; индекс '.' в двоичной записи числа
	inc rcx  
                               
	call convert_fractional_to_int
	call make_num_dec	
	mov al, '.'
	mov r14, rdi
	sub r14, 6

	lea r13, [rel buff_num]
	cmp r14, r13
	jg .end_of_count_start_buffer_num
		lea r14, [rel buff_num] 
	.end_of_count_start_buffer_num:
	stosb
	pop rdx

	pop rcx
	not rcx
	add rcx, 52
	inc rcx


	shr rdx, cl ; оставили целую часть 	
	mov rax, rdx

	call make_num_dec
	
	sub rdi, r14
	mov rdx, rdi
	pop rdi
	mov rsi, r14
	call make_buff_rev

	pop rcx
	pop rsi		
	jmp _print_string	
;======================================================================================================================
; Notes: преобразует число rax в последовательность аски-кодов, соответсвующая записи числа rax в 10 системе счисления 
; Start: rax - число для преобразования
;	 rdi - буффер для записи последовательностей кодов
; Destr: rax, rdi
;======================================================================================================================
make_num_dec:
	push rcx
	push rdx
	
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
	
	pop rdx
	pop rcx
	ret

;======================================================================================================================
; Notes: преобразует дробную часть числа в целое число, соответствующее десятичному представлению дробной части числа
; Start: rdx - мантисса, rcx - экспонента
; Regs: rbx - номер проверяемого бита из дробной части
;       r11 - степень 5 соответствующая номеру итерации 
; Ret: rax - целое число
;======================================================================================================================

; у
; забираем степень 5
; умножаем на 5
; добавляем при необходимости результат


convert_fractional_to_int:
	push rcx
	push rdx

	;mov rbx, 1
	;shl rbx, cl ; маска для получения бита в дроби слева направо



	;push rax
	;mov rax, rdx
	;and rax, rbx
	mov r11, 1
	xor rax, rax
	xor rbx, rbx
	;test rax, rax
	;pop rax
	.convert:
		test rcx, rcx
		jz .end_of_convert
	
		cmp rbx, 18 
		je .end_of_convert

		push rdx
		mul r11, 5
		mul rax, 10
		pop rdx	
		
		dec rcx
		inc rbx

		bt rdx, rcx
		jnc .convert

		add rax, r11
		jmp .convert	

	.end_of_convert:	
	pop rdx
	pop rcx
	ret

%include "data.s" 
