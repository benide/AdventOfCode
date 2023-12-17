input = readlines(joinpath(@__DIR__, "data/input17"))
data = parse.(Int, stack(input, dims = 1))

using Pkg; Pkg.activate(joinpath(@__DIR__, ".."))
using Graphs, SimpleWeightedGraphs

min_step = 1
max_step = 3

function heatloss(data::Matrix{Int}, min_step::Int, max_step::Int)
    G = SimpleWeightedDiGraph(Int, Int)
    n = length(data)
    add_vertices!(G, 2n)
    indices = reshape(1:2n, size(data)..., 2)
    for j in axes(data, 2)
        for i in axes(data, 1)
            for i2 in i + min_step:min(i + max_step, size(data, 1))
                add_edge!(G, indices[i, j, 1], indices[i2, j, 2], sum(data[i + 1:i2, j]))
            end
            for i2 in i - min_step:-1:max(1, i - max_step)
                add_edge!(G, indices[i, j, 1], indices[i2, j, 2], sum(data[i2:i - 1, j]))
            end
            for j2 in j + min_step:min(j + max_step, size(data, 2))
                add_edge!(G, indices[i, j, 2], indices[i, j2, 1], sum(data[i, j + 1:j2]))
            end
            for j2 in j - min_step:-1:max(1, j - max_step)
                add_edge!(G, indices[i, j, 2], indices[i, j2, 1], sum(data[i, j2:j - 1]))
            end
        end
    end
    d = dijkstra_shortest_paths(G, indices[1, 1, 1:2])
    p = enumerate_paths(d, indices[end, end, 1:2])
    return minimum(sum(get_weight(G, p[i], p[i + 1]) for i in 1:length(p) - 1) for p in p)
end

answer1 = heatloss(data, 1, 3)
answer2 = heatloss(data, 4, 10)

@show answer1
@show answer2
