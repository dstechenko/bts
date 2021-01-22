#include <drivers/screen.hpp>

using dokkan::drivers::Screen;

namespace dokkan::kernel {

namespace {

void init() {
  Screen::clear();
  for (size_t it = 0; it <= 15; it++) {
    for (size_t jt = 0; jt <= it; jt++) {
      Screen::print("*");
    }
    Screen::printLine();
  }
  for (size_t it = 15; it >= 0; it--) {
    for (size_t jt = 0; jt <= it; jt++) {
      Screen::print("*");
    }
    Screen::printLine();
  }
}

}  // namespace

}  // namespace dokkan::kernel

extern "C" void kernel_main() { dokkan::kernel::init(); }
