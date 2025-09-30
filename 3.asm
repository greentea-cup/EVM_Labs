mycode: segment .code
org 100h
start:
	; call task_44
	; call task_45
	; call task_46
	; call task_47
	; call task_48
	; call task_49
	; call task_50
	; program finish
	mov ax, 4C00h
	int 21h

task_50:
	call read_char
	mov bl, al
	cmp al, "a"
	jl task_50_L1
	cmp al, "z"
	jg task_50_L1
	sub al, 20h
	mov bl, al
task_50_L1:
	call print_newline
	mov dl, bl
	call print_char
	call print_newline
	ret

task_49:
%macro task_49_m 1
	call read_char
	mov byte[%1], al
%endmacro
	task_49_m 4
	task_49_m 3
	task_49_m 2
	task_49_m 1
	task_49_m 0
	mov byte[5], "$"
	mov si, 0
	call print_string
	call print_newline
	ret

align 16, db 90h
task_48_table db 000h,001h,002h,003h,004h,005h,006h,007h,008h,009h,00ah,00bh,00ch,00dh,00eh,00fh,010h,011h,012h,013h,014h,015h,016h,017h,018h,019h,01ah,01bh,01ch,01dh,01eh,01fh,020h,021h,022h,023h,024h,025h,026h,027h,028h,029h,02ah,02bh,02ch,02dh,02eh,02fh,020h,020h,020h,020h,020h,020h,020h,020h,020h,020h,03ah,03bh,03ch,03dh,03eh,03fh,040h,041h,042h,043h,044h,045h,046h,047h,048h,049h,04ah,04bh,04ch,04dh,04eh,04fh,050h,051h,052h,053h,054h,055h,056h,057h,058h,059h,05ah,05bh,05ch,05dh,05eh,05fh,060h,061h,062h,063h,064h,065h,066h,067h,068h,069h,06ah,06bh,06ch,06dh,06eh,06fh,070h,071h,072h,073h,074h,075h,076h,077h,078h,079h,07ah,07bh,07ch,07dh,07eh,07fh,080h,081h,082h,083h,084h,085h,086h,087h,088h,089h,08ah,08bh,08ch,08dh,08eh,08fh,090h,091h,092h,093h,094h,095h,096h,097h,098h,099h,09ah,09bh,09ch,09dh,09eh,09fh,0a0h,0a1h,0a2h,0a3h,0a4h,0a5h,0a6h,0a7h,0a8h,0a9h,0aah,0abh,0ach,0adh,0aeh,0afh,0b0h,0b1h,0b2h,0b3h,0b4h,0b5h,0b6h,0b7h,0b8h,0b9h,0bah,0bbh,0bch,0bdh,0beh,0bfh,0c0h,0c1h,0c2h,0c3h,0c4h,0c5h,0c6h,0c7h,0c8h,0c9h,0cah,0cbh,0cch,0cdh,0ceh,0cfh,0d0h,0d1h,0d2h,0d3h,0d4h,0d5h,0d6h,0d7h,0d8h,0d9h,0dah,0dbh,0dch,0ddh,0deh,0dfh,0e0h,0e1h,0e2h,0e3h,0e4h,0e5h,0e6h,0e7h,0e8h,0e9h,0eah,0ebh,0ech,0edh,0eeh,0efh,0f0h,0f1h,0f2h,0f3h,0f4h,0f5h,0f6h,0f7h,0f8h,0f9h,0fah,0fbh,0fch,0fdh,0feh,0ffh
task_48:
	mov si, 0
	call read_string
	mov bh, 0
task_48_L1:
	cmp si, 0
	jz task_48_L2
	dec si
	mov bl, byte[si]
	mov cl, byte[task_48_table+bx]
	mov byte[si], cl
	jmp task_48_L1
task_48_L2:
	mov dx, 0
	call print_string
	call print_newline
	ret

