boot_sector:
  .code16

  .equ BOOT_SECTOR_OFFSET,              0x7C00
  .equ BOOT_SECTOR_SIZE,                0x0200
  .equ BOOT_SIGNATURE,                  0xAA55
  .equ BOOT_SIGNATURE_SIZE,             0x0002

  .equ BOOT_STACK_LOCATION,             0x9000
  .equ BOOT_DRIVE_INIT_VALUE,           0x00

  .equ BOOT_KERNEL_SECTORS,             0x0001

  .equ BOOT_PROTECTED_STACK_LOCATION,   0x00090000
  .equ BOOT_PROTECTED_ENABLE_GDT_FLAG,  0x00000001

  .text

  .global boot_main

boot_main:
  jmp boot_init

  .include "boot/load.s"
  .include "boot/print.s"
  .include "boot/gdt.s"

boot_init:
  .code16

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

boot_load_kernel:
  mov $boot_kernel_sector, %bx
  mov $BOOT_KERNEL_SECTORS, %dh
  mov (boot_drive), %dl
  call load_bios

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

boot_kernel:
  call boot_kernel_sector

boot_wait:
  hlt
  jmp boot_wait

boot_drive:
  .byte BOOT_DRIVE_INIT_VALUE

  .space BOOT_SECTOR_SIZE - BOOT_SIGNATURE_SIZE - (. - boot_sector)
  .word BOOT_SIGNATURE

boot_kernel_sector:
