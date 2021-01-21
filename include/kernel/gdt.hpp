#ifndef DOKKAN_KERNEL_GDT_H
#define DOKKAN_KERNEL_GDT_H

#include <cpu/types.hpp>
#include <portability/layout.hpp>

namespace dokkan::kernel {

struct GdtEntry {
  uint16_t limitLow;
  uint16_t baseLow;
  uint8_t baseMiddle;
  uint8_t access;
  uint8_t granularity;
  uint8_t baseHigh;
} PACKED;

struct GdtPointer {
  uint16_t limit;
  uint32_t base;
} PACKED;

class GdtControl {
 public:
  explicit GdtControl() = delete;
  static void init(GdtEntry* base, uint16_t limit);
  static void flush();
  static void set(GdtEntry* entry, uint32_t base, uint32_t limit,
                  uint8_t access, uint8_t granularity);
};

class GdtDefault {
 public:
  explicit GdtDefault() = delete;
};

}  // namespace dokkan::kernel

#endif
