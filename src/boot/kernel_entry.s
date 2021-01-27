  .code32

  .text

  .extern kernel_main
  .extern _init
  .global kernel_entry

kernel_entry:
  call _init
  call kernel_main

kernel_wait:
  hlt
  jmp kernel_wait
