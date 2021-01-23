#include <stddef.h>

#include <drivers/screen.hpp>

using dokkan::drivers::Screen;

namespace dokkan::kernel {

namespace {

class Parent {
 public:
  virtual ~Parent() = default;
  virtual size_t limit() = 0;
};

class Child : public Parent {
 public:
  size_t limit() override { return 15; }
};

void init() {
  Child child;
  Screen::clear();
  for (size_t it = 0; it < child.limit(); it++) {
    for (size_t jt = 0; jt < it; jt++) {
      Screen::print("*");
    }
    Screen::printLine();
  }
  for (size_t it = child.limit(); it > 0; it--) {
    for (size_t jt = 0; jt < it; jt++) {
      Screen::print("*");
    }
    Screen::printLine();
  }
}

}  // namespace

}  // namespace dokkan::kernel

extern "C" void kernel_main() { dokkan::kernel::init(); }
