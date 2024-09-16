section .data
  ; The first thing we do is setting up constants
  ; to help readability
  sys_exit  equ 60
  sys_write equ 1
  stdout    equ 1
  
  ; Here we define the parameters of our program.
  ; We will sum `a` and `b` and we expect the result
  ; to be the value in the `expected` constant.
  a         equ 100
  b         equ 50
  expected  equ 150

  ; Should the sum be correct, we want to print a
  ; nice message for our user
  msg       db  `Correct!\n`
  msg_len   equ 9

section .text
global _start

_start: 
  ; We will make use of the `add` instruction, which
  ; unsurprisingly adds two integers. `add` takes
  ; registers as operands, so we move the constants
  ; in the `rax` abd `rbx` registers
  mov rax, a
  mov rbx, b
  
  ; Here's our new instruction!
  ; It makes use to the arithmetic capabilities of
  ; the CPU to sum operands and stores the result
  ; in `rax`.
  ; In high-levelese, this would be something like
  ;    rax = rax + rbx
  add rax, rbx

  ; Here we use the the `cmp` (compare) instruction
  ; and check whether rax == expected
  cmp rax, expected
  
  ; `je` stands for "jump if equals", so if the sum
  ; (in `rax`) equals `expected` (constant) we jump
  ; to the `correct` label
  je correct

  ; Should the result be incorrect, we jump to the 
  ; label `exit_1`, to exit with status code 1
  jmp exit_1

exit_1:
  ; This is the same as in the previous lessons
  ; but now we are using the status code 1,
  ; traditionally used to signal errors.
  mov rax, sys_exit
  mov rdi, 1
  syscall

correct:
  ; By now we are familiar with this block: we are
  ; invoking the syscall `write` to print a message
  ; to reassure our users that the sum is correct.
  mov rax, sys_write
  mov rdi, stdout
  mov rsi, msg
  mov rdx, msg_len
  syscall
  ; Once the message is printed, we can move on to
  ; `exit_0` where we exit the execution with status
  ; code 0, indicating success
  jmp exit_0

exit_0:
  ; This is the very same call we have seen in all
  ; the previous exercises; it should be familiar.
  mov rax, sys_exit
  mov rdi, 0
  syscall