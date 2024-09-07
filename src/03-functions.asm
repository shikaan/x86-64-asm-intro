section .data
  SYS_EXIT  equ 60
  SYS_WRITE equ 1
  buffer    db  0, 0

section .text
global _start
_start:
  mov rdi, 1
  call to_string
  mov rdi, rax
  mov rsi, 2
  call print
  mov rdi, 0
  call exit

; exits with status code in rdi
exit:
  mov rax, SYS_EXIT
  syscall
  ret

; prints a buffer [rdi] with given lenght [rsi]
print:
  ; perform syscall
  mov rax, SYS_WRITE
  mov rdx, rsi
  mov rsi, rdi
  mov rdi, 1
  syscall
  ret

; converts single-digit int to string
to_string:
  mov rax, rdi
  add rax, 48
  mov [buffer], rax
  mov byte [buffer+1], 0
  mov rax, buffer
  ret


