#ifndef DOKKAN_DRIVERS_SCREEN_H
#define DOKKAN_DRIVERS_SCREEN_H

#include <libstd/types.hpp>

namespace dokkan::drivers {

class Screen {
public:
  explicit Screen() = delete;
  static void print(string_t data);
  static void print(string_t data, int col, int row);
};

} // namespace dokkan::drivers

#endif
