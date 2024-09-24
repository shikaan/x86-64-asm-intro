section .data
  ; Here we define our usual constants. No surprises.
  sys_write  equ 1
  sys_exit   equ 60
  fd_stdout  equ 1
  
  ; This is the number of doors in our dungeon.
  doors equ 5

  ; These are the messages our explorer will see in 
  ; the game. Instead of counting characters, we use
  ; `$-` to get the string length.
  ; We will use the `$` operator only to calculate
  ; string length in this course. Feel free to dig
  ; deeper later, if you want.
  door        db `You open a door...\n`
  door_l      equ $-door

  empty       db `> This room is empty. Keep going.\n`
  empty_l     equ $-empty

  treasure    db `> You found the treasure. Joy!\n`
  treasure_l  equ $-treasure

  fail        db `\n  No treasure in the dungeon. What a scam!\n`
  fail_l      equ $-fail

section .text
global _start
_start:
  ; In this game we will open a few doors in search of
  ; a treasure. If we find it, we exit the program.
  ;
  ; The rbx register will be used to count the number
  ; of doors we opened. We zero it for good measure.
  mov rbx, 0

  ; We're opeing the first door... exciting!
  call open_door

open_door:
  ; Let's tell our brave explorer what's happening.
  call print_open_door

  ; To check if there is a treasure in the room, we
  ; generate a random number. If it's odd, we have 
  ; found the treasure, else we keep seraching.
  ;
  ; rdrand generates a random number in the range
  ; [0, 2^64-1] and stores it in `rax`.
  rdrand rax
  ; An efficient way of checking if a number is odd
  ; is to look at the last digit of its binary
  ; representation: if it's 1, it's odd.
  ; We do that using a bitwise and against 1.
  ; In many high-level languages you'd see `rax & 1` 
  and rax, 1

  ; Just like in the previous lesson, this is an if.
  ; Is the number odd?
  cmp rax, 1
  je handle_trasure
  call print_empty

  ; rbx is the number of checked doors.
  ; 
  ; We opened a door, so we `inc` (increase) rbx.
  ; In high-levelese it would be like `rbx++`
  inc rbx 
  
  ; If `rbx` equals `doors`, we have checked all the
  ; doors and there is no treasure. How sad!
  cmp rbx, doors
  je handle_fail
  
  ; Else, we can keep searching by jumping back at the 
  ; beginning of this block. Totally uneventful. 
  ; Except that we JUST IMPLEMENTED A LOOP! 
  ; 
  ; In fact, this equates to
  ;   for (rbx = 0; rbx < doors; rbx++)
  ;
  ; - rbx was zeroed in the beginning
  ; - we increment rbx on every iteration
  ; - as soon as rbx == doors we break
  ; 
  ; Tada!
  jmp open_door

print_open_door:  
  ; All the print_* work the same. We explain them here.
  ; 
  ; To reduce boilerplate, we put the shared code
  ; for printing in the `print` routine. Check it out!
  ;
  ; Done? Here we just complete the picture, putting
  ; the string and its length in the right registers
  ; before calling `print`.
  mov rsi, door
  mov rdx, door_l
  call print
  ret

print_empty: 
  ; See `print_open_door`.
  mov rsi, empty
  mov rdx, empty_l
  call print
  ret

handle_trasure:
  ; We found the treasure! 
  ; Let's congratulate our explorer and then exit.
  call print_treasure
  call exit

print_treasure:
  ; See `print_open_door`.
  mov rsi, treasure
  mov rdx, treasure_l
  call print
  ret

handle_fail:
  ; No treasures. Bummer.
  ; Let's tell our player and then exit.
  call print_fail
  call exit

print_fail:
  ; See `print_open_door`.
  mov rsi, fail
  mov rdx, fail_l
  call print
  ret

print:
  ; The same routine as in the last few articles, but
  ; it expects the caller to have set rsi (string) and
  ; rdx (string length) beforehand
  mov rax, sys_write
  mov rdi, fd_stdout
  syscall
  ret

exit:
  ; Same old exit routine we have seen many times.
  mov rax, sys_exit
  mov rdi, 0
  syscall
