  .code16

  .equ BIOS_DISK,           0x13
  .equ BIOS_DISK_READ,      0x02
  .equ BIOS_DISK_CYLINDER,  0x00
  .equ BIOS_DISK_HEAD,      0x00
  .equ BIOS_DISK_SECTOR,    0x02

disk_load:
  push  %dx

  mov   $BIOS_DISK_READ, %ah
  mov   %dh, %al
  mov   $BIOS_DISK_CYLINDER, %ch
  mov   $BIOS_DISK_HEAD, %dh
  mov   $BIOS_DISK_SECTOR, %cl

  int   $BIOS_DISK
  pop   %dx
  jc    disk_load_error

  cmp   %dh, %al
  jne   disk_load_error

  ret

disk_load_error:
  push  %ax
  push  %dx

  mov   $disk_load_error_message, %si
  call  print_string

  mov   $disk_load_error_expected_message, %si
  call  print_string

  pop   %dx
  mov   %dh, %dl
  xor   %dh, %dh
  call  print_hex

  mov   $disk_load_error_read_message, %si
  call  print_string

  pop   %ax
  xor   %ah, %ah
  mov   %ax, %dx
  call  print_hex

  hlt

disk_load_error_message:
  .asciz "\nDisk load error!\r\n\n"

disk_load_error_expected_message:
  .asciz "Expected sectors:\r\n"

disk_load_error_read_message:
  .asciz "Read sectors:\r\n"
