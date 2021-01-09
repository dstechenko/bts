gdt_sector:
  .code16

  .equ GDT_SECTION_SIZE,            0x08

  .equ GDT_CODE_LIMIT_0_15,         0xFFFF
  .equ GDT_CODE_BASE_0_15,          0x0000
  .equ GDT_CODE_BASE_16_23,         0x0000
  .equ GDT_CODE_FLAGS,              0b10011010
  .equ GDT_CODE_FLAGS_LIMIT_16_19,  0b11001111
  .equ GDT_CODE_BASE_24_31,         0x00

  .equ GDT_DATA_LIMIT_0_15,         0xFFFF
  .equ GDT_DATA_BASE_0_15,          0x0000
  .equ GDT_DATA_BASE_16_23,         0x0000
  .equ GDT_DATA_FLAGS,              0b10010010
  .equ GDT_DATA_FLAGS_LIMIT_16_19,  0b11001111
  .equ GDT_DATA_BASE_24_31,         0x00

gdt_null:
  .space GDT_SECTION_SIZE

gdt_code:
  .word GDT_CODE_LIMIT_0_15
  .word GDT_CODE_BASE_0_15
  .byte GDT_CODE_BASE_16_23
  .byte GDT_CODE_FLAGS
  .byte GDT_CODE_FLAGS_LIMIT_16_19
  .byte GDT_CODE_BASE_24_31

gdt_data:
  .word GDT_DATA_LIMIT_0_15
  .word GDT_DATA_BASE_0_15
  .byte GDT_DATA_BASE_16_23
  .byte GDT_DATA_FLAGS
  .byte GDT_DATA_FLAGS_LIMIT_16_19
  .byte GDT_DATA_BASE_24_31

gdt_exit:

gdt_descriptor:
  .word gdt_exit - gdt_sector -1
  .long gdt_sector

  .equ CODE_SEGMENT, gdt_code - gdt_sector
  .equ DATA_SEGMENT, gdt_data - gdt_sector
