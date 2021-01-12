  .equ BOOT_PROT_STACK_LOCATION,   0x00090000
  .equ BOOT_PROT_ENABLE_GDT_FLAG,  0x00000001

boot_prot_enter:
  .code16

  cli

  lgdt (gdt_descriptor)

  mov %cr0, %eax
  or $BOOT_PROT_ENABLE_GDT_FLAG, %eax
  mov %eax, %cr0

  jmp $GDT_CODE_SEGMENT, $boot_prot_init

boot_prot_init:
  .code32

  mov $GDT_DATA_SEGMENT, %ax

  mov %ax, %ds
  mov %ax, %ss
  mov %ax, %es
  mov %ax, %fs
  mov %ax, %gs

  mov $BOOT_PROT_STACK_LOCATION, %ebp;
  mov %ebp, %esp

  mov $boot_prot_enter_message, %ebx
  call print_vga_string

  mov $boot_prot_stack_message, %ebx
  call print_vga_string

  ret

boot_prot_enter_message:
  .asciz "\nBooting Dokkan in Protected Mode...\r\n"

boot_prot_stack_message:
  .asciz "Stack pointer:\r\n"
