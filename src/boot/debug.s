  .code16

  .equ DEBUG_MEMORY_LINE_STEP,    0x0002
  .equ DEBUG_MEMORY_LINE_LENGTH,  0x0008

debug_memory:
  push %bp
  mov %sp, %bp

  push %bx
  push %dx

debug_memory_loop:
  mov $DEBUG_MEMORY_LINE_LENGTH, %cx

debug_memory_loop_line:
  pop %dx

  push %dx
  push %cx

  mov %dx, %bx
  mov (%bx), %dx
  call print_hex

  mov $debug_memory_delimeter, %si
  call print_string

  pop %cx
  pop %dx

  add $DEBUG_MEMORY_LINE_STEP, %dx
  push %dx

  loop debug_memory_loop_line

  mov $debug_memory_newline, %si
  call print_string

  pop %dx
  pop %bx

  dec %bx

  push %bx
  push %dx

  test %bx, %bx
  jz debug_memory_exit

  jmp debug_memory_loop

debug_memory_exit:
  leave
  ret

debug_memory_delimeter:
  .asciz " "

debug_memory_newline:
  .asciz "\r\n"
