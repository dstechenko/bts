  .code16

  .equ BIOS_VIDEO,          0x10
  .equ BIOS_VIDEO_TTY,      0x0E

  .equ DEC_ASCII_OFFSET,    0x30
  .equ DEC_MAX_VALUE,       0x09

  .equ HEX_ASCII_OFFSET,    0x37
  .equ HEX_DIGIT_BIT_MASK,  0x000F
  .equ HEX_DIGIT_LENGTH,    0x04
  .equ HEX_DIGIT_SIZE,      0x04
  .equ HEX_SIGN_OFFSET,     0x02

  .equ STRING_END,          0x00

print_string:
  xor %ax, %ax
  mov $BIOS_VIDEO_TTY, %ah

print_string_loop:
  lodsb
  cmp $STRING_END, %al
  je print_string_exit
  int $BIOS_VIDEO
  jmp print_string_loop

print_string_exit:
  ret

print_hex:
  mov $print_hex_out, %si
  add $HEX_SIGN_OFFSET, %si
  mov $HEX_DIGIT_LENGTH, %cx

print_hex_loop:
  mov %dx, %ax
  push %cx
  dec %cx
  jz print_extract_hex_digit
  call print_shift_digit

print_extract_hex_digit:
  pop %cx
  and $HEX_DIGIT_BIT_MASK, %ax
  cmp $DEC_MAX_VALUE, %ax
  jle print_convert_dec_digit

print_convert_hex_digit:
  add $HEX_ASCII_OFFSET, %ax
  jmp print_hex_digit

print_convert_dec_digit:
  add $DEC_ASCII_OFFSET, %ax

print_hex_digit:
  mov %al, (%si)
  inc %si
  loop print_hex_loop
  mov $print_hex_out, %si
  call print_string
  ret

print_shift_digit:
  shr $HEX_DIGIT_SIZE, %ax
  loop print_shift_digit
  ret

print_newline:
  mov $print_newline_out, %si
  call print_string
  ret

print_hex_out:
  .asciz "0x0000"

print_newline_out:
  .asciz "\r\n"
