extern print_num_bin
extern print_char
extern print_num_dec
extern print_num_oct
extern print_num_hex
extern print_string
extern print_num_float
extern exit

section .data
adress_ret dq 0
;_string_: db `Hello\n` 
_string_: db `Hello %b, I'm %c !!!\n$`
_string2_: db `%b\n%o\n%x\n%d\n$`
_name_: db `Yasha$`

buff_num times 8 dq 0
buff_rev times 8 dq 0

buff_print times 128 db 0
end_of_buff_print:
 
buff_float  times 16 dq 0

; написать обработчик ошибок
spec_table:
	  dq exit
	  dq print_num_bin
	  dq print_char
	  dq print_num_dec
	  dq exit
	  dq print_num_float
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

