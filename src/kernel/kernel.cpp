#include <cstddef>

#include <drivers/screen.hpp>
#include <portability/require.hpp>

using dokkan::drivers::Screen;

namespace dokkan::kernel {

namespace {

class Parent {
 public:
  virtual ~Parent() = default;
  virtual std::size_t limit() = 0;
};

class Child : public Parent {
 public:
  std::size_t limit() override { return 15; }
};

void init() {
  Screen::clear();
  Child child;
  for (std::size_t it = 0; it < child.limit(); it++) {
    for (std::size_t jt = 0; jt < it; jt++) {
      Screen::print("*");
    }
    Screen::printLine();
  }
  for (std::size_t it = child.limit(); it > 0; it--) {
    for (std::size_t jt = 0; jt < it; jt++) {
      Screen::print("*");
    }
    Screen::printLine();
  }
}

}  // namespace

}  // namespace dokkan::kernel

extern "C" void kernel_main() { dokkan::kernel::init(); }
