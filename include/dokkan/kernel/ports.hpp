#ifndef DOKKAN_KERNEL_PORTS_H
#define DOKKAN_KERNEL_PORTS_H

#include <cstdint>

namespace dokkan::kernel {

class Ports {
 public:
  explicit Ports() = delete;
  static std::uint8_t readByte(std::uint16_t port);
  static void writeByte(std::uint16_t port, std::uint8_t data);
  static std::uint16_t readWord(std::uint16_t port);
  static void writeWord(std::uint16_t port, std::uint16_t data);
};

}  // namespace dokkan::kernel

#endif
