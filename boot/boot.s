boot_sector:
  .code16

  .equ BOOT_SECTOR_SIZE,                0x0200
  .equ BOOT_SIGNATURE,                  0xAA55
  .equ BOOT_SIGNATURE_SIZE,             0x0002
  .equ BOOT_STACK_LOCATION,             0x8000
  .equ BOOT_STACK_PROTECTED_LOCATION,   0x00090000
  .equ BOOT_KERNEL_LOCATION,            0x9000
  .equ BOOT_KERNEL_SECTORS,             0x0002
  .equ BOOT_DRIVE_INIT_VALUE,           0x00
  .equ BOOT_ENABLE_GDT_FLAG,            0x00000001

  .text

  .global boot_main

boot_main:
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

  call boot_enter_protected

boot_drive:
  .byte BOOT_DRIVE_INIT_VALUE

boot_message:
  .asciz "\nBooting Dokkan...\r\n"

stack_debug_message:
  .asciz "\nDebug stack pointer:\r\n"

load_debug_message:
  .asciz "\nDebug load data:\r\n"

  .include "boot/print.s"
  .include "boot/disk.s"

  .space BOOT_SECTOR_SIZE - BOOT_SIGNATURE_SIZE - (. - boot_sector)
  .word BOOT_SIGNATURE

  .word 0xBEEF
  .space BOOT_SECTOR_SIZE - BOOT_SIGNATURE_SIZE

  .include "boot/gdt.s"

boot_enter_protected:
  cli
  lgdt (gdt_descriptor)
  mov %cr0, %eax
  or $BOOT_ENABLE_GDT_FLAG, %eax
  mov %eax, %cr0
  jmp $CODE_SEGMENT, $boot_init_protected

boot_init_protected:
  .code32

  mov $DATA_SEGMENT, %ax

  mov %ax, %ds
  mov %ax, %ss
  mov %ax, %es
  mov %ax, %fs
  mov %ax, %gs

  mov $BOOT_STACK_PROTECTED_LOCATION, %ebp;
  mov %ebp, %esp

  call boot_protected

boot_protected:
  call boot_hang

boot_hang:
  hlt
  jmp boot_hang

  .space BOOT_SECTOR_SIZE - (. - boot_protected)
  .space BOOT_SECTOR_SIZE
