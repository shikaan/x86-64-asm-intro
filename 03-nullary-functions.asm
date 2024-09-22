section .data
  ; This is our usual set of constants, no surprises here.
  sys_write equ 1
  sys_exit  equ 60
  fd_stdout equ 1

  ; These are the input parameters of our program.
  ; We will roll a die with `faces` faces `attempts`
  ; times.
  faces     equ 6
  attempts  equ 3

  ; The results will be print_digited to the screen. We 
  ; need a buffer to store the result, so we can
  ; print_digit it. As always, we define a length constant
  ; to make the code more readable.
  buffer    db `0\n`
  len       equ 2

section .text
  global _start

_start:
  ; To roll the die `attempts` times, we will use a
  ; loop. We will keep track of the number of rolls
  ; with the `rbx` register. We initialize it to 0
  ; for good measure.
  mov rbx, 0

  ; Here's our first function call. As you can see,
  ; it looks very much like a good old jump.
  ; Go to the `roll` label to see what happens next.
  call roll

  ; We are done rolling the die. We can now exit the
  ; program as usual. Since the program will exit 
  ; afterwards, using `call` or `jmp` makes no
  ; difference. 
  call exit

roll:
  ; This is the function that takes care of rolling
  ; the die `attempts` times. 

  ; First thing we do is rolling a single die. Go
  ; check the `roll_once` and see how.
  call roll_once

  ; Now we have a number in `rax`. We need to print
  ; it to the screen. Let's go to `print_digit` and
  ; see how. 
  call print_digit

  ; We've rolled the die once. Let's increment the
  ; number of rolls and check if we are done.
  inc rbx
  cmp rbx, attempts

  ; If the number of rolls is less than `attempts`,
  ; we jump back to roll, effectively rolling the 
  ; die `attempts` times.
  ; 
  ; Does this remind you of something? Yes, it's a
  ; loop! A new high-level construct in assembly!
  jl roll

  ; If we are done, we can return to the caller.
  ret

roll_once:
  ; Rolling a die is essentially generating a random
  ; integer in a range. Thus first we generate the
  ; number and then we do a modulo operation to scale
  ; it to the number of faces of the die.
  
  ; rdrand generates a random number directly from
  ; the hardwares random number generator and stores
  ; it in the `rax` register.
  rdrand rax

  ; Modulo operation is done with `div`. It divides
  ; the value in `rax` by the operand and stores the
  ; result in `rax` and the remainder in `rdx`.
  ;
  ; Here we divide the random number by the number of
  ; faces of the die. The remainder will be the result
  ; of the roll.
  mov rsi, faces
  mov rdx, 0
  div rsi

  ; We want to store the result in `rax` so we can
  ; print it later. We also need to increment it by
  ; 1, because the remainder of the division will be
  ; in the range [0, faces-1].
  mov rax, rdx
  inc rax

  ; We are done, let's return to the caller.
  ret

print_digit:
  ; This function prints a single digit in `rax` to
  ; the screen, using the buffer we defined earlier. 

  ; First, we convert the digit to a character. As you
  ; can see in any ASCII table, the digits are in the
  ; range [48, 57]. We add 48 to the digit to get the
  ; ASCII value of the character.
  add rax, 48

  ; We want to replace the first character in the
  ; buffer with the digit.
  ;
  ; The [] syntax is used to get the memory location of
  ; what's inside the brackets. In this case, it's the
  ; `buffer` variable.
  ;
  ; We use `al` to access the lower 8 bits of `rax` as
  ; we saw in the first lesson. We need to do so since
  ; characters are 8-bit, bytes, values.
  mov [buffer], al
  
  ; This is the usual print routine we've seen before.
  mov rax, sys_write
  mov rsi, buffer
  mov rdx, len
  mov rdi, fd_stdout
  syscall

  ; Once we've printed the digit, we are done. We can
  ; return to the caller.
  ret

exit:
  mov rax, sys_exit
  mov rdi, 0
  syscall