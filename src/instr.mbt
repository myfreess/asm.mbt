///|
enum Instr {
  Ret
  Mov(Operand, Operand)
  Add(Operand, Operand)
  Sub(Operand, Operand)
  Mul(Operand)
  IMul(Operand, Operand)
  Xor(Operand, Operand)
  Inc(Operand)
  Dec(Operand)
  Push(Operand)
  Pop(Operand)
  Call(Operand)
  Loop(Operand)
  Nop
  Syscall
}
