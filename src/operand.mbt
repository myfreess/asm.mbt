///|
pub(all) enum Operand {
  I(Int)
  R(Reg)
  A(Int) // Relative Address
} derive(Show)

///|
pub let rax : Operand = R(RAX)

///|
pub let rsi : Operand = R(RSI)

pub let rcx : Operand = R(RCX)

pub let rbp : Operand = R(RBP)

pub let rsp : Operand = R(RSP)

pub let rdi : Operand = R(RDI)

pub let rdx : Operand = R(RDX)

pub let rbx : Operand = R(RBX)