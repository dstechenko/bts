  .code32
  .extern kernel_main
  .global kernel_entry

kernel_entry:
  call kernel_main

kernel_wait:
  hlt
  jmp kernel_wait
