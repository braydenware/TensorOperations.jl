using TensorOperations


A = rand(Complex128, fill(2, 8)...)
B = rand(Complex128, fill(2, 18)...)
C = zeros(Complex128, fill(2, 18)...)
@time TensorOperations.contract!(1, A, Val{:N}, B, Val{:N}, 0, C, [3,4,7,8],[1,2,5,6],
                                [2,3,4,5,6,8,9,10,11,12,13,15,16,18],[14,1,17,7],
                                [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18], Val{:BLAS})

A = rand(Complex128, fill(2, 8)...)
B = rand(Complex128, fill(2, 18)...)
C = zeros(Complex128, fill(2, 18)...)
@time TensorOperations.contract!(1, A, Val{:N}, B, Val{:N}, 0, C, [3,4,7,8],[1,2,5,6],
                                [2,3,4,5,6,8,9,10,11,12,13,15,16,18],[14,1,17,7],
                                [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18], Val{:BLAS})
