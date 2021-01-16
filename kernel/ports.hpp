#ifndef PORTS_H
#define PORTS_H

#include "kernel/types.hpp"

namespace dokkan::kernel {

byte_t port_byte_in(word_t port);

void port_byte_out(word_t port, byte_t data);

word_t port_word_in(word_t port);

void port_word_out(word_t port, word_t data);

} // namespace dokkan::kernel

#endif
