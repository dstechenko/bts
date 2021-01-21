#include <drivers/screen.hpp>

using dokkan::drivers::Screen;

namespace dokkan::kernel {

namespace {

void init() {
  Screen::clear();
  Screen::printLine("Dokkan kernel init...");
}

}  // namespace

}  // namespace dokkan::kernel

extern "C" void kernel_main() { dokkan::kernel::init(); }
