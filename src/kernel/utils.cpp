#include <kernel/utils.hpp>

namespace dokkan::kernel {

/* static */
void Utils::copyMemory(uint8_t* src, uint8_t* dst, int num) {
  for (int it = 0; it < num; it++) {
    dst[it] = src[it];
  }
}

/* static */
void Utils::convertIntToAscii(int in, string_t out) {}

}  // namespace dokkan::kernel
