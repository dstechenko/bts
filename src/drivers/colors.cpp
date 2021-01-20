#include <drivers/colors.hpp>

namespace dokkan::drivers {

/* static */
uint8_t Colors::make(Color foreground, Color background) {
  return (static_cast<uint8_t>(background) << 4) +
         static_cast<uint8_t>(foreground);
}

/* static */
uint8_t Colors::makeDefault() {
  return make(/* foreground = */ Color::GREEN,
              /* background = */ Color::BLACK);
}

}  // namespace dokkan::drivers
