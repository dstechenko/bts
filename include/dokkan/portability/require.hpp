#ifndef DOKKAN_PORTABILITY_REQUIRE_H
#define DOKKAN_PORTABILITY_REQUIRE_H

#if defined(__linux__)
#error "This kernel needs to be compiler with a cross compiler"
#endif

#if !defined(__i386__)
#error "This kernel needs to be compiled with a ix86-elf compiler"
#endif

#endif
