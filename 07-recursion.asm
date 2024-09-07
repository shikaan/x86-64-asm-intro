section .data
  SYS_EXIT  equ 60
  INPUT     equ 7
  buffer    db, 0, 0

section .text
global _start

_start:
  mov rdi, INPUT
  call fibonacci

  mov rdi, rax
  mov rax, SYS_EXIT
  syscall

fibonacci:
  cmp rdi, 2
  jle .base

  push rbp
  mov rbp, rsp

  ; saving rdi in the local stack frame
  push rdi

  ; Call fibonacci(n - 1)
  dec rdi
  call fibonacci
  
  ; Restore the initial value of rdi that was in the stack
  ; We will use it to call fibonacci with n - 2
  ; Note: here we cannot just `dec rdi` again. The recursive 
  ; call might change rdi (it's caller-save) and we cannot rely
  ; on the information in it.
  pop rcx

  ; Saving the result from fibonacci(n-1) on the stack
  push rax

  ; Call fibonacci(n-2)
  sub rcx, 2
  mov rdi, rcx
  call fibonacci

  ; We're now popping from the stack the result of fibonacci(n-1)
  ; and putting its value in rcx, so that we can sum.
  pop rcx

  ; Sum the results
  add rax, rcx

  ; Reset the stack and return
  mov rsp, rbp
  pop rbp
  ret

  .base:
    mov rax, 1
    ret

print:
  push rbp
  mov rbp, rsp
  ; counter
  xor r10, r10 

.accumulate:
  xor rdx, rdx
  mov rax, rdi
  mov rcx, 10
  div rcx   

; rax includes result, remainder in rdx
  push rdx
  inc r10
  cmp rax, 0
  jne .loop

.print:
  xor rdx, rdx
  pop rax
  mov [buffer + r10 - rdx], rax
  inc rdx
  cmp rdx, rcx
  jne .print

  mov rax, 1
  mov rdi, 1
  mov rsi, buffer
  mov rdx, rcx

  mov rsp, rbp
  pop rbp
  ret