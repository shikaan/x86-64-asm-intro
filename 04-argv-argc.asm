section .data
  SYS_EXIT  equ 60
  SYS_READ  equ 0
  SYS_WRITE equ 1

  HELP_MSG        db  "Usage: echo <argument>", 0xa
  HELP_MSG_LEN    equ $ - HELP_MSG

  INVALID_MSG     db "echo: Invalid number of arguments", 0xa
  INVALID_MSG_LEN equ $ - INVALID_MSG

section .text
global _start

_start:
  pop r10
  cmp r10, 2
  jne .error
  
  ; store argv[1]
  mov rbx, [rsp + 8]

  mov rdi, rbx
  call length

  mov rdi, rbx
  mov rsi, rax
  call println

  mov rdi, 0
  call exit

.error:
  mov rdi, INVALID_MSG
  mov rsi, INVALID_MSG_LEN
  call println
  mov rdi, HELP_MSG
  mov rsi, HELP_MSG_LEN
  call println
  mov rdi, 1
  call exit

.success:
  mov rdi, 0
  call exit

; get length of string in [rdi]
length:
  mov rax, 0
  mov rcx, 0

  .loop:
    cmp byte [rdi + rcx], 0
    je .done
    inc rax
    inc rcx
    jmp .loop

  .done:
    ret

; exit with status code [rdi]
exit:
  mov rax, SYS_EXIT
  syscall

; print string in [rdi] with length [rsi]
; appending newline
println:
  ; append newline
  mov byte [rdi + rsi], 0xa
  ; increment length
  inc rsi
  ; write to stdout
  mov rax, SYS_WRITE
  mov rdx, rsi 
  mov rsi, rdi
  mov rdi, 1
  syscall
  ret

