#include <drivers/screen.hpp>

using dokkan::drivers::Screen;

namespace dokkan::kernel {

void kernel_init() {
  char *video_memory = (char *)0x000B8000;
  *video_memory = 'X';
  Screen::print("");
}

} // namespace dokkan::kernel

extern "C" void kernel_main() { dokkan::kernel::kernel_init(); }
