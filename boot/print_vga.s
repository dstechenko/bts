  .code32

  .equ PRINT_VGA_VIDEO_MEMORY,    0x000B8000
  .equ PRINT_VGA_WHITE_ON_BLACK,  0x0F
  .equ PRINT_VGA_INPUT_STEP,      0x01
  .equ PRINT_VGA_OUTPUT_STEP,     0x02
  .equ STRING_END,                0x00

print_vga_string:
  push %eax
  push %ebx
  push %edx

  xor %eax, %eax

  mov $PRINT_VGA_VIDEO_MEMORY, %edx

print_vga_string_loop:
  mov (%ebx), %al
  mov $PRINT_VGA_WHITE_ON_BLACK, %ah

  cmp $STRING_END, %al
  je print_vga_string_exit

  mov %ax, (%edx)
  add $PRINT_VGA_INPUT_STEP, %ebx
  add $PRINT_VGA_OUTPUT_STEP, %edx

  jmp print_vga_string_loop

print_vga_string_exit:
  pop %edx
  pop %ebx
  pop %eax

  ret
