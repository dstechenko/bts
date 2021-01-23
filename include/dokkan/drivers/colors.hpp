#ifndef DOKKAN_DRIVERS_COLORS_H
#define DOKKAN_DRIVERS_COLORS_H

#include <cstdint>

namespace dokkan::drivers {

enum class Color : std::uint8_t {
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
  static std::uint8_t make(Color foreground, Color background);
  static std::uint8_t makeDefault();
};

}  // namespace dokkan::drivers

#endif
