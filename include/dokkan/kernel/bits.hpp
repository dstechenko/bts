#ifndef DOKKAN_KERNEL_BITS_H
#define DOKKAN_KERNEL_BITS_H

#include <stdint.h>

#define MASK_LOW_HALF_BYTE(byte) (byte & 0x0F)
#define MASK_HIGH_HALF_BYTE(byte) (byte & 0xF0)

#define MASK_LOW_BYTE(word) (word & 0x00FF)
#define MASK_HIGH_BYTE(word) (word & 0xFF00)

#define MASK_LOW_WORD(dword) (dword & 0x0000FFFF)
#define MASK_HIGH_WORD(dword) (dword & 0xFFFF0000)

#define LOW_HALF_BYTE(byte) (static_cast<uint8_t>(MASK_LOW_HALF_BYTE(byte)))
#define HIGH_HALF_BYTE(byte) (LOW_HALF_BYTE(byte >> 4))

#define LOW_BYTE(word) (static_cast<uint8_t>(MASK_LOW_BYTE(word)))
#define HIGH_BYTE(word) (LOW_BYTE(word >> 8))

#define LOW_WORD(dword) (static_cast<uint16_t>(MASK_LOW_WORD(dword)))
#define HIGH_WORD(dword) (LOW_WORD(dword >> 16))

#endif
