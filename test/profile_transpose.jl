using TensorOperations

# function explicit_transpose!(A, B, perm)
#    for (j, ind) in enumerate(eachindex(Base.LinearSlow(), A))
#        @inbounds B[ind.I[perm]...] = A[j]
#    end
# end

# using Plots
# e1 = Float64[]
# e2 = Float64[]
# e3 = Float64[]
# e4 = Float64[]
# e5 = Float64[]
# e6 = Float64[]
# Ls = collect(1:17)

# for L in Ls
#     B = rand(Complex128, fill(2, L)...)
#     C = rand(Complex128, fill(2, L)...)
#     perm = randperm(L)
#     t1 = @elapsed TensorOperations.transpose!(B, Val{:N}, C, perm)
#     t2 = @elapsed TensorOperations.transpose!(B, Val{:N}, C, perm)
#     t3 = @elapsed explicit_transpose!(B, C, perm)
#     t4 = @elapsed explicit_transpose!(B, C, perm)
#     t5 = @elapsed permutedims!(C, B, perm)
#     t6 = @elapsed permutedims!(C, B, perm)
#     @printf "%2d %9.5f %9.5f %9.5f %9.5f %9.5f %9.5f \n" L t1 t2 t3 t4 t5 t6
#     if L!=Ls[1]
#         push!(e1, t1);push!(e2, t2);push!(e3, t3);push!(e4, t4);push!(e5, t5);push!(e6, t6);
#     end
# end

# p = plot(Ls[2:end], [e1, e2, e3, e4, e5, e6], xlabel="L", ylabel="Time", yscale=:log10, marker=:o, ls=:dash, 
#           label=["transpose!1" "transpose!2" "eachindexloop1" "eachindexloop2" "permutedims!1" "permutedims!2"])
# p.attr[:size] = (800, 800)
# gui()
# display(p)
# println("Hit enter to continue")
# readline()


B = rand(Complex128, fill(2, 18)...)
C = zeros(Complex128, fill(2, 18)...)
D = zeros(Complex128, fill(2, 18)...)
perm = [14,1,17,7,2,3,4,5,6,8,9,10,11,12,13,15,16,18]
@time TensorOperations.transpose!(B, Val{:N}, C, perm; block=false)
@time TensorOperations.transpose!(B, Val{:N}, C, perm; block=false)

@time TensorOperations.transpose!(B, Val{:N}, C, perm; block=true)
@time TensorOperations.transpose!(B, Val{:N}, C, perm; block=true)


# permblocks = [[14],[1],[17],[7],[2,3,4,5,6],[8,9,10,11,12,13],[15,16],[18]]
# reorderedblocks = [[1],[2,3,4,5,6],[7],[8,9,10,11,12,13],[14],[15,16],[17],[18]]
# blockperm = [2,5,4,6,1,7,3,8]
# @time begin
# B2 = reshape(B, [2, 2, 2, 2, 2^5, 2^6, 2^2, 2]...)
# C2 = reshape(C, [2, 2^5, 2, 2^6, 2, 2^2, 2, 2]...)
# TensorOperations.transpose!(B2, Val{:N}, C2, blockperm)
# end
# @time begin
# B2 = reshape(B, [2, 2, 2, 2, 2^5, 2^6, 2^2, 2]...)
# D2 = reshape(D, [2, 2^5, 2, 2^6, 2, 2^2, 2, 2]...)
# TensorOperations.transpose!(B2, Val{:N}, D2, blockperm)
# end
# println(C ≈ D)

# @time TensorOperations.transpose!(B, Val{:N}, C, [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18])
    # @time TensorOperations.transpose!(B, Val{:N}, C, [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18])