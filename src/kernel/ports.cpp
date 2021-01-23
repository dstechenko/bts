#include <kernel/ports.hpp>

namespace dokkan::kernel {

/* static */
std::uint8_t Ports::readByte(std::uint16_t port) {
  std::uint8_t in;
  asm volatile("in %%dx, %%al" : "=a"(in) : "d"(port));
  return in;
}

/* static */
void Ports::writeByte(std::uint16_t port, std::uint8_t data) {
  asm volatile("out %%al, %%dx" : : "a"(data), "d"(port));
}

/* static */
std::uint16_t Ports::readWord(std::uint16_t port) {
  std::uint16_t in;
  asm volatile("in %%dx, %%ax" : "=a"(in) : "d"(port));
  return in;
}

/* static */
void Ports::writeWord(std::uint16_t port, std::uint16_t data) {
  asm volatile("out %%ax, %%dx" : : "a"(data), "d"(port));
}

}  // namespace dokkan::kernel
