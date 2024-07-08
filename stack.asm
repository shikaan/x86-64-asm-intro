section .data
  SYS_EXIT    equ 60
  SYS_WRITE   equ 1

  INPUT       db "Hello world!", 0
  INPUT_SIZE  equ $ - INPUT

  buf         db 0, 0

section .text
global _start

_start:
  xor r12, r12
  xor r13, r13

.load:
  mov al, [INPUT + r13]
  cmp al, 0
  je .unload
  inc r13
  push rax
  jmp .load

.unload:
  pop r10
  mov [buf], r10
  call print
  inc r12
  cmp r12, INPUT_SIZE
  jne .unload
  
.ok:
  mov rax, 60
  mov rdi, 0
  syscall
  ret

print:
  mov rax, 1
  mov rdi, 1
  mov rsi, buf
  mov rdx, 1
  syscall
  ret
