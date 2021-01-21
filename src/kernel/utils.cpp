#include <kernel/utils.hpp>

namespace dokkan::kernel {

/* static */
void Utils::copyMemory(void* dst, const void* src, size_t num) {
  auto* dstBytes = reinterpret_cast<uint8_t*>(dst);
  const auto* srcBytes = reinterpret_cast<const uint8_t*>(src);
  for (size_t it = 0; it < num; it++) {
    dstBytes[it] = srcBytes[it];
  }
}

}  // namespace dokkan::kernel
