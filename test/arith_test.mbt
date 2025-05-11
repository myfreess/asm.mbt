test {
  let start = @asm.alloc()
  let ctx = @asm.ASMContext::new(start~)
  ctx.mov(@asm.rax, I(18))
  ctx.add(@asm.rax, I(4))
  ctx.sub(@asm.rax, I(2))
  ctx.imul(@asm.rax, I(3))
  ctx.ret()
  assert_eq(ctx.exec(), 60)
}