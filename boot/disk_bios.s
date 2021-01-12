  .equ DISK_BIOS_INT,       0x13
  .equ DISK_BIOS_READ,      0x02
  .equ DISK_BIOS_CYLINDER,  0x00
  .equ DISK_BIOS_HEAD,      0x00
  .equ DISK_BIOS_SECTOR,    0x02

disk_bios_load:
  .code16

  push %dx

  mov $DISK_BIOS_READ, %ah
  mov %dh, %al
  mov $DISK_BIOS_CYLINDER, %ch
  mov $DISK_BIOS_HEAD, %dh
  mov $DISK_BIOS_SECTOR, %cl

  int $DISK_BIOS_INT
  pop %dx
  jc disk_bios_load_error

  cmp %dh, %al
  jne disk_bios_load_error

  ret

disk_bios_load_error:
  push %ax
  push %dx

  mov $disk_bios_load_error_message, %si
  call print_bios_string

  mov $disk_bios_load_error_expected_message, %si
  call print_bios_string

  pop %dx
  mov %dh, %dl
  xor %dh, %dh
  call print_bios_hex

  mov $disk_bios_load_error_read_message, %si
  call print_bios_string

  pop %ax
  xor %ah, %ah
  mov %ax, %dx
  call print_bios_hex

disk_bios_load_hang:
  hlt
  jmp disk_bios_load_hang

disk_bios_load_error_message:
  .asciz "\nDisk load error!\r\n\n"

disk_bios_load_error_expected_message:
  .asciz "Expected sectors:\r\n"

disk_bios_load_error_read_message:
  .asciz "Read sectors:\r\n"
