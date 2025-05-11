struct ASMContext {
  instrs : Array[Instr] // for debug
  code : @buffer.T
  mut count : UInt
  mem_ptr : UInt64
  mut mem_offset : UInt
}

fn ASMContext::new(start~ : UInt64) -> ASMContext {
  ASMContext::{
    instrs : [],
    code : @buffer.new(size_hint = 25),
    count : 0,
    mem_ptr : start,
    mem_offset : 0
  }
}

fn ASMContext::label(self : ASMContext) -> Operand {
  A(self.mem_offset)
}

fn ASMContext::emit_byte(self : ASMContext, i : Byte) -> Unit {
  self.code.write_byte(i)
  self.mem_offset += 1
}

fn ASMContext::emit_imm(self : ASMContext, i : Int64) -> Unit {
  self.code.write_int64_le(i)
  self.mem_offset += 8
}

fn ASMContext::emit_rel(self : ASMContext, i : UInt) -> Unit {
  self.code.write_uint_le(i)
  self.mem_offset += 4
}

fn add(self : ASMContext, lhs : Operand, rhs : Operand) -> Unit {
  match (lhs, rhs) {
    (R(l), I(r)) => {
      self.emit_byte(0x48)
      self.emit_byte(0x05)
    }
    _ => ...
  }
}