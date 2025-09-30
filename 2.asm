%macro init 5
	mov byte[a1], %1
	mov byte[a2], %2
	mov byte[b1], %3
	mov byte[c1], %4
	mov byte[c2], %5
%endmacro

%macro init2 4
	mov byte[d1], %1
	mov byte[d2], %2
	mov byte[d3], %3
	mov byte[e1], %4
	mov byte[f1], 0
	mov byte[f2], 0
	mov byte[f3], 0
%endmacro

%macro init3 4
	mov byte[g1], %1
	mov byte[g2], %2
	mov byte[h1], %3
	mov byte[h2], %4
	mov byte[i1], 0
	mov byte[i2], 0
%endmacro

%macro init4 9
	mov byte[g1], %1
	mov byte[g2], %2
	mov byte[g3], %3
	mov byte[g4], %4
	mov byte[g5], %5
	mov byte[g6], %6
	mov byte[g7], %7
	mov byte[g8], %8
	mov byte[h8], %9
%endmacro

%macro init5 3
	mov byte[g2], %1
	mov byte[g3], %2
	mov byte[h3], %3
%endmacro

MYCODE: segment .code
org 100h
START:
	%ifdef COMMENT
	; 32
	call task32 ; a1=17h, a2=0ffh, b101h, c1=14h, c2=13h
	jmp run_end

	; 33
	init 17h, 0ffh, 01h, 14h, 13h
	call task33_1

	; 34
	init 17h, 00h, 02h, 00h, 00h
	call task34_1

	; 35
	init 01h, 0f0h, 0h, 0h, 0h
	call task35
	%endif

	%ifdef COMMENT
	; 36
	init2 12h, 34h, 05fh, 02h
	call task36
	init2 12h, 34h, 0ffh, 02h
	call task36
	init2 12h, 0ffh, 0ffh, 02h
	call task36	
	init2 0ffh, 0ffh, 0ffh, 02h
	call task36

	; 37
	init2 00h, 00h, 0ffh, 01h
	call task37
	init2 00h, 0ffh, 01h, 02h
	call task37
	init2 02h, 00h, 01h, 02h
	call task37
	init2 00h, 00h, 01h, 02h
	call task37

	; 38
	init3 0efh, 01h, 0fh, 0ffh
	call task38

	; 39
	init3 0ffh, 0fh, 0fh, 0ffh
	call task39
	%endif

	%ifdef COMMENT
	; 40
	init4 0efh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 002h
	call task40
	
	; 41
	init4 0efh, 000h, 000h, 000h, 000h, 000h, 000h, 002h, 005h
	call task41
	%endif

	; 42
	init5 010h, 020h, 030h
	call task42

	; program finish
	mov ax, 4C00h
	int 21h

task42:
	; i1,3 = g2,3 * h3
	; mul bx ; ax * bx -> dh, dl, ah, al
	; i1,3 = dl,ah,al
	mov ah, byte[g2]
	mov al, byte[g3]
	mov bh, 0
	mov bl, byte[h3]
	mul bx
	mov byte[i1], dl
	mov byte[i2], ah
	mov byte[i3], al
	ret

task41:
	; i1,8 = g1,8 - h8
	mov bh, 0
	mov bl, byte[h8]
	mov ah, byte[g7]
	mov al, byte[g8]
	sub ax, bx
	mov byte[i7], ah
	mov byte[i8], al
	mov ah, byte[g5]
	mov al, byte[g6]
	jnc task40_L1
	sub ax, 1
task41_L1:
	mov byte[i5], ah
	mov byte[i6], al
	mov ah, byte[g3]
	mov al, byte[g4]
	jnc task40_L2
	sub ax, 1
task41_L2:
	mov byte[i3], ah
	mov byte[i4], al
	mov ah, byte[g1]
	mov al, byte[g2]
	jnc task40_L3
	sub ax, 1
task41_L3:
	mov byte[i1], ah
	mov byte[i2], al
	ret

task40:
	; i1,8 = g1,8 + h8
	mov bh, 0
	mov bl, byte[h8]
	mov ah, byte[g7]
	mov al, byte[g8]
	add ax, bx
	mov byte[i7], ah
	mov byte[i8], al
	mov ah, byte[g5]
	mov al, byte[g6]
	jnc task40_L1
	add ax, 1
task40_L1:
	mov byte[i5], ah
	mov byte[i6], al
	mov ah, byte[g3]
	mov al, byte[g4]
	jnc task40_L2
	add ax, 1
