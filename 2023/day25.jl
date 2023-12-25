input = readlines(joinpath(@__DIR__, "data/input25"))
names = unique(String.(vcat([[a; split(b, " ")] for (a, b) in split.(input, ": ")]...)))

using Graphs
g = SimpleGraph(length(names))
for s in input
    a, bs = split(s, ": ")
    for b in split(bs, " ")
        add_edge!(g, findfirst(isequal(a), names), findfirst(isequal(b), names))
    end
end

a = karger_min_cut(g)
while karger_cut_cost(g, a) > 3
    a = karger_min_cut(g)
end

answer = count(isequal(1), a) * count(isequal(2), a)

@show answer
