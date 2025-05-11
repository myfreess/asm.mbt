///|
struct ASMContext {
  instrs : Array[Instr] // for debug
  code : @buffer.T
  mem_ptr : UInt64
  mut mem_offset : Int
}

///|
pub fn ASMContext::new(start~ : UInt64) -> ASMContext {
  ASMContext::{
    instrs: [],
    code: @buffer.new(size_hint=25),
    mem_ptr: start,
    mem_offset: 0,
  }
}

///|
pub fn ASMContext::label(self : ASMContext) -> Operand {
  A(self.mem_offset)
}

///|
pub fn ASMContext::extern_fn(self : ASMContext, name : String) -> Operand {
  let handle = dlopen()
  let fn_pointer = dlsym(handle, name)
  let rel = 
    if fn_pointer > self.mem_ptr {
      (fn_pointer - self.mem_ptr).to_int()
    } else {
      -((self.mem_ptr - fn_pointer).to_int())
    }
  A(rel)
}

///|
fn ASMContext::emit_byte(self : ASMContext, i : Byte) -> Unit {
  self.code.write_byte(i)
  self.mem_offset += 1
}

///|
fn ASMContext::emit_imm32(self : ASMContext, i : Int) -> Unit {
  self.code.write_int_le(i)
  self.mem_offset += 4
}

///|
pub fn ASMContext::exec(self : ASMContext) -> Int64 {
  let machcode = self.code.contents()
  __exec(self.mem_ptr, machcode, machcode.length().to_uint64())
}

pub fn nop(self : ASMContext) -> Unit {
  self.instrs.push(Nop)
  self.emit_byte(0x90)
}

///|
pub fn ret(self : ASMContext) -> Unit {
  self.instrs.push(Ret)
  self.emit_byte(0xC3)
}

///|
pub fn add(self : ASMContext, lhs : Operand, rhs : Operand) -> Unit {
  self.instrs.push(Add(lhs, rhs))
  match (lhs, rhs) {
    (R(RAX), I(r)) => {
      self.emit_byte(0x48) // REX.W prefix
      self.emit_byte(0x05)
      self.emit_imm32(r)
    }
    (R(l), R(r)) => {
      self.emit_byte(0x48)
      self.emit_byte(0x01)
      self.emit_byte((0xC0 : Byte) | (index(r) << 3) | index(l))
    }
    _ => abort("add: nodef for lhs = \{lhs} rhs = \{rhs}")
  }
}

///|
pub fn sub(self : ASMContext, lhs : Operand, rhs : Operand) -> Unit {
  self.instrs.push(Sub(lhs, rhs))
  match (lhs, rhs) {
    (R(RAX), I(rhs)) => {
      self.emit_byte(0x48)
      self.emit_byte(0x2D)
      self.emit_imm32(rhs)
    }
    (R(l), R(r)) => {
      self.emit_byte(0x48)
      self.emit_byte(0x29)
      self.emit_byte((0xC0 : Byte) | (index(r) << 3) | index(l))
    }
    _ => abort("sub: nodef for lhs = \{lhs} rhs = \{rhs}")
  }
}

pub fn mul(self : ASMContext, operand : Operand) -> Unit {
  self.instrs.push(Mul(operand))
  match operand {
    R(l) => {
      self.emit_byte(0x48)
      self.emit_byte(0xF7)
      self.emit_byte((0xE0 : Byte) | index(l))
    }
    _ => abort("mul: nodef for \{operand}")
  }
}


pub fn _loop(self : ASMContext, operand : Operand) -> Unit {
  self.instrs.push(Loop(operand))
  match operand {
    A(dst) => {
      self.emit_byte(0xE2)
      let src = self.mem_offset
      let rel = dst - src
      // TODO: Use Int8 instead
      let sign = (((rel & 0x8000_0000) >> 24) | 0x0000_7FFF).to_byte()
      self.emit_byte(sign & rel.to_byte())
    }
    _ => abort("loop: nodef for \{operand}")
  }
}

///|
pub fn imul(self : ASMContext, lhs : Operand, rhs : Operand) -> Unit {
  self.instrs.push(IMul(lhs, rhs))
  match (lhs, rhs) {
    (R(l), I(r)) => {
      self.emit_byte(0x48)
      self.emit_byte(0x69)
      self.emit_byte((0xC0 : Byte) | index(l))
      self.emit_imm32(r)
    }
    (R(l), R(r)) => {
      self.emit_byte(0x48)
      self.emit_byte(0x69)
      self.emit_byte(0xAF)
      self.emit_byte((0xC0 : Byte) | (index(r) << 3) | index(l))
    }
    _ => abort("imul: nodef for lhs = \{lhs} rhs = \{rhs}")
  }
}

///|
pub fn mov(self : ASMContext, lhs : Operand, rhs : Operand) -> Unit {
  self.instrs.push(Mov(lhs, rhs))
  match (lhs, rhs) {
    (R(dst), R(src)) => {
      self.emit_byte(0x48)
      self.emit_byte(0x89)
      self.emit_byte((0xC0 : Byte) | (index(src) << 3) | index(dst))
    }
    (R(dst), I(src)) => {
      self.emit_byte(0x48)
      self.emit_byte(0xC7)
      self.emit_byte((0xC0 : Byte) | (index(dst) & 0x07))
      self.emit_imm32(src)
    }
    _ => abort("mov: nodef for lhs = \{lhs} rhs = \{rhs}")
  }
}

///|
pub fn push(self : ASMContext, operand : Operand) -> Unit {
  self.instrs.push(Push(operand))
  match operand {
    R(reg) => self.emit_byte((0x50 : Byte) + index(reg))
    _ => abort("push: nodef for operand = \{operand}")
  }
}

///|
pub fn call(self : ASMContext, operand : Operand) -> Unit {
  self.instrs.push(Call(operand))
  match operand {
    A(dst) => {
      self.emit_byte(0xE8)
      let src = self.mem_offset
      self.emit_imm32((dst - (src + 5)))
    }
    _ => abort("call: nodef for operand = \{operand}")
  }
}
