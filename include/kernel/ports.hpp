#ifndef DOKKAN_KERNEL_PORTS_H
#define DOKKAN_KERNEL_PORTS_H

#include <cpu/types.hpp>

namespace dokkan::kernel {

class Ports {
 public:
  explicit Ports() = delete;
  static byte_t readByte(word_t port);
  static void writeByte(word_t port, byte_t data);
  static word_t readWord(word_t port);
  static void writeWord(word_t port, word_t data);
};

}  // namespace dokkan::kernel

#endif
