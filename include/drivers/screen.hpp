#ifndef DOKKAN_DRIVERS_SCREEN_H
#define DOKKAN_DRIVERS_SCREEN_H

#include <cpu/types.hpp>

namespace dokkan::drivers {

class Screen {
 public:
  explicit Screen() = delete;
  static void print(const char* text);
  static void printAt(const char* text, size_t col, size_t row);
  static void printLine(const char* text);
  static void printLine();
  static void clear();
};

}  // namespace dokkan::drivers

#endif
