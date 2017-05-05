A=randn(3,20,8,5,2)
a = [:a, :b, :h, :c, :d] 
B=randn(2,3,4,7)
b = [:d, :a, :e, :f]
C=randn(5,6,20,6,4)
c = [:c, :g, :b, :g, :e]

D1 = ncon([A, B, C], [a, b, c], [:f, :h], [:a, :d, :g, :b, :c, :e])

@tensor begin
    D2[f, h] := A[a,b,h,c,d]*B[d,a,e,f]*C[c,g,b,g,e]
end

@test vecnorm(D1-D2)<eps()*sqrt(length(D1))*vecnorm(D1+D2)

D3 = ncon([A, B, C],
          [[1, 2, 8, 3, 4],
           [4, 1, 5, 6],    
           [3, 7, 2, 7, 5]], 
          [6, 8],
          [1, 4, 7, 2, 3, 5])

@test D1 ≈ D3
