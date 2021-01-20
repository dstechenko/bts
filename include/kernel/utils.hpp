#ifndef DOKKAN_KERNEL_UTILS_H
#define DOKKAN_KERNEL_UTILS_H

#include <cpu/types.hpp>

namespace dokkan::kernel {

class Utils {
 public:
  explicit Utils() = delete;
  static void copyMemory(uint8_t* src, uint8_t* dst, int num);
  static void convertIntToAscii(int in, string_t out);
};

}  // namespace dokkan::kernel

#endif
