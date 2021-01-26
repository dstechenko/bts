ENTRY(boot_entry)

OUTPUT_FORMAT(binary)

SECTIONS
{
  .text (0x7C00) :
  {
    *(.text)
  }
  .data :
  {
    *(.data)
  }
  .rodata :
  {
    *(.rodata)
  }
  .bss :
  {
    *(.bss*)
  }
}
