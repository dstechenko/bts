boot_sector:
  .code16

  .text

  .global boot_entry

  .equ BOOT_SECTOR_OFFSET,              0x7C00
  .equ BOOT_SECTOR_SIZE,                0x0200

  .equ BOOT_STACK_SIZE,                 BOOT_SECTOR_SIZE
  .equ BOOT_STACK_TOP,                  BOOT_SECTOR_OFFSET + BOOT_SECTOR_SIZE + BOOT_STACK_SIZE - 0x0001

  .equ BOOT_KERNEL_LOCATION,            BOOT_STACK_TOP + 0x0001
  .equ BOOT_KERNEL_SECTORS,             0x05

  .equ BOOT_SIGNATURE,                  0xAA55
  .equ BOOT_SIGNATURE_SIZE,             0x0002

  .equ BOOT_PROTECTED_ENABLE_GDT_FLAG,  0x00000001
  .equ BOOT_PROTECTED_STACK_TOP,        0x00FFFFFF

boot_entry:

boot_main:
  jmp boot_init

  .include "load.s"
  .include "print.s"
  .include "gdt.s"

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
  mov $BOOT_STACK_TOP, %bp
  mov %bp, %sp

boot_load_kernel:
  mov $BOOT_KERNEL_LOCATION, %bx
  mov $BOOT_KERNEL_SECTORS, %dh
  mov (boot_drive), %dl
  call load_disk

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

  mov $BOOT_PROTECTED_STACK_TOP, %ebp;
  mov %ebp, %esp

boot_kernel:
  call BOOT_KERNEL_LOCATION
  cli

boot_wait:
  hlt
  jmp boot_wait

boot_drive:
  .byte 0x00

  .space BOOT_SECTOR_SIZE - BOOT_SIGNATURE_SIZE - (. - boot_sector)
  .word BOOT_SIGNATURE
