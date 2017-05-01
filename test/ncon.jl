A=randn(3,20,8,5,2)
a = [:a, :b, :h, :c, :d] 
B=randn(2,3,4,7)
b = [:d, :a, :e, :f]
C=randn(5,6,20,6,4)
c = [:c, :g, :b, :g, :e]

D1 = ncon([A, B, C], [a, b, c], [:f, :h], [:a, :d, :g, :b, :c, :e])

@tensor begin
    D2["fh"] := A["abhcd"]*B["daef"]*C["cgbge"]
end

@test vecnorm(D1-D2)<eps()*sqrt(length(D1))*vecnorm(D1+D2)
