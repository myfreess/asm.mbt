///|
pub fn alloc(mem_size~ : UInt64 = 256UL * 1024UL) -> UInt64 {
  mmap(mem_size)
}
