section .data
  msg db "Hello, World!"

section .text
  global _start
_start:
  ; rax contains the syscall number. 1 means sys_write
  ;
  ;   size_t sys_write(uint fd, const char* buf, size_t count)
  mov rax, 1
  ; rdi is how you pass the first argument
  mov rdi, 1
  ; rsi is the register for the second argument
  mov rsi, msg
  ; rdx is the register for the third argument
  mov rdx, 13
  ; we're now finally issuing the syscall
  syscall
  ; syscall 60 is the exit syscall
  ; 
  ;   void exit(int status)
  mov rax, 60
  ; rdi is the first argument
  mov rdi, 0
  ; issuing the syscall
  syscall
