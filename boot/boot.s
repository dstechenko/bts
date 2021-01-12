boot_sector:
  .equ BOOT_SECTOR_SIZE,                0x0200
  .equ BOOT_SIGNATURE,                  0xAA55
  .equ BOOT_SIGNATURE_SIZE,             0x0002

  .equ BOOT_STACK_LOCATION,             0x9000
  .equ BOOT_DRIVE_INIT_VALUE,           0x00

  .equ BOOT_KERNEL_LOCATION,            0xA000
  .equ BOOT_KERNEL_SECTORS,             0x0001

  .equ BOOT_PROTECTED_STACK_LOCATION,   0x00090000
  .equ BOOT_PROTECTED_ENABLE_GDT_FLAG,  0x00000001

  .text

  .global boot_main

boot_main:
  .code16

  jmp boot_init

  .include "boot/load_bios.s"
  .include "boot/print_bios.s"
  .include "boot/print_vga.s"
  .include "boot/gdt.s"

boot_init:

boot_init_drive:
  mov %dl, (boot_drive)

boot_init_segments:
  xor %ax, %ax
  mov %ax, %es
  mov %ax, %ds
  mov %ax, %ss

boot_init_stack:
  mov $BOOT_STACK_LOCATION, %bp
  mov %bp, %sp

boot_print_debug:
  mov $boot_real_mode_message, %si
  call print_bios_string

  mov $boot_drive_message, %si
  call print_bios_string
  xor %dx, %dx
  mov (boot_drive), %dl
  call print_bios_hex

  mov $boot_stack_message, %si
  call print_bios_string
  mov $BOOT_STACK_LOCATION, %dx
  call print_bios_hex

boot_load_kernel:
  mov $BOOT_KERNEL_LOCATION, %bx
  mov $BOOT_KERNEL_SECTORS, %dh
  mov (boot_drive), %dl
  call load_bios

  mov $boot_load_message, %si
  call print_bios_string
  mov (BOOT_KERNEL_LOCATION), %dx
  call print_bios_hex

boot_protected_mode:
  cli

  lgdt (gdt_descriptor)

  mov %cr0, %eax
  or $BOOT_PROTECTED_ENABLE_GDT_FLAG, %eax
  mov %eax, %cr0

  jmp $GDT_CODE_SEGMENT, $boot_init_protected_mode

boot_init_protected_mode:
  .code32

  mov $GDT_DATA_SEGMENT, %ax

  mov %ax, %ds
  mov %ax, %ss
  mov %ax, %es
  mov %ax, %fs
  mov %ax, %gs

  mov $BOOT_PROTECTED_STACK_LOCATION, %ebp;
  mov %ebp, %esp

  mov $boot_protected_mode_message, %ebx
  call print_vga_string

boot_with_protected_mode:
  hlt
  jmp boot_with_protected_mode

boot_real_mode_message:
  .asciz "Booting in Real Mode..."

boot_protected_mode_message:
  .asciz "\nBooting in Protected Mode...\r\n"

boot_drive_message:
  .asciz "\r\nBoot drive: "

boot_stack_message:
  .asciz "\r\nStack pointer base: "

boot_load_message:
  .asciz "\r\nDisk load: "

boot_drive:
  .byte BOOT_DRIVE_INIT_VALUE

  .space BOOT_SECTOR_SIZE - BOOT_SIGNATURE_SIZE - (. - boot_sector)
  .word BOOT_SIGNATURE

  .word 0xFACE
  .space BOOT_SECTOR_SIZE - BOOT_SIGNATURE_SIZE
