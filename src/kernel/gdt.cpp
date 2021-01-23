#include <kernel/bits.hpp>
#include <kernel/gdt.hpp>

namespace dokkan::kernel {

namespace {
GdtPointer control;
}

extern "C" void gdt_flush(std::uint32_t pointer);

/* static */
void GdtControl::init(GdtEntry* base, std::uint16_t limit) {
  control.base = reinterpret_cast<std::uint32_t>(base);
  control.limit = limit;
}

/* static */
void GdtControl::flush() {}

/* static */
void GdtControl::set(GdtEntry* entry, std::uint32_t base, std::uint32_t limit,
                     std::uint8_t access, std::uint8_t granularity) {
  entry->baseLow = LOW_WORD(base);
  entry->baseMiddle = LOW_BYTE(HIGH_WORD(base));
  entry->baseHigh = HIGH_BYTE(HIGH_WORD(base));
  entry->limitLow = LOW_WORD(limit);
  entry->granularity = LOW_HALF_BYTE(HIGH_WORD(limit));
  entry->granularity |= MASK_HIGH_HALF_BYTE(granularity);
  entry->access = access;
}

}  // namespace dokkan::kernel
