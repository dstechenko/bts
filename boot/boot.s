boot_sector:
  .code16

  .equ BOOT_SECTOR_SIZE,      0x0200
  .equ BOOT_SIGNATURE_SIZE,   0x0002
  .equ BOOT_SIGNATURE,        0xAA55
  .equ BOOT_STACK_LOCATION,   0x8000
  .equ BOOT_KERNEL_LOCATION,  0x9000
  .equ BOOT_KERNEL_SECTORS,   0x0003

  .text

  .global boot_main

boot_main:
  mov   %dl, (boot_drive)

  mov   $BOOT_STACK_LOCATION, %bp
  mov   %bp, %sp

  mov   $boot_message, %si
  call  print_string

  mov   $stack_debug_message, %si
  call  print_string
  mov   %sp, %dx
  call  print_hex

  mov   $BOOT_KERNEL_LOCATION, %bx
  mov   $BOOT_KERNEL_SECTORS, %dh
  mov   (boot_drive), %dl
  call  disk_load

  mov   $load_debug_message, %si
  call  print_string
  mov   (BOOT_KERNEL_LOCATION), %dx
  call  print_hex
  mov   (BOOT_KERNEL_LOCATION + BOOT_SECTOR_SIZE), %dx
  call  print_hex

  call  boot_wait

boot_wait:
  jmp   .

stack_debug_message:
  .asciz  "\nDebug stack pointer:\r\n"

load_debug_message:
  .asciz  "\nDebug load data:\r\n"

boot_message:
  .asciz  "\nBooting Dokkan...\r\n"

boot_drive:
  .byte   0x00

  .include "boot/print.s"
  .include "boot/load.s"

  .space  BOOT_SECTOR_SIZE - BOOT_SIGNATURE_SIZE - (. - boot_sector)
  .word   BOOT_SIGNATURE

  .word   0xDEAD
  .space  BOOT_SECTOR_SIZE - BOOT_SIGNATURE_SIZE

  .word   0xFACE
  .space  BOOT_SECTOR_SIZE - BOOT_SIGNATURE_SIZE

  .space  BOOT_SECTOR_SIZE
