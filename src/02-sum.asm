section .data
  SYS_EXIT  equ 60
  SYS_WRITE equ 1
  a         equ 100
  b         equ 50
  msg       db  "Correct!", 0xa

section .text
global _start

_start: 
  mov rax, a
  mov rbx, b
  add rax, rbx
  cmp rax, 150
  jne .exit
  jmp .print

.exit:
  mov rax, SYS_EXIT
  mov rdi, 0
  syscall

.print:
  mov rax, SYS_WRITE
  mov rdi, 1
  mov rsi, msg
  mov rdx, 9
  syscall
  jmp .exit
