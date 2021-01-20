#include <kernel/ports.hpp>

namespace dokkan::kernel {

/* static */
byte_t Ports::readByte(word_t port) {
  byte_t in;
  asm("in %%dx, %%al" : "=a"(in) : "d"(port));
  return in;
}

/* static */
void Ports::writeByte(word_t port, byte_t data) {
  asm("out %%al, %%dx" : : "a"(data), "d"(port));
}

/* static */
word_t Ports::readWord(word_t port) {
  word_t in;
  asm("in %%dx, %%ax" : "=a"(in) : "d"(port));
  return in;
}

/* static */
void Ports::writeWord(word_t port, word_t data) {
  asm("out %%ax, %%dx" : : "a"(data), "d"(port));
}

}  // namespace dokkan::kernel
