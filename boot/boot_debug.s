boot_sector:
  .code16

  .equ BOOT_SECTOR_SIZE,                0x0200
  .equ BOOT_SIGNATURE,                  0xAA55
  .equ BOOT_SIGNATURE_SIZE,             0x0002
  .equ BOOT_STACK_LOCATION,             0x8500
  .equ BOOT_KERNEL_LOCATION,            0x9000
  .equ BOOT_KERNEL_SECTORS,             0x0002
  .equ BOOT_DRIVE_INIT_VALUE,           0x00

  .text

  .global boot_main

rm_enter:
  mov %dl, (boot_drive)

  mov $BOOT_STACK_LOCATION, %bp
  mov %bp, %sp

  mov $boot_message, %si
  call print_string

  mov $stack_debug_message, %si
  call print_string
  mov %sp, %dx
  call print_hex

  mov $BOOT_KERNEL_LOCATION, %bx
  mov $BOOT_KERNEL_SECTORS, %dh
  mov (boot_drive), %dl
  call disk_load

  mov $load_debug_message, %si
  call print_string
  mov (BOOT_KERNEL_LOCATION), %dx
  call print_hex

  call boot_hang

boot_protected:
  call boot_hang

boot_hang:
  hlt
  jmp boot_hang

boot_drive:
  .byte BOOT_DRIVE_INIT_VALUE

rm_enter_message:
  .asciz "\nBooting Dokkan in Real Mode...\r\n"

stack_debug_message:
  .asciz "\nDebug stack pointer:\r\n"

load_debug_message:
  .asciz "\nDebug load data:\r\n"
