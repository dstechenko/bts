#include <drivers/screen.hpp>

using dokkan::drivers::Screen;

namespace dokkan::kernel {

namespace {

void init() {
  Screen::clear();

  for (size_t it = 0; it <= 30; it++) {
    for (size_t jt = 0; jt < it; jt++) {
      Screen::print("*");
    }
    Screen::printLine();
  }

  Screen::printLine("Dokkan kernel init...");
}

}  // namespace

}  // namespace dokkan::kernel

extern "C" void kernel_main() { dokkan::kernel::init(); }
