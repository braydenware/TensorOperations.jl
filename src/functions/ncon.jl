immutable Network{T}
    tensors::Vector{T}
    links::Vector{Vector{Symbol}}
end

Base.length(N::Network) = length(N.tensors)

function Base.push!{T}(N::Network{T}, tensor::T, axes::Vector{Symbol})
    ndims(tensor)==length(axes) || throw(IndexError("Wrong number of axes labels for tensor of dimension $(ndims(tensor))"))
    push!(N.tensors, tensor)
    push!(N.links, axes)
end

function popat!(N::Network, ns::Int...)
    tensors = N.tensors[collect(ns)]
    links = N.links[collect(ns)]    
    deleteat!(N.tensors, ns)
    deleteat!(N.links, ns)
    return tensors, links
end

function Base.find(N::Network, edge::Symbol)
    ans = Int[]
    for (j, axes) in enumerate(N.links)
        for k in find(axes.==edge)
            push!(ans, j)
        end
    end
    return ans
end

function contract!(N::Network, n1::Int, n2::Int)
    ((t1, t2), (a1, a2)) = popat!(N, n1, n2)
    (t, a, ca) = tensorcontract(t1, a1, t2, a2)
    push!(N, t, a)
    return ca
end

function trace!(N::Network, n1::Int)
    ((t,),(a,)) = popat!(N, n1)
    (t, a, ta) = tensortrace(t, a)
    push!(N, t, a)
    return ta
end

# function outer!(N::Network, ns::Int...)
#     tas = popat!(N, ns...)
#     ta, data = outer(tas...)
#     push!(N, ta)
# end

"""`ncon(arrays, links, axes, sequence)`

Contracts a tensor network specified by arrays and links,
contracting internal edges in the order specified by sequence,
and with the resulting output tensor transposed to have its axes in the order 
specified by axes.

TODO: Use "nones in sequence" notation to specify outer products
TODO: Compute valid sequences from links
TODO: Estimate cost of contraction from links and array shapes
TODO: Compute fast contraction sequences from links and array shapes
TODO: Test set 
"""
function ncon(arrays, links, axes, sequence)
    network = Network(arrays, links)
    while length(sequence) > 0 || length(network) > 1
        if length(sequence) > 0
            edge = first(sequence)
            nodes = find(network, edge)
            length(nodes)==2 || throw(IndexError("Contracted edge $edge appears $(length(nodes))!=2 times in links"))
            n1, n2 = nodes
            if n1==n2
                traced_edges = trace!(network, n1)
                nt = length(traced_edges)
                isperm(indexin(traced_edges, sequence[1:nt])) || throw(IndexError("Must trace all traceable edges on tensor at once")) 
                splice!(sequence, 1:nt)
            else
                contracted_edges = contract!(network, n1, n2)
                nt = length(contracted_edges)
                isperm(indexin(contracted_edges, sequence[1:nt])) || throw(IndexError("Must contract all contractable edges between tensors at once")) 
                splice!(sequence, 1:nt)
            end
        else
            throw(IndexError("Contraction network disconnected"))
        end
    end
    ((t,), (a,)) = popat!(network, 1)
    (tout, aout) = tensorcopy(t, a, axes)
    return tout
end
