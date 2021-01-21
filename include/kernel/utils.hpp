#ifndef DOKKAN_KERNEL_UTILS_H
#define DOKKAN_KERNEL_UTILS_H

#include <cpu/types.hpp>

namespace dokkan::kernel {

class Utils {
 public:
  explicit Utils() = delete;
  static void fillMemory(void* dst, uint8_t val, size_t num);
  static void copyMemory(void* dst, const void* src, size_t num);
  static void copyString(char* dst, const char* src);
  static void sizeString(const char* str);
  static void convertIntToAsciiDec(int32_t in, char* out);
  static void convertIntToAsciiHex(int32_t in, char* out);
};

}  // namespace dokkan::kernel

#endif
