ENTRY(kernel_entry)

OUTPUT_FORMAT(binary)

SECTIONS
{
  .text (0x8000) :
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
