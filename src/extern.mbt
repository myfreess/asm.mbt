///|
typealias MemPointer = UInt64

///|
priv extern type LibHandle

///|
typealias FnPointer = UInt64

///|
extern "c" fn mmap(length : UInt64) -> MemPointer = "__mmap"

///|
extern "c" fn dlopen() -> LibHandle = "__dlopen"

///|
extern "c" fn __dlsym(handle : LibHandle, symbol : Bytes) -> FnPointer = "dlsym"

///|
fn dlsym(handle : LibHandle, symbol : String) -> FnPointer {
  let buf = @buffer.new(size_hint=symbol.length() * 2)
  @encoding.encode_to(symbol, buf, encoding=UTF8)
  buf.write_byte(0x00)
  let symbol = buf.contents()
  __dlsym(handle, symbol)
}

///|
extern "c" fn __exec(start : UInt64, machcode : Bytes, len : UInt64) -> Int64 = "__exec"
