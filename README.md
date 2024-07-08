# x86-64-asm-intro
Learning x86-64 assembly with nasm

## [Program](./docs/program.md)

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

