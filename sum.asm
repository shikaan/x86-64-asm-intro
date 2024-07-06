section .data
  a:    equ 100
  b:    equ 50
  msg:  db  "Correct!\n"

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
  mov rax, 60
  mov rdi, 0
  syscall

.print:
  mov rax, 1
  ; stdout
  mov rdi, 1
  ; buffer
  mov rsi, msg
  ; buffer length
  mov rdx, 10
  syscall
  jmp .exit
