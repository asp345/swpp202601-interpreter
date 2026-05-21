; Callee writes to its own r2, but that must not cancel the caller's
; unresolved aload debt for caller r2.
start main 0:
.entry:
r1 = malloc 8
r2 = aload 8 r1
call clobber
call write r2
ret 0
end main

start clobber 0:
.entry:
r2 = mul 2 3 64
ret 0
end clobber
