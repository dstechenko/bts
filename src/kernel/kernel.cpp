#include <drivers/screen.hpp>

using dokkan::drivers::Screen;

namespace dokkan::kernel {

void kernel_init() {
  Screen::clear();
  for (int it = 1; it <= 24; it++) {
    for (int jt = 1; jt <= it; jt++) {
      Screen::print("*");
    }
    Screen::printLine();
  }
}

}  // namespace dokkan::kernel

extern "C" void kernel_main() { dokkan::kernel::kernel_init(); }
