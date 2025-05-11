#include <dlfcn.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/mman.h>
#include <stdint.h>

void *__mmap(size_t length) {
    return mmap(NULL, length, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_ANON | MAP_PRIVATE, -1, 0);
}

void* __dlopen() {
    return dlopen(NULL, RTLD_LAZY | RTLD_GLOBAL);
}

int64_t __exec(u_int64_t start, const void* machcode, size_t length) {
    memcpy((void*)start, machcode, length);
    int64_t (* fn)(void) = (int64_t (*)(void))start;
    return fn();
}