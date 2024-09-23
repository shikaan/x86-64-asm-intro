section .data
  ; This is our usual set of constants for syscalls.
  sys_write equ 1
  sys_exit  equ 60
  fd_stdout equ 1

  ; These are the input parameters of our program.
  ; We will roll a die with `faces` faces.
  faces     equ 6

  ; The result will be print to the screen. We need a
  ; buffer to store the result, so we can print it.
  buffer    db `0\n`
  len       equ 2

section .text
  global _start
_start:
  ; Our program is nicely structured in functions.
  ; Go check them out when you encounter a `call`!

  ; First thing we do is generating a random number
  ; in the range [1, faces] and store it in `rax`.
  call random

  ; We store the result in `rdi` to print it later.
  mov rdi, rax
  ; We can print our single-digit number on screen.
  call print_digit

  ; We can now exit.
  call exit

random:
  ; This function generates a random number in the
  ; range [1, faces] using the hardware RNG and 
  ; scaling the result with a modulo operation.
  
  ; rdrand generates a random number in the range
  ; [0, 2^64-1] and stores it in `rax`.
  rdrand rax

  ; To get the modulo of a number, we perform a
  ; division with `div` and collect the remainder.
  ; `div` divides the value in `rax` by the operand,
  ; saves the result back in `rax` and the remainder
  ; in `rdx`.
  ;
  ; Here we divide the random number by the number of
  ; faces of the die. The remainder will be the result
  ; of the roll.
  mov rsi, faces
  mov rdx, 0
  div rsi

  ; We store the result in `rax` to print it later.
  mov rax, rdx
  ; We increment the result to adjust the range to
  ; [1, faces]. In high-leveallese, this would be `rax++`.
  inc rax

  ; We are done, let's return to the caller.
  ret

print_digit:
  ; This function prints a single digit number in `rdi`
  ; to the screen, using the buffer we defined earlier. 

  ; First, we convert the number to its character 
  ; representation. As you can see in any ASCII table,
  ; the digits are in the range [48, 57].
  ; Adding 48 yields the ASCII value of the character.
  add rdi, 48

  ; We want to replace the first character in the
  ; buffer with the digit.
  ;
  ; The [] syntax is used to get the memory location
  ; of what's inside the brackets. In plain English, 
  ; `[thing]` means "memory location whose address is
  ; thing".  We use `dil` to access the lower byte of 
  ; `rdi` as we saw in the first lesson.
  ;
  ; So, this instruction means "store the lower byte
  ; of `rdi` in the memory location of `buffer`".
  mov [buffer], dil
  
  ; This is the print routine we've seen before.
  mov rax, sys_write
  mov rsi, buffer
  mov rdx, len
  mov rdi, fd_stdout
  syscall

  ; Once again, we can return to the caller.
  ret

exit:
  mov rax, sys_exit
  mov rdi, 0
  syscall