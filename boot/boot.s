.code16

.equ BOOT_SECTOR_SIZE,    0x200
.equ BOOT_SIGNATURE_SIZE, 0x2
.equ BOOT_SIGNATURE,      0xAA55

.equ INT_BIOS_VIDEO,      0x10
.equ INT_BIOS_VIDEO_TTY,  0x0E

.equ HEX_ASCII_OFFSET,    0x37
.equ DEC_ASCII_OFFSET,    0x30
.equ HEX_DIGIT_BIT_MASK,  0x000F
.equ HEX_DIGIT_LENGTH,    0x4
.equ HEX_DIGIT_SIZE,      0x4
.equ HEX_SIGN_OFFSET,     0x2

.equ NULL_SIGN,           0x0

.text

.global boot

boot:
  mov   $boot_message, %si
  call  print_str
  mov   $debug_message, %si
  call  print_str
  mov   $0xDEAD, %dx
  call  print_hex
  call  wait

wait:
  jmp .

print_str:
  mov $INT_BIOS_VIDEO_TTY, %ah

print_str_loop:
  lodsb
  cmp   $NULL_SIGN, %al
  je    print_str_exit
  int   $INT_BIOS_VIDEO
  jmp   print_str_loop

print_str_exit:
  ret

print_hex:
  mov   $print_hex_out, %si
  add   $HEX_SIGN_OFFSET, %si
  mov   $HEX_DIGIT_LENGTH, %cx

print_hex_loop:
  mov   %dx, %ax
  push  %cx
  dec   %cx
  jz    print_hex_digit
  call  shift_digit

print_hex_digit:
  pop   %cx
  and   $HEX_DIGIT_BIT_MASK, %ax
  add   $HEX_ASCII_OFFSET, %ax
  mov   %al, (%si)
  inc   %si
  loop  print_hex_loop
  mov   $print_hex_out, %si
  call  print_str
  ret

shift_digit:
  shr   $HEX_DIGIT_SIZE, %ax
  loop  shift_digit
  ret

print_hex_out:
  .asciz  "0x0000\r\n"

debug_message:
  .asciz  "Debug information: "

boot_message:
  .asciz  "Booting Dokkan...\r\n"

  .space  BOOT_SECTOR_SIZE - BOOT_SIGNATURE_SIZE - (. - boot)
  .word   BOOT_SIGNATURE
