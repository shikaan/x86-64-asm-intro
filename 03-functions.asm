section .data
  ; Usual set of constants for syscalls.
  sys_write equ 1
  sys_exit  equ 60
  fd_stdout equ 1

  ; Input parameters of our programr. We will
  ; roll a die with `faces` sides.
  faces     equ 6

  ; Buffer to store the digit to print.
  ; We don't need its length since we print one
  ; digit at a time (so it's always 1).
  buffer    db   ` `

section .text
  global _start
_start:
  ; First, we generate a random number in the range
  ; [1, faces] by invoking a function where the 
  ; argument is the max allowed random value.
  
  ; `rdi` is the first function argument register.
  ; We store `faces` there before calling random.
  mov rdi, faces
  call random

  ; Again, we pass the digit to print via `rdi` 
  mov rdi, rax
  call print_digit

  ; Now, we can exit
  call exit

random:
  ; This function generates a random number in the
  ; range [1, rdi] and returns the result in rax.
  ;
  ; In high-level languages, you'd write this as: 
  ;
  ;   (rand() % rdi) + 1
  ;
  ; Where `rand()` is a random number and % is the
  ; modulo operation.

  ; Same as previous example, we get a random number.
  ; We can store it in `rax` because `rax` is 
  ; _caller-saved_, so we need not preserve it.
  rdrand rax

  ; Modulo is the remainder of a division. In assembly, 
  ; we have to divide and then collect the remainder.
  ; 
  ; `div` divides the value in `rax` by the operand,
  ; saves the quotient in `rax`, and the remainder
  ; in `rdx`.
  ;
  ; `rdi` is _caller-saved_, we can safely use it.
  div rdi

  ; We store the result in `rax` to return it later.
  mov rax, rdx
  ; We increment the result to adjust the range to
  ; [1, faces]; something like `rax++`.
  inc rax
  ret

print_digit:
  ; This function prints a single digit number in `rdi`
  ; to the screen, using the buffer we defined earlier. 

  ; First, we convert the number to its character 
  ; representation. According to the ASCII table,
  ; digits are in the range [48, 57]. Adding 48 yields
  ; the ASCII value of the character.
  add rdi, 48

  ; Replace the first `buffer` character with the digit.
  ;
  ; The [] syntax gets the memory location of what's 
  ; inside the brackets. In plain English,  `[thing]` 
  ; means "memory location whose address is thing".  
  ; We use `dil` to access the lower byte of  `rdi` as
  ; we saw in the first lesson.
  ;
  ; This instruction means "store the lower byte of 
  ;`rdi` in the memory location of `buffer`".
  mov [buffer], dil
  
  ; This is the print routine we've seen before.
  mov rax, sys_write
  mov rsi, buffer
  mov rdx, 1
  mov rdi, fd_stdout
  syscall
  ret

exit:
  mov rax, sys_exit
  mov rdi, 0
  syscall
