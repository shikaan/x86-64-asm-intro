An accessible assembly introduction for high-level programmers
---

Coming from JavaScript, Rust, C, or any other high-level language, looking at assembly snippets can be confusing or even scary.

Let's take the following snippet:
```s
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

# 1. Hello world

Unsurprisingly, our first program will be a "Hello World".

Before jumping into the code though, we need to briefly introduce the language and the utilities that will turn our code into running software. At the end of this section, we will be able to write, assemble, and run our first assembly program.

## x86-64 assembly

First things first, assembly is not a language.

Assembly refers to a _family of programming languages_ featuring instructions that closely map to the machine code that the CPU will execute. In fact, one of the raisons d'etre of assembly languages is to provide a human-readable version of machine code in situations like reverse engineering, hardware programming, or developing games for consoles.

In this guide, we will use _x86-64 assembly_ which can be assembled and executed on most personal computers. This choice should ease running and tinkering with the snippets along the way. 

For historical reasons, there are two "flavors" of the x64-64 assembly syntax: one called _Intel_ and the other is called _AT&T_. The former is more in vogue in Windows circles, the latter, is instead more adopted in UNIX-land.

> [!TIP]
> You can read up on the differences between Intel and AT&T syntax [here](https://imada.sdu.dk/u/kslarsen/dm546/Material/IntelnATT.htm). If it's your absolute first time with assembly, it might be a little too early to make sense of it. Feel free to come back to this link in a couple of lessons.

In this guide we will stick to the _Intel_ dialect because it's used by the [Intel Software Developer Manuals (SDM)](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html), the source of truth when on what the CPU _really_ does when fed an instruction.

Additionally, since we are so close to the hardware, portability is hard and would obfuscate the content of this introduction. Therefore, the examples we will be written for Linux, even though they should run fine on Window's WSL as well.

## Anatomy of an instruction

Instructions are the way we tell the CPU what to do. They look something like this:

```s
mov rax, rbx
```

They represent the smallest unit of assembly language and are mostly composed of two parts:

* **mnemonic**: a shortened word or sentence that specifies the operation to be performed
* **operands**: a list of 0-3 items representing what's affected by the operation

In our example, the mnemonic is `mov`, which stands for _move_, and the operands are `rax` and `rbx`. This instruction in plain English would read: move the content of `rbx` in `rax`.

> [!NOTE]
> `rax` and `rbx` are registers and we will introduce them in the next paragraph. In the meantime, you can imagine them as variables holding a value.

Some instructions will have more then mnemonic and operands. Additional parts such as _prefixes_ and _size directives_ will only be needed later, and we'll talk through them at the right moment.

Fear not, there is no reason to memorize all the possible instructions now. Whenever we'll come across new operations, we will discuss them, and with repeated usage you will remember them in no time.

The [Intel Software Developer Manuals (SDM)](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html) will be our instruction reference in the next chapters. Keep the link handy!

## Registers

You can think of registers as storage space baked right into the CPU itself. They are small and incredibly fast to access.

There are different registers in x86-64. The first type are the so-called _general-purpose_ registers. In x86-64 they are sixteen in total and they are 64 bits wide. One can access the whole register or a subset of it by using a different names. 

For example, using `rax` (as in the code above) would address all the 64 bits in the `rax` register. With `al` you can access the lower byte of the same register.

| Register | Higher byte | Lower byte | Lower 2 bytes |	Lower 4 bytes |
|:---      |:---         |:---        |:---           |:---           |
| rax      | ah	         | al	        | ax            | eax           |
| rcx      | ch	         | cl	        | cx	          | ecx           |
| rbx      | bh	         | bl	        | bx            | ebx           |
| rdx      | dh	         | dl	        | dx            | edx           |
| rsp      |    	       | spl	      | sp	          | esp           |
| rsi      |             | sil        | si            | esi           |
| rdi      |             | dil        | di            | edi           |
| rbp      |             | bpl        | bp	          | ebp           |
| r8       |             | r8b        | r8w           | r8d           |
| r9       |             | r9b        | r9w	          | r9d           |
| r10      |             | r10b       | r10w          | r10d          |
| r11      |             | r11b       | r11w          | r11d          |
| r12      |             | r12b       | r12w          | r12d          |
| r13      |             | r13b       | r13w          | r13d          |
| r14      |             | r14b       | r14w          | r14d          |
| r15      |             | r15b       | r15w          | r15d          |

General-purpose means that they can store anything, in principle. In practice, we'll see that some registers have special meanings, some instructions only use certain registers, and some conventions dictate who is expected to write where.

The only non general-purpose register we will be concerned with is `rip`, the _instruction pointer_ register. It holds the address of the next instruction to execute and therefore modifying `rip` allows programs to jump to arbitrary instructions in the code.

## Assembler

We need to convert our instructions into machine code if we want our CPU to execute them. 

This process is fairly complex, so we won't dive into its details here. The only information you need is that the procedure is made of two steps: assemble and link.

Assemblers are the tools used for assembling (duh!) our code into object code, a sequence of machine code statements. For this guide we'll use [NASM](https://www.nasm.us/) since it's available on all platforms and can be used to produce a variety of different of outputs.

Linkers are used to link (duh!) object code into a single executable. I will be using [ld](https://linux.die.net/man/1/ld) the GNU Linker since it's already available on most systems.

## Hello World
