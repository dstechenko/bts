#ifndef DOKKAN_DRIVERS_SCREEN_H
#define DOKKAN_DRIVERS_SCREEN_H

#include <cpu/types.hpp>

namespace dokkan::drivers {

class Screen {
 public:
  explicit Screen() = delete;
  static void print(string_t data);
  static void printAt(string_t data, int col, int row);
  static void printLine(string_t);
  static void printLine();
  static void clear();
};

}  // namespace dokkan::drivers

#endif
