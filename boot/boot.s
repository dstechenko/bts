.code16

.equ BOOT_SECTOR_SIZE, 512
.equ BOOT_SIGNATURE_SIZE, 2
.equ BOOT_SIGNATURE, 0xaa55

.text

.global boot

boot:
  mov  $boot_message, %si
  call print
  jmp .

print:
  mov $0x0e, %ah

print_loop:
  lodsb
  cmp $0x0, %al
  je print_exit
  int $0x10
  jmp print_loop

print_exit:
  ret

boot_message:
  .asciz "Booting dokkan...\r\n"

  .space BOOT_SECTOR_SIZE - BOOT_SIGNATURE_SIZE - (. - boot)
  .word BOOT_SIGNATURE
