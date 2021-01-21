#include <kernel/ports.hpp>

namespace dokkan::kernel {

/* static */
uint8_t Ports::readByte(uint16_t port) {
  uint8_t in;
  asm volatile("in %%dx, %%al" : "=a"(in) : "d"(port));
  return in;
}

/* static */
void Ports::writeByte(uint16_t port, uint8_t data) {
  asm volatile("out %%al, %%dx" : : "a"(data), "d"(port));
}

/* static */
uint16_t Ports::readWord(uint16_t port) {
  uint16_t in;
  asm volatile("in %%dx, %%ax" : "=a"(in) : "d"(port));
  return in;
}

/* static */
void Ports::writeWord(uint16_t port, uint16_t data) {
  asm volatile("out %%ax, %%dx" : : "a"(data), "d"(port));
}

}  // namespace dokkan::kernel
