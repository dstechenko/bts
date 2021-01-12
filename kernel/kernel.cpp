extern "C" void kernel_main() {
  char* video_memory = (char*) 0x000B8000;
  *video_memory = 'X';
}
