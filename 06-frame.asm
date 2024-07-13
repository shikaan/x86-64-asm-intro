section .data
  SYS_EXIT equ 60

  OPERAND_1 equ 2
  OPERAND_2 equ 3
  RESULT    equ 13

section .text
global _start
_start:
  call main
  mov rdi, rax
  mov rax, 60
  syscall

main:
  mov   rdi, OPERAND_1
  mov   rsi, OPERAND_2
  call  sum_squares
  cmp   rax, RESULT
  je    .success
  jmp   .failure

.success:
  mov rax, 0
  ret

.failure:
  mov rax, 1
  ret

sum_squares:
  ; We have 2 registers to manipulate the stack: rbp and rsp.
  ; 
  ; rbp is the pointer to the stack base (r=64bit, b=base, p=pointer).
  ; Remember: stacks are traditionally thought as growing downards, so 
  ; this pointer is the pointer to the "top" part of the stack.
  ; 
  ; rsp is the pointer to the end of the stack (r=64bit, s=stack,p=pointer)
  ; This pointer indicates up to which point the stack has been utilsed.
  ; Modeling the stack as growing downwards, this is the bottom of it.

  ; Stacks are used to create something very similar to what high level languages
  ; call scopes (as in lexical scope, block scope...)
  ; 
  ; The trick is very simple: we move the stack pointers to point to a safe region
  ; of memory, and use the stack normally, as if we were the only owners of it.
  ; 
  ; A good candidate for a safe memory region is the _end_ of the stack since the OS
  ; has already allocated the stack for us to use. 
  ; 
  ; One caveat: let's not forget to put the pointer back to where it was once we are done! 
  
  mov r11, rbp  ; Store the previous stack base pointer into r11.
                ; We'll need this to restore the stack once we are done.
  mov rbp, rsp  ; Make the base of the stack point at the end of the stack. 
                ; This way we can just use the usual pop/push freely.

                ; The newly allocated memory region is called a Stack Frame.

  mov rax, rdi  ; Store the first argument in rax
  mul rax       ; mul multiplies the argument by rax. Here we are then multiplying
                ; rax by itself, hence squaring it.
  push rax      ; Push it in the newly created stack frame

  mov rax, rsi  ; Store the second argument in rax
  mul rax       ; Square it
  push rax      ; Push it in the newly created stack frame

  pop rax       ; Pop the values in registers to be used by `add`
  pop rbx

  add rax, rbx  ; Sum the popped values into rax, the return register

  ; We are now done with this Stack Frame, we can dispose it.
  ; Given we popped all the elements, rbp points to the bottom of the Stack Frame.
  
  mov rsp, rbp  ; Therefore we can point the end of the stack to rsb, namely
                ; restoring the end of the stack to where it was initially.

  mov rbp, r11  ; Finally, we can restore the base pointer from r11, where 
                ; we put it at the beginning.

  ; At this point, the stack is exactly as it was when we entered
  ; and we are then ready to return.
  ret