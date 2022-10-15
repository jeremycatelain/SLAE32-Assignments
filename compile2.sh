#! /bin/bash

echo '[+] Assembling with NASM'
nasm -s -f elf32 -o $1.o $1.nasm

echo '[+] Linking ..'
ld --omagic -m elf_i386 $1.o -o $1

echo '[+] Done!'

