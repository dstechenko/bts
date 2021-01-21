#ifndef DOKKAN_KERNEL_BITS_H
#define DOKKAN_KERNEL_BITS_H

#include <cpu/types.hpp>

namespace dokkan::kernel {

#define LOW_HALF_BYTE(byte) (static_cast<uint8_t>(byte & 0x0F))
#define HIGH_HALF_BYTE(byte) (LOW_HALF_BYTE(byte >> 4))

#define LOW_BYTE(word) (static_cast<uint8_t>(word & 0xFF))
#define HIGH_BYTE(word) (LOW_BYTE(word >> 8))

#define LOW_WORD(dword) (static_cast<uint16_t>(dword & 0xFFFF))
#define HIGH_WORD(dword) (LOW_WORD(dword >> 16))

}  // namespace dokkan::kernel

#endif
