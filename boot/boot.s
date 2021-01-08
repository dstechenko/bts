.code16

.equ BOOT_SECTOR_SIZE,    512
.equ BOOT_SIGNATURE_SIZE, 2
.equ BOOT_SIGNATURE,      0xaa55

.text

.global boot

boot:
  mov   $boot_message, %si
  call  print_str
  jmp   .

print_str:
  mov $0x0e, %ah

print_str_loop:
  lodsb
  cmp   $0x0, %al
  je    print_str_exit
  int   $0x10
  jmp   print_str_loop

print_str_exit:
  ret

boot_message:
  .asciz  "Booting Dokkan...\r\n"

  .space  BOOT_SECTOR_SIZE - BOOT_SIGNATURE_SIZE - (. - boot)
  .word   BOOT_SIGNATURE
