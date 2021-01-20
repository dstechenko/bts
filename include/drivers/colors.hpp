#ifndef DOKKAN_DRIVERS_COLORS_H
#define DOKKAN_DRIVERS_COLORS_H

#include <cpu/types.hpp>

namespace dokkan::drivers {

enum class Color : byte_t {
  BLACK,
  BLUE,
  GREEN,
  CYAN,
  RED,
  MAGENTA,
  BROWN,
  LIGHT_GRAY,
  DARK_GRAY,
  LIGHT_BLUE,
  LIGHT_GREEN,
  LIGHT_CYAN,
  LIGHT_RED,
  PINK,
  YELLOW,
  WHITE,
};

class Colors {
 public:
  explicit Colors() = delete;
  static byte_t make(Color foreground, Color background);
  static byte_t makeDefault();
};

}  // namespace dokkan::drivers

#endif
