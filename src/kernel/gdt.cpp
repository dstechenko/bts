#include <kernel/bits.hpp>
#include <kernel/gdt.hpp>

namespace dokkan::kernel {

namespace {
GdtPointer pointer;
}

/* static */
void GdtControl::init(GdtEntry* base, uint16_t limit) {
  pointer.base = reinterpret_cast<uint32_t>(base);
  pointer.limit = limit;
}

/* static */
void GdtControl::flush() {}

/* static */
void GdtControl::set(GdtEntry* entry, uint32_t base, uint32_t limit,
                     uint8_t access, uint8_t granularity) {
  entry->baseLow = LOW_WORD(base);
  entry->baseMiddle = LOW_BYTE(base >> 16);
  entry->baseHigh = LOW_BYTE(base >> 24);
  entry->limitLow = LOW_WORD(limit);
}

}  // namespace dokkan::kernel
