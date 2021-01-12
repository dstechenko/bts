  .code32
  .extern kernel_main

kernel_entry:
  call kernel_main

kernel_wait:
  hlt
  jmp kernel_wait
