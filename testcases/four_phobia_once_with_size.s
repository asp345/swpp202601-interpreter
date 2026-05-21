; The memory access size is 4 here.
; 4-phobia should still be charged only once for the whole instruction.
start main 0:
.entry:
r1 = load 4 1600
call write r1
ret 0
end main
