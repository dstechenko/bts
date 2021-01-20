#include <kernel/ports.hpp>

namespace dokkan::kernel {

byte_t Ports::readByte(const word_t port) {
  byte_t in;
  asm("in %%dx, %%al" : "=a"(in) : "d"(port));
  return in;
}

void Ports::writeByte(const word_t port, const byte_t data) {
  asm("out %%al, %%dx" : : "a"(data), "d"(port));
}

word_t Ports::readWord(const word_t port) {
  word_t in;
  asm("in %%dx, %%ax" : "=a"(in) : "d"(port));
  return in;
}

void Ports::writeWord(const word_t port, const word_t data) {
  asm("out %%ax, %%dx" : : "a"(data), "d"(port));
}

} // namespace dokkan::kernel
