#include <cstddef>

void *operator new(std::size_t) throw() { return nullptr; }
void *operator new(std::size_t, void *) throw() { return nullptr; }

void operator delete(void *) {}
void operator delete(void *, void *) {}
void operator delete(void *, std::size_t) {}

void *operator new[](std::size_t) throw() { return nullptr; }
void *operator new[](std::size_t, void *) throw() { return nullptr; }

void operator delete[](void *) {}
void operator delete[](void *, void *) {}
void operator delete[](void *, std::size_t) {}
