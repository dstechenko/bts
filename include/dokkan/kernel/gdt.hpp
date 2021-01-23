#ifndef DOKKAN_KERNEL_GDT_H
#define DOKKAN_KERNEL_GDT_H

#include <cstdint>

#include <portability/layout.hpp>

namespace dokkan::kernel {

struct GdtEntry {
  std::uint16_t limitLow;
  std::uint16_t baseLow;
  std::uint8_t baseMiddle;
  std::uint8_t access;
  std::uint8_t granularity;
  std::uint8_t baseHigh;
} PACKED;

struct GdtPointer {
  std::uint16_t limit;
  std::uint32_t base;
} PACKED;

class GdtControl {
 public:
  explicit GdtControl() = delete;
  static void init(GdtEntry* base, std::uint16_t limit);
  static void flush();
  static void set(GdtEntry* entry, std::uint32_t base, std::uint32_t limit,
                  std::uint8_t access, std::uint8_t granularity);
};

class GdtDefault {
 public:
  explicit GdtDefault() = delete;
};

}  // namespace dokkan::kernel

#endif
