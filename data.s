extern print_num_bin
extern print_char
extern print_num_dec
extern print_num_oct
extern print_num_hex
extern print_string
extern exit

section .data

;_string_: db `Hello\n` 
_string_: db `Hello %c and %c !!!\n$`
_string_len equ $ - _string_

spec_table:
	dq exit
	dq print_num_bin
	dq print_char
	dq print_num_dec
	dq exit
	dq exit
	dq exit
	dq exit
	dq exit
	dq exit
	dq exit
	dq exit
	dq exit
	dq exit
	dq print_num_oct
	dq exit
	dq exit
	dq exit
	dq print_string
	dq exit
	dq exit
	dq exit
	dq exit
	dq print_num_hex
	dq exit
	dq exit
