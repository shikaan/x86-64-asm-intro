build:
  nasm -f elf64 -o $1.o $1.asm
  ld -o $1.out $1.o

run: build
  ./$1.out
