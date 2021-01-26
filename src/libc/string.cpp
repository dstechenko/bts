#include <stdint.h>
#include <string.h>

void* memcpy(void* dst, const void* src, size_t num) {
  auto* dstBytes = reinterpret_cast<uint8_t*>(dst);
  const auto* srcBytes = reinterpret_cast<const uint8_t*>(src);
  for (size_t it = 0; it < num; it++) {
    dstBytes[it] = srcBytes[it];
  }
  return dst;
}

size_t strlen(const char* str) {
  size_t len = 0;
  while (str[len] != 0) {
    len++;
  }
  return len;
}
