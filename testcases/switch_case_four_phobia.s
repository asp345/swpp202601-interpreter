; A switch case constant of 4 should trigger 4-phobia even when the condition is not 4.
start main 0:
.entry:
br .switch
.default:
ret 0
.switch:
switch 0 4 .case .default
.case:
ret 0
end main
