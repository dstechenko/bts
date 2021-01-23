#include <stddef.h>

void *operator new(size_t) throw() { return nullptr; }
void *operator new(size_t, void *) throw() { return nullptr; }

void operator delete(void *) {}
void operator delete(void *, void *){};
void operator delete(void *, size_t){};

void *operator new[](size_t) throw() { return nullptr; }
void *operator new[](size_t, void *) throw() { return nullptr; }

void operator delete[](void *) {}
void operator delete[](void *, void *){};
void operator delete[](void *, size_t) {}
