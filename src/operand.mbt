enum Operand {
  I(Int64)
  R(Reg)
  A(UInt) // Relative Address
}

let rax : Operand = R(RAX)
let rsi : Operand = R(RSI)