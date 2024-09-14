section .data
  ; Same as earlier, we define a msg constant
  msg db `Hello, World!\n`
  ; This time we will also define its length here,
  ; along with other constants to help legibility. 
  ; The `equ` (equals) directive is used to define
  ; numeric constants.
  len       equ 14 ; Buffer length
  sys_write equ 1  ; Identifier for syscall write
  sys_exit  equ 60 ; Identifier for syscall exit
  stdout    equ 1  ; File Descriptor of stdout

section .text
  global _start
_start:
  ; Jumps can be confusing. To make this introduction
  ; gentler, we will use numbers like (1), (2)... to 
  ; outline the steps the code takes and their order.

  ; (1) Here we immediately jump to the code that
  ; prints the message. The destination is the label
  ; `print_msg`, meaning that execution will proceed
  ; from the line just below it. 
  ; Let's head to (2) to see how this story unfolds.
  jmp print_msg

exit:
  ; (3) Now we know the drill: using `sys_exit` from
  ; the top block we can invoke the exit syscall to, 
  ; well, exit the program with status code 0.
  mov rax, sys_exit
  mov rdi, 0
  syscall

print_msg:
  ; (2) After the invocation of `jmp`, we are now
  ; executing the same routine we defined in the first
  ; lesson. Don't hesitate to go back, if you you are
  ; unsure what the following registers are for.
  mov rax, sys_write
  mov rdi, stdout
  mov rsi, msg
  mov rdx, len
  syscall

  ; We are done with printing, it's now time to exit
  ; the program. We are again using a jump to run
  ; the block at label `exit`.
  ;
  ; Notice that if we did not jump somewhere else,
  ; even if there is no more code to run, the program
  ; would not exit! It would stay in a limbo state,
  ; eventually generating a segmentation fault.
  ; Comment the next line to try it out, if you want.
  ;
  ; Done? Have you seen it breaking? Very nice!
  ; Let's now fix it by jumping to the `exit` label.
  ; Go to (3) to see end of this little jumping saga.
  jmp exit
  