boot_sector:
  .code16

  .equ BOOT_SECTOR_SIZE,                0x0200
  .equ BOOT_SIGNATURE,                  0xAA55
  .equ BOOT_SIGNATURE_SIZE,             0x0002
  .equ BOOT_STACK_LOCATION,             0x9000
  .equ BOOT_DRIVE_INIT_VALUE,           0x00

  .text

  .global boot_main

boot_main:
  jmp boot_init

  .include "boot/print_bios.s"
  .include "boot/boot_real.s"

  .include "boot/print_vga.s"
  .include "boot/gdt.s"
  .include "boot/boot_prot.s"

boot_init:
  mov $BOOT_STACK_LOCATION, %bp
  mov %bp, %sp

  call boot_real_enter
  call boot_prot_enter

  call boot_hang

boot_hang:
  hlt
  jmp boot_hang

boot_drive:
  .byte BOOT_DRIVE_INIT_VALUE

  .space BOOT_SECTOR_SIZE - BOOT_SIGNATURE_SIZE - (. - boot_sector)
  .word BOOT_SIGNATURE
