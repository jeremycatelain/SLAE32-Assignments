/*

    Author : Jeremy Catelain
    Filename : aes-cryptor.c

*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/aes.h>

// GLOBAL VARIABLES
unsigned char shellcode[] = \
"\x31\xc0\x50\x68\x62\x61\x73\x68\x68\x62\x69\x6e\x2f\x68\x2f\x2f\x2f\x2f\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80"; // to modify 

AES_KEY enc_key, dec_key;
// Initialisation tables for the encrypted and decrypted payloads
unsigned char enc_out[100];
unsigned char dec_out[100];

// Shellcode printer
void print_shellcode(unsigned char shellc[]) {
    int len = strlen(shellc);
    for (int i = 0; i < len; i++) {
        printf("\\x%02x", shellc[i]);
    }
}

// Encryption 
void encryption(unsigned char *encryption_key, int shellcode_len){

	AES_set_encrypt_key(encryption_key, 128, &enc_key); // AES key scheduling - Expand the Userkey, which is bits long into the key structure to preprare for encryption.

    // The encryption is performed 16 bytes by 16 bytes
	long c1 = 0;
    while(c1 < shellcode_len){
    	AES_encrypt(shellcode + c1, enc_out + c1, &enc_key); 
		c1 += 16;
	}
}

// Decryption
void decryption(unsigned char *encryption_key, int enc_out_len){

    AES_set_decrypt_key(encryption_key, 128, &dec_key);

    // Decyption performed 16 bytes by 16 bytes
    long c2 = 0;
    while(c2 < enc_out_len){
    	AES_decrypt(enc_out + c2, dec_out + c2, &dec_key);
    	c2 += 16;
	}
}

int aes_workflow(unsigned char *encryption_key) {

    int shellcode_len = strlen(shellcode);
	
	//Encryption of the payload
    encryption(encryption_key, shellcode_len);

    // Length of the encrypted payload
    int enc_out_len = strlen((unsigned char *)enc_out);

    //Decryption of the payload
    decryption(encryption_key, enc_out_len);

    // Length of the decrypted payload
	int dec_out_len = strlen((unsigned char *)dec_out);

	if (shellcode_len != dec_out_len){
		printf("ATTENTION: Length of the Encryption key too small.\n");
	}

	printf("Original:\t");
    print_shellcode(shellcode);
    printf("\nEncrypted:\t");
    print_shellcode(enc_out);
    printf("\nDecrypted:\t");
    print_shellcode(dec_out);

}

int main(int argc, char* argv[])
{
	unsigned char *encryption_key;
	int encryption_key_length;
	encryption_key = (unsigned char *)argv[1];
	encryption_key_length = strlen((unsigned char *)encryption_key);
	printf("Encryption started...\n");

	printf("The Encryption key length : %d\n", encryption_key_length);
	// Verification that the key length is 16 bytes
	if (encryption_key_length > 16){
		printf ("ATTENTION: Only the first 16 bytes of the Encryption key will be taken: \"");
		for (int i=0; i<16; i++){
			printf("%c",*(encryption_key+i));
		}
		printf("\"\n");
	}
	aes_workflow(encryption_key);
	return 0;
}
    
