#ifndef DOKKAN_KERNEL_PORTS_H
#define DOKKAN_KERNEL_PORTS_H

#include <stdint.h>

namespace dokkan::kernel {

class Ports {
 public:
  explicit Ports() = delete;
  static uint8_t readByte(uint16_t port);
  static void writeByte(uint16_t port, uint8_t data);
  static uint16_t readWord(uint16_t port);
  static void writeWord(uint16_t port, uint16_t data);
};

}  // namespace dokkan::kernel

#endif
