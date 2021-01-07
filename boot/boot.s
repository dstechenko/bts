.code64

.equ BOOT_SECTOR_SIZE, 512
.equ BOOT_SIGNATURE_SIZE, 2
.equ BOOT_SIGNATURE, 0xAA55

.global _start

.text

_start:
  jmp .
  .space BOOT_SECTOR_SIZE - BOOT_SIGNATURE_SIZE - (. - _start)
  .word BOOT_SIGNATURE
