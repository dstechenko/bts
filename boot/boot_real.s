boot_real_enter:
  .code16

  mov %dl, (boot_drive)

  mov $boot_real_enter_message, %si
  call print_bios_string

  mov $boot_real_drive_message, %si
  call print_bios_string
  xor %dx, %dx
  mov (boot_drive), %dl
  call print_bios_hex

  mov $boot_real_stack_message, %si
  call print_bios_string
  mov $BOOT_STACK_LOCATION, %dx
  call print_bios_hex

  ret

boot_real_enter_message:
  .asciz "\nBooting Dokkan in Real Mode...\r\n"

boot_real_drive_message:
  .asciz "Boot drive:\r\n"

boot_real_stack_message:
  .asciz "Stack pointer base:\r\n"
