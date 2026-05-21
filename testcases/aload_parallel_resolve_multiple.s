; Multiple outstanding async-load debts should all age by each intervening
; instruction's elapsed cost.
start main 0:
.entry:
r1 = aload 1 1600
r2 = aload 1 1601
r3 = eadd 2 2 64
call write r2
ret 0
end main
