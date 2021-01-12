  .equ LOAD_BIOS_INT,       0x13
  .equ LOAD_BIOS_READ,      0x02
  .equ LOAD_BIOS_CYLINDER,  0x00
  .equ LOAD_BIOS_HEAD,      0x00
  .equ LOAD_BIOS_SECTOR,    0x02

load_bios:
  push %dx

  mov $LOAD_BIOS_READ, %ah
  mov %dh, %al
  mov $LOAD_BIOS_CYLINDER, %ch
  mov $LOAD_BIOS_HEAD, %dh
  mov $LOAD_BIOS_SECTOR, %cl

  int $LOAD_BIOS_INT
  pop %dx
  jc load_bios_error

  cmp %dh, %al
  jne load_bios_error

  ret

load_bios_error:
  push %ax
  push %dx

  mov $load_bios_error_message, %si
  call print_bios_string

  mov $load_bios_error_expected_message, %si
  call print_bios_string

  pop %dx
  mov %dh, %dl
  xor %dh, %dh
  call print_bios_hex

  mov $load_bios_error_read_message, %si
  call print_bios_string

  pop %ax
  xor %ah, %ah
  mov %ax, %dx
  call print_bios_hex

load_bios_hang:
  hlt
  jmp load_bios_hang

load_bios_error_message:
  .asciz "\nDisk load error!\r\n\n"

load_bios_error_expected_message:
  .asciz "Expected sectors:\r\n"

load_bios_error_read_message:
  .asciz "Read sectors:\r\n"
