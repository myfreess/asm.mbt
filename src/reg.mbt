///|
enum Reg {
  RAX // 累积器
  RCX // 计数器 (循环计数器)
  RDX // 数据
  RBX // 基础，通用
  RSP // 当前栈指针
  RBP // Previous Stack Frame Link
  RSI // Source Index Pointer
  RDI // Destination Index Pointer
} derive(Show)

///|
fn index(self : Reg) -> Byte {
  match self {
    RAX => 0
    RCX => 1
    RDX => 2
    RBX => 3
    RSP => 4
    RBP => 5
    RSI => 6
    RDI => 7
  }
}
