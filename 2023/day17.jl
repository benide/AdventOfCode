input = readlines(joinpath(@__DIR__, "data/input17"))
data = vcat([reshape([parse(Int, r) for r in row], 1, length(input[1])) for row in input]...)

using Pkg; Pkg.activate(joinpath(@__DIR__, ".."))
using Graphs, SimpleWeightedGraphs

function heatloss(data, min_step, max_step)
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
    d1 = dijkstra_shortest_paths(G, indices[1, 1, 1])
    d2 = dijkstra_shortest_paths(G, indices[1, 1, 2])
    p11 = enumerate_paths(d1, indices[end, end, 1])
    p12 = enumerate_paths(d1, indices[end, end, 2])
    p21 = enumerate_paths(d2, indices[end, end, 1])
    p22 = enumerate_paths(d2, indices[end, end, 2])
    s11 = sum(get_weight(G, p11[i], p11[i + 1]) for i in 1:length(p11) - 1)
    s12 = sum(get_weight(G, p12[i], p12[i + 1]) for i in 1:length(p12) - 1)
    s21 = sum(get_weight(G, p21[i], p21[i + 1]) for i in 1:length(p21) - 1)
    s22 = sum(get_weight(G, p22[i], p22[i + 1]) for i in 1:length(p22) - 1)
    return min(s11, s12, s21, s22)
end

answer1 = heatloss(data, 1, 3)
answer2 = heatloss(data, 4, 10)

@show answer1
@show answer2