task40_L2:
	mov byte[i3], ah
	mov byte[i4], al
	mov ah, byte[g1]
	mov al, byte[g2]
	jnc task40_L3
	add ax, 1
task40_L3:
	mov byte[i1], ah
	mov byte[i2], al
	ret

task39:
	; i1,2 = g1,2 - h1,2
	mov ah, byte[g1]
	mov al, byte[g2]
	mov bh, byte[h1]
	mov bl, byte[h2]
	sub ax, bx
	mov byte[i1], ah
	mov byte[i2], al
	ret

task38:
	; i1,2 = g1,2 + h1,2
	mov ah, byte[g1]
	mov al, byte[g2]
	mov bh, byte[h1]
	mov bl, byte[h2]
	add ax, bx
	mov byte[i1], ah
	mov byte[i2], al
	ret

task37:
	; f1,3 = d1,3 - e1
	mov ah, byte[d1]
	mov al, byte[d2]
	mov bh, byte[d3]
	mov bl, byte[e1]
	sub bh, bl
	jnc task37_L1
	sub al, 1
	jnc task37_L1
	sub ah, 1
task37_L1:
	mov byte[f1], ah
	mov byte[f2], al
	mov byte[f3], bh
	ret

task36:
	; f1,3 = d1,3 + e1
	mov ah, byte[d1]
	mov al, byte[d2]
	mov bh, byte[d3]
	mov bl, byte[e1]
	add bh, bl
	jnc task36_L1
	add al, 1
	jnc task36_L1
	add ah, 1
task36_L1:
	mov byte[f1], ah
	mov byte[f2], al
	mov byte[f3], bh
	ret

task35:
	mov ah, byte[a1]
	mov al, byte[a2]
	shl ah, 1
	shl al, 1
	jnc task35_L1
	inc ah
task35_L1:
	mov byte[c1], ah
	mov byte[c2], al
	ret

task34_1:
	mov ah, byte[a1]
	mov al, byte[a2]
	mov bl, byte[b1]
	sub al, bl
	jnc task34_1_L1
	dec ah
task34_1_L1:
	mov byte[c1], ah
	mov byte[c2], al
	ret

task33_1:
	mov ah, byte[a1]
	mov al, byte[a2]
	mov bl, byte[b1]
	add al, bl
	jnc task33_1_L1
	inc ah
task33_1_L1:
	mov byte[c1], ah
	mov byte[c2], al
	ret

task32:
	init 17h, 0ffh, 01h, 14h, 13h
	ret

task34:
	mov ah, byte[a1]
	mov al, byte[a2]
	xor bh, bh
	mov bl, byte[b1]
	sub ax, bx
	mov byte[c1], ah
	mov byte[c2], al
	ret

task33:
	mov ah, byte[a1]
	mov al, byte[a2]
	xor bh, bh
	mov bl, byte[b1]
	add ax, bx
	mov byte[c1], ah
	mov byte[c2], al
	ret

; data segment
	align 16, db 90h ; выравнивание, заполнить <NOP>
	db "=[MYDATA BEGIN]=" ; 16 байт
	db "A1A2 = ["
a1	db 0h
a2	db 0h
	db "]"
	align 16, db 0h
	db "B1   = .["
b1	db 0h
	db "]"
	align 16, db 0h
	db "C1C2 = ["
c1	db 0h
c2	db 0h
	db "]"
	align 16, db 0h
	times 16 db "="
	db "["
d1	db 0h
d2	db 0h
d3	db 0h
	db "]"
	align 16, db 0h
	db 0h, 0h, "["
e1	db 0h
	db "]"
	align 16, db 0h
	db "["
f1	db 0h
f2	db 0h
f3	db 0h
	db "]"
	align 16, db 0h
	times 16 db "="
	db "["
g1	db 0h
g2	db 0h
g3	db 0h
g4	db 0h
g5	db 0h
g6	db 0h
g7	db 0h
g8	db 0h
	db "]"
	align 16, db 0h
	db "["
h1	db 0h
h2	db 0h
h3	db 0h
h4	db 0h
h5	db 0h
h6	db 0h
h7	db 0h
h8	db 0h
	db "]"
	align 16, db 0h
	db "["
i1	db 0h
i2	db 0h
i3	db 0h
i4	db 0h
i5	db 0h
i6	db 0h
i7	db 0h
i8	db 0h
	db "]"
	align 16, db 0h
	times 16 db "="
