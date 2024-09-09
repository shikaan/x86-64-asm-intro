x86-64-asm-intro
---

This repository represents the supporting material for the Assembly mini course at 
[shikaan.github.io](https://shikaan.github.io/assembly/x86/guide/2024/09/08/x86-64-introduction-hello.html)

## Dependencies

### nasm

```sh
sudo apt install nasm
```

### shmux (optional)

```sh
sudo sh -c "wget -q https://shikaan.github.io/sup/install -O- | REPO=shikaan/shmux sh -"
```

## Running an exercise

```sh
# with shmux
shmux run -- 00-file.asm

# else
nasm -g -f elf64 -o build/00-file.o 00-file.asm
ld -o build/00-file.out build/00-file.o
build/00-file.out
```