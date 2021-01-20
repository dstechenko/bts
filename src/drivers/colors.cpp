#include <drivers/colors.hpp>

namespace dokkan::drivers {

/* static */
byte_t Colors::make(Color foreground, Color background) {
  return (static_cast<byte_t>(background) << 4) +
         static_cast<byte_t>(foreground);
}

/* static */
byte_t Colors::makeDefault() {
  return make(/* foreground = */ Color::GREEN,
              /* background = */ Color::BLACK);
}

}  // namespace dokkan::drivers
