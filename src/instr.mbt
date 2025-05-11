enum Instr {
  Ret
  Mov(Operand, Operand)
  Add(Operand, Operand)
  Sub(Operand, Operand)
  Mul(Operand)
  IMul(Operand, Operand)
  Xor(Operand, Operand)
  Inc(Operand, Operand)
  Dec(Operand, Operand)
  Push(Operand, Operand)
  Pop(Operand)
  Call(Operand)
  Loop(Operand)
  Nop
  Syscall
}