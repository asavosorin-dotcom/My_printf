
section .data

;_string_: db `Hello\n` 
_string_: db `Hello %c and %c !!!\n$`
_string_len equ $ - _string_

;spec_table:
	;dq case_a:  .no_print
	;case_b: dq print_num_bin
	;case_c: dq print_char
	;case_d: dq print_num_dec
	;case_e: dq .no_print
	;case_f: dq .no_print
	;case_g: dq .no_print
	;case_h: dq .no_print
	;case_i: dq .no_print
	;case_j: dq .no_print
	;case_k: dq .no_print
	;case_l: dq .no_print
	;case_m: dq .no_print
	;case_n: dq .no_print
	;case_o: dq print_num_oct
	;case_p: dq .no_print
	;case_q: dq .no_print
	;case_r: dq .no_print
	;case_s: dq print_string
	;case_t: dq .no_print
	;case_u: dq .no_print
	;case_v: dq .no_print
	;case_w: dq .no_print
	;case_x: dq print_num_hex
	;case_y: dq .no_print
	;case_z: dq .no_print
		