align 16, db 90h
task_47_table_mut db "0123456789ABCDEF"
task_47: ; read (0..9 A..F), get number from it, print all numbers before it (excluding)
	call read_char
	mov bh, 0
	mov bl, al
	mov cl, byte[hex_to_num+bx] ; get number to al
	mov bl, cl
	mov byte[task_47_table_mut+bx], "$"
	call print_newline ; separate input from output
	mov dx, task_47_table_mut
	call print_string
	call print_newline
	mov al, cl ; get number to al
	; restore table
	mov cl, byte[num_to_hex+bx]
	mov byte[task_47_table_mut+bx], cl
	ret

align 16, db 90h
task_46_table db "123456789A-------BCDEF---------------------------BCDEF"
task_46: ; read (0..9 A..E), get number from it, increment, print number to console
	call read_char ; validity is not checked
	mov bh, 0
	mov bl, al
	mov cl, byte[hex_to_num+bx]
	sub al, "0"
	mov bl, al
	mov dl, byte[task_46_table+bx]
	call print_char
	call print_newline
	mov al, cl ; al = number
	ret

task_45: ; print numbers ih hexadecial (0..9 A..F)
%macro task_45_m 1
	mov bx, %1
	mov dl, byte[num_to_hex + bx]
	call print_char
%endmacro
	task_45_m 0
	task_45_m 1
	task_45_m 2
	task_45_m 3
	task_45_m 4
	task_45_m 5
	task_45_m 6
	task_45_m 7
	task_45_m 8
	task_45_m 9
	task_45_m 10
	task_45_m 11
	task_45_m 12
	task_45_m 13
	task_45_m 14
	task_45_m 15
	call print_newline
	ret

task_44: ; print numbers from dl (0..9) to console
%macro task_44_m 1
	mov dl, %1
	add dl, "0"
	call print_char
%endmacro
	task_44_m 0
	task_44_m 1
	task_44_m 2
	task_44_m 3
	task_44_m 4
	task_44_m 5
	task_44_m 6
	task_44_m 7
	task_44_m 8
	task_44_m 9
	call print_newline
	ret

; read single key from console
; out: dl if regular key was read
;      dh (dl=0) if special key was read
; used: ax
read_input:
	mov ah, 01h
	int 21h
	mov dl, al
	cmp al, 0h
	jz read_input_L1
	ret
read_input_L1: ; read second byte if special
	mov ah, 01h
	int 21h
	mov dh, al
	ret

; read key from console
; ignores special keys
; out: al - entered key
; used: ah
read_char_L1:
	mov ah, 01h
	int 21h
read_char:
	mov ah, 01h
	int 21h
	cmp al, 0h
	jz read_char_L1
	ret

; read sequence of keys from console
; ignores special keys (first byte is 0)
; in: si - output start address
; used: ax
read_string:
	call read_char
	mov byte[si], al
	inc si
	cmp al, 0dh ; 0dh == newline = end of string
	jnz read_string
	dec si
	mov byte[si], "$" ; replace newline (== string end) with $
	ret

; print single char to console
; in: dl - char to print
; used: ah
print_char:
	mov ah, 02h
	int 21h
	ret

; print sequence of chars to console
; sequence must end with '$'
; in: dx - string start address
; used: ah
print_string:
	mov ah, 09h
	int 21h
	ret

; clear console from any chars
; used: ax
clear_screen:
	mov ax, 03h
	int 10h
	ret

; print newline sequence to console
; used: ah, dl
print_newline:
	mov ah, 02h
	mov dl, 0ah
	int 21h
	mov dl, 0dh
	int 21h
	ret

; data segment
align 16, db 90h ; 90h == nop
; table to convert hex chars to numbers
; supported chars: 0..9 A..F a..f
hex_to_num db "------------------------------------------------",0,1,2,3,4,5,6,7,8,9,"-------",10,11,12,13,14,15,"--------------------------",10,11,12,13,14,15,"---------------------------------------------------------------------------------------------------------------------------------------------------------"
align 16, db 90h ; 90h == nop
; table to convert numbers to their hex char
; supported values: 0..15
num_to_hex db "0123456789ABCDEF"

