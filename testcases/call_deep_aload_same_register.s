; Exercise the same register name carrying frame-local aload debt through
; more than five active call frames. Each frame reuses r2 for its own aload.
start main 0:
.entry:
r2 = aload 8 103992
call f1
call write r2
ret 0
end main

start f1 0:
.entry:
r2 = aload 8 103992
call f2
call write r2
ret 0
end f1

start f2 0:
.entry:
r2 = aload 8 103992
call f3
call write r2
ret 0
end f2

start f3 0:
.entry:
r2 = aload 8 103992
call f4
call write r2
ret 0
end f3

start f4 0:
.entry:
r2 = aload 8 103992
call f5
call write r2
ret 0
end f4

start f5 0:
.entry:
r2 = aload 8 103992
call f6
call write r2
ret 0
end f5

start f6 0:
.entry:
r2 = aload 8 103992
call write r2
ret 0
end f6
