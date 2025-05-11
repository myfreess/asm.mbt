#include <dlfcn.h>
#include <unistd.h>
#include <sys/mman.h>
#include <stdint.h>

int get_rtld_lazy() {
    return RTLD_LAZY;
}

int get_rtld_global() {
    return RTLD_GLOBAL;
}

void *moonbit_mmap(size_t length, int prot, int flags) {
    return mmap(NULL, length, prot, flags, -1, 0);
}

int get_prot_none() {
    return PROT_NONE;
}

int get_prot_read() {
    return PROT_READ;
}

int get_prot_write() {
    return PROT_WRITE;
}

int get_prot_exec() {
    return PROT_EXEC;
}

int get_mmap_anon() {
    return MAP_ANON;
}

int get_mmap_type() {
    return MAP_TYPE;
}