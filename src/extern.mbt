typealias MemPointer = UInt64

priv extern type LibHandle

typealias FnPointer = UInt64

extern "c" fn mmap(length : UInt64, prot : Int, flags : Int) -> MemPointer = "moonbit_mmap"

extern "c" fn __dlopen(filename : Bytes, flags : Int) -> LibHandle = "dlopen"

fn dlopen(filename : String, flags : Int) -> LibHandle {
  let buf = @buffer.new(size_hint=filename.length() * 2)
  @encoding.encode_to(filename, buf, encoding = UTF8)
  buf.write_byte(0x00)
  let filename = buf.contents()
  __dlopen(filename, flags)
}

extern "c" fn __dlsym(handle : LibHandle, symbol : Bytes) -> FnPointer = "dlsym"

fn dlsym(handle : LibHandle, symbol : String) -> FnPointer {
  let buf = @buffer.new(size_hint=symbol.length() * 2)
  @encoding.encode_to(symbol, buf, encoding = UTF8)
  buf.write_byte(0x00)
  let symbol = buf.contents()
  __dlsym(handle, symbol)
}