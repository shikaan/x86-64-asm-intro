build:
  name=$(basename -s .asm $1)
  obj="build/${name}.o"
  bin="build/${name}.out"
  
  mkdir -p build
  nasm -g -f elf64 -o ${obj} $1
  ld -o ${bin} ${obj}

run: build
  name=$(basename -s .asm $1)
  "build/${name}.out" $2