#ifndef LIBC_STRING_H
#define LIBC_STRING_H

#include <stddef.h>

extern "C" {
void* memcpy(void* dst, const void* src, size_t num);
void* memmove(void* dst, const void* src, size_t num);
void* memset(void* dst, int val, size_t num);

int memcmp(const void* lhs, const void* rhs, size_t num);
int strcmp(const char* lhs, const char* rhs);

size_t strlen(const char* str);
}

#endif
