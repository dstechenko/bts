  .code16

  .equ LOAD_DISK_INT,       0x13
  .equ LOAD_DISK_READ,      0x02
  .equ LOAD_DISK_CYLINDER,  0x00
  .equ LOAD_DISK_HEAD,      0x00
  .equ LOAD_DISK_SECTOR,    0x02

load_disk:
  push %dx

  mov $LOAD_DISK_READ, %ah
  mov %dh, %al
  mov $LOAD_DISK_CYLINDER, %ch
  mov $LOAD_DISK_HEAD, %dh
  mov $LOAD_DISK_SECTOR, %cl

  int $LOAD_DISK_INT
  pop %dx
  jc load_disk_error

  cmp %dh, %al
  jne load_disk_error

  ret

load_disk_error:
  push %ax
  push %dx

  mov $load_disk_error_message, %si
  call print_string
  call print_newline

  mov $load_disk_error_expected_message, %si
  call print_string

  pop %dx
  mov %dh, %dl
  xor %dh, %dh
  call print_hex
  call print_newline

  mov $load_disk_error_read_message, %si
  call print_string

  pop %ax
  xor %ah, %ah
  mov %ax, %dx
  call print_hex
  call print_newline

load_disk_wait:
  hlt
  jmp load_disk_wait

load_disk_error_message:
  .asciz "Disk load error..."

load_disk_error_expected_message:
  .asciz "Expected sectors: "

load_disk_error_read_message:
  .asciz "Read sectors: "
