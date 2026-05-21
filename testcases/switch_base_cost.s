; Switch should use forward-jump scaling like br.
start main 0:
.entry:
switch 0 1 .case .default
.case:
ret 0
.default:
ret 0
end main
