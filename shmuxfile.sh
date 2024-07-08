build:
  nasm -g -f elf64 -o build/$1.o $1
  ld -o build/$1.out build/$1.o

run: build
  build/$1.out