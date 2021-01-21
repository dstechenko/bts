#ifndef DOKKAN_DRIVERS_SCREEN_H
#define DOKKAN_DRIVERS_SCREEN_H

#include <cpu/types.hpp>

namespace dokkan::drivers {

class Screen {
 public:
  explicit Screen() = delete;
  static void print(const char* data);
  static void printAt(const char* data, int col, int row);
  static void printLine(const char*);
  static void printLine();
  static void clear();
};

}  // namespace dokkan::drivers

#endif
