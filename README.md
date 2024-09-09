x86-64-asm-intro
---

This repository represents the supporting material for the Assembly mini course at 
[shikaan.github.io](https://shikaan.github.io/assembly/x86/guide/2024/09/08/x86-64-introduction-hello.html)

## Dependencies

### nasm

```sh
sudo apt install nasm
```

### shmux

```sh
sudo sh -c "wget -q https://shikaan.github.io/sup/install -O- | REPO=shikaan/shmux sh -"
```

## Running an exercise

```sh
shmux build -- 00-file.asm

build/00-file.asm.out
```

## References

- https://web.stanford.edu/class/cs107/guide/x86-64.html
- https://cs.lmu.edu/~ray/notes/nasmtutorial/
- https://github.com/0xAX/asm
- https://refspecs.linuxbase.org/elf/x86_64-abi-0.99.pdf

