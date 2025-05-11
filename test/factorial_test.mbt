fn factorial(ctx : @asm.ASMContext, n : Int) -> Unit {
  ctx.mov(@asm.rcx, I(n))
  ctx.mov(@asm.rax, I(1))
  let l1 = ctx.label()
  ctx.mul(@asm.rcx)
  ctx._loop(l1)
  ctx.ret()
}

test {
  let start = @asm.alloc()
  let ctx = @asm.ASMContext::new(start~)
  factorial(ctx, 5)
  assert_eq(ctx.exec(), 120)
}