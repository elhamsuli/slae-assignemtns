	xor     ecx,ecx
	mul     ecx
	mov     cl, 3
	mov     ebx, esi
loop:
	mov     al, 0x3f
	int     0x80
	loop	loop