cpu 386 ; i386 реальный режим
; макрос для инициализации строки (task2)
; %1 - адрес строки = di
%macro minit_str 1 ; addr
	mov di, %1
	call init_str
%endmacro

; макрос для записи строки c нулём в секцию .data
%macro mstring 2 ; addr, string literal
	[section .data]
%1 db %2, 0
	__SECT__
%endmacro

; макрос для записи данных (байт, символов) в секцию .data
%macro mdata 2+ ; addr, data
	[section .data]
%1 db %2
	__SECT__
%endmacro

%macro mstrcpy 2 ; addrfrom, addrto
	mov si, %1
	call strlen
	mov di, %2
	mov cx, bx
	cld
	rep movsb
%endmacro

; сохранить текстовую строку %2 и скопировать её в %1
%macro mstrcpyc 2 ; addr, string literal
	mdata %%string, %2
	%strlen LEN %2
	mov si, %%string
	mov di, %1
	mov cx, LEN
	cld
	rep movsb
	mov byte[di], 0
%endmacro

; %1 - адрес строки = si
; %2 - количество символов "#" = bx
%macro mtask3 2
	mov di, %1
	mov cx, %2
	call task3
%endmacro

; %1 - адрес строки = si
; %2 - индекс вставки = cx
; %3 - символ для втсавки = ah
%macro mtask8 3
	mov si, %1
	mov cx, %2
	mov ah, %3
	call task8
%endmacro

; %1 - адрес строки = si
; %2 - позиция символа = ah
; %3 - символ для вставки = al
%macro mtask8_1 3
	mov si, %1
	mov ah, %2
	mov al, %3
	call task8_1
%endmacro

; %1 - адрес строки = di
; %2 - номер искомого символа = ah
; %3 - искомый символ = al
%macro mtask11 3
	mov di, %1
	mov ah, %2
	mov al, %3
	call task11
%endmacro

; %1 - адрес строки = si
; %2 - искомый символ = al
%macro mtask12 2
	mov si, %1
	mov al, %2
	call task12
%endmacro

section .text
org 100h
start:
	; call task1
	; call task2
	
	; mov byte[str1+20], "$" ; чтобы проверить, где был конец строки
	; mtask3 str1, 20 ; заполнить str1 20 символами "#" + нулем 

	; записать в bx длину str1 (=20)
	; mov si, str1
	; call task4

	; mstrcpyc str1, "I am string"
	; mtask8 str1, 5, "!"

	; mstrcpyc str1, "I am string"
	; mtask8_1 str1, 5, "!"

	; mstrcpyc str1, "I am string"
	; mtask11 str1, 2, " " ; bx=str1+4
	; mtask11 str1, 3, " " ; найти третий пробел = bx=0FFFFh

	; mstrcpyc str1, "I am string"
	; mtask12 str1, " "
	; program finish
	mov ax, 4C00h
	int 21h

; si - адрес строки
; al - искомый символ
; cx - [выход] количество встреченных символов
; si - [используется]
task12:
	call strlen
	xor cx, cx
	cmp byte[si], al ; проверить первый символ
	jne task12_L1
	inc cx
task12_L1:
	cmp byte[si+bx], al ; проверить символы от последнего до второго
	jne task12_L2
	inc cx
task12_L2:
	dec bx
	jnz task12_L1
	ret

; di - адрес строки
; al - символ для поиска
; ah - номер встречаемого символа
; bx - [выход] - индекс символа в строке или -1 (0FFFFh)
; cx - [используется]
; si - [используется]
task11:
	mov si, di
	call strlen
	movzx cx, ah
	cld
task11_L1:
	scasb
	je task11_L2
	cmp byte[di], 0
	jne task11_L1
	mov bx, -1
	ret
task11_L2:
	lea bx, [di-1] ; scasb увеличивает di после вызова
	loop task11_L1
	ret

; другая версия task8
; si - адрес изменяемой строки
; ah - позиция для вставки символа
;      [максимальный размер строки - 31 символ + нулевой символ]
; ah - символ для вставки
task8_1: ; выделить strrshift возможно, но будет больше кода
	movzx dx, ah ; dh = 0, dl = ah
	call strlen ; bx = len(str1)
	cmp bx, 31
	jge task8_1_L1
	add si, bx ; si = str1+bx = end(str1)
	lea di, [si+1] ; di = str1+bx+1 = end(str1)+1
	lea cx, [bx+1] ; --v
	sub cx, dx ; кол-во повторений = len(str1)-dx+1
	; mov dx, di ; сохранить di чтобы записать в конец \0
	std ; идти с конца и уменьшать si, di
	rep movsb ; сдвинуть строку
	mov byte[di], al
	; mov di, dx
	; mov byte[di], "$"
	; mov byte[di], 0
task8_1_L1:
	ret

; si - адрес изменяемой строки
; cx - позиция для вставки символа
;      [максимальный размер строки - 31 символ + нулевой символ]
; ah - символ для вставки
task8:
	call strlen
	cmp bx, 31
	jge task8_L1 ; длина строки не позволяет её расширить
	add si, cx
	mov di, si
	mov bx, 1
	call strrshift0
	mov byte[di], ah
task8_L1:
	ret

; si - адрес начала сдвига
; bx - дистанция сдвига
; cx - [используется]
; сдвигает строку побайтно вправно
strrshift0:
	mov cl, byte[si]
strrshift0_L1:
	cmp byte[si], 0
	je strrshift0_L2
	mov ch, byte[si+bx]
	mov byte[si+bx], cl
	mov cl, ch
	inc si
	jmp strrshift0_L1
strrshift0_L2:
	ret

; si - [const] адрес строки
; bx - [выход] длина строки (количество символов)
task4:
strlen:
	mov bx, 0
strlen_L2:
	cmp byte[si+bx], 0
	je strlen_L1
	inc bx
	jmp strlen_L2
strlen_L1:
	ret


; di - адрес заполняемой строки
; cx - колчество символов "#"
; ax - [используется]
task3:
	mov al, "#"
	rep stosb
	mov byte[di], 0
	ret

task2:
	minit_str str1
	minit_str str2
	minit_str str3
	ret

task1:
	mov di, str1
	call init_str
	mov di, str2
	call init_str
	mov di, str3
	call init_str
	ret

; di - адрес строки, которую нужно инициализиировать
init_str:
	mov byte[di], 0
	ret

section .bss

align 16
STR_BUFSIZE: equ 32
str1: resb STR_BUFSIZE
str2: resb STR_BUFSIZE
str3: resb STR_BUFSIZE

