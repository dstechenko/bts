#ifndef DOKKAN_KERNEL_PORTS_H
#define DOKKAN_KERNEL_PORTS_H

#include <libstd/types.hpp>

namespace dokkan::kernel {

class Ports {
public:
  explicit Ports() = delete;
  byte_t readByte(word_t port);
  void writeByte(word_t port, byte_t data);
  word_t readWord(word_t port);
  void writeWord(word_t port, word_t data);
};

} // namespace dokkan::kernel

#endif
