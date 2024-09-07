Coming from JavaScript, Rust, C, or any other high-level language, looking at assembly snippets can be confusing or even scary.

Let's take the following snippet:
```asm
section .data
  msg db "Hello, World!"

section .text
  global _start

_start:
  mov rax, 1
  mov rdi, 1
  mov rsi, msg
  mov rdx, 13
  syscall

  mov rax, 60
  mov rdi, 0
  syscall
```
Thankfully the second line gives away what this does.

None of the bread and butter of programming as we know it is here: conditionals and loops are nowhere to be seen, there is no way to create functions... heck, variables don't even have names!

Where does one even start?

This little introduction is meant to introduce you, somebody with programming experience, to the world of assembly. We'll discuss the basics of the language and map them to high-level programming constructs.

By the end of this guide, you will be able to navigate assembly code, know where to look for information, and even write some simple programs all by yourself.

Let's get started!

## Content

* [01. Hello World](./01-hello-world)