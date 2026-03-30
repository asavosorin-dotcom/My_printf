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

NaN_string db "Nan"
Inf_string db "Inf"

spec_table:
	  dq exit            ; a        -------------------------
	  dq print_num_bin   ; %b
	  dq print_char      ; %c
	  dq print_num_dec   ; %d
	  dq exit	     ; e        --------------------------
	  dq print_num_float ; %f
	  times 8 dq exit    ; ghij klmn ------------------------- 
	  dq print_num_oct   ; %o
	  times 3 dq exit    ; pqr      --------------------------
	  dq print_string    ; %s       
	  times 4 dq exit    ; tuvw     -------------------------- 
	  dq print_num_hex   ; %x
