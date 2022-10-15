#! /bin/bash

echo '[+] Assembling with NASM'
nasm -f elf -o $1.o $1.nasm

echo '[+] Linking ..'
ld -m elf_i386 $1.o -o $1

echo '[+] Done!'

