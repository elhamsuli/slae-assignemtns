00000000  6A0B              push byte +0xb                      
00000002  58                pop eax                             ; save 0xb to eax , system call = execve(filename, argv, envp)
00000003  99                cdq                                 ; extends the sign bit of EAX into the EDX register. Making EDX = 0     
                                                                ; ref: https://www.aldeid.com/wiki/X86-assembly/Instructions/cdq
00000004  52                push edx                            ; push the sign bits in EDX        
00000005  66682D63          push word 0x632d                    ; push the hex of ( -c ) 
00000009  89E7              mov edi,esp                         ; save pointer of ( -c ) in edi 
0000000B  682F736800        push dword 0x68732f                 ; push 0x68732f = hs/ == reverse of /sh
00000010  682F62696E        push dword 0x6e69622f               ; push 0x6e69622f = nib/ == reverse of /bin
00000015  89E3              mov ebx,esp                         ; save pointer of filename ( /bin/sh ) in ebx        
00000017  52                push edx                            ; push 0   
00000018  E807000000        call 0x24                           ; JMP_CALL_POP technique, this will call instructions 575389E1 at line 18
                                                                ; and push the address of next instruction line 14 to stack
0000001D  7768              ja 0x87                             ; this instruction is junk, but the opcodes = 7768 is for letters ( wh ) from the command ( whoami )
0000001F  6F                outsd                               ; opcode = 6F is the letter ( o )  
00000020  61                popa                                ; opcode = 61 is the letter ( a )  
00000021  6D                insd                                ; opcode = 6D is the letter ( m )   
00000022  6900575389E1      imul eax,[eax],dword 0xe1895357     ; opcode = 69 00 is the letter ( i ) followed by null terminator 
                                                                ; then it followed by instructions [575389E1], to find out what they are:
                                                                ; echo -ne "\x57\x53\x89\xE1" | ndisasm -u -
                                                                ;    57     push edi        ; push pointer to -c
                                                                ;    53     push ebx        ; push filename pointer
                                                                ;    89E1   mov ecx,esp     ; push filename as param 
                                                                ; at the end:
                                                                ; eax = execve sys call 
                                                                ; ebx = filename /bin/sh
                                                                ; ecx = pointer to [addr of /bin/sh | addr of -c | addr of whoami ]
00000028  CD80              int 0x80                            ; interrupt tp run execve    