#include <kernel/ports.hpp>

namespace dokkan::kernel {

byte_t port_byte_in(const word_t port) {
  byte_t in;
  asm("in %%dx, %%al" : "=a"(in) : "d"(port));
  return in;
}

void port_byte_out(const word_t port, const byte_t data) {
  asm("out %%al, %%dx" : : "a"(data), "d"(port));
}

word_t port_word_in(const word_t port) {
  word_t in;
  asm("in %%dx, %%ax" : "=a"(in) : "d"(port));
  return in;
}

void port_word_out(const word_t port, const word_t data) {
  asm("out %%ax, %%dx" : : "a"(data), "d"(port));
}

} // namespace dokkan::kernel
