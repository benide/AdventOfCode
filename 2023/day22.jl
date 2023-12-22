input = readlines(joinpath(@__DIR__, "data/input22"))
parsed = sort([sort([parse.(Int, split(s, ',')) for s in split(i, '~')],
                    lt = (x, y) -> x[3] == y[3] ? (x[2] == y[2] ? x[1] <= y[1] : x[2] < y[2]) : x[3] < y[3]) for i in input],
              lt = (x, y) -> x[1][3] == y[1][3] ? (x[1][2] == y[1][2] ? x[1][1] <= y[1][1] : x[1][2] < y[1][2]) : x[1][3] < y[1][3]) |> reverse
bricks = [(b[1][1]:b[2][1], b[1][2]:b[2][2], b[1][3]:b[2][3]) for b in parsed]

using Pkg
Pkg.activate("..")
using Graphs

g = SimpleDiGraph(length(bricks))

for i in length(bricks):-1:1
    indices = findall(!isempty(intersect(bricks[i][1], b[1]))
                      && !isempty(intersect(bricks[i][2], b[2]))
                      for b in bricks[i + 1:end]) .+ i
    if isempty(indices)
        bricks[i] = (bricks[i][1], bricks[i][2], range(1, length = length(bricks[i][3])))
        continue
    end
    m = [maximum(bricks[j][3]) for j in indices]
    z = maximum(m)
    bricks[i] = (bricks[i][1], bricks[i][2], range(z + 1, length = length(bricks[i][3])))
    for j in findall(isequal(z), m)
        add_edge!(g, i, indices[j])
    end
end

answer1 = 0
for i in eachindex(bricks)
    all(length(outneighbors(g, j)) > 1 for j in inneighbors(g, i)) && (global answer1 += 1;)
end

function countfalls(_g, v)
    g = deepcopy(_g)
    parents = findall(!iszero, bfs_parents(g, v, dir = :in))
    deleteat!(parents, findfirst(isequal(v), parents))
    rem_vertex!(g, v)
    n = 0
    for w in parents
        isempty(setdiff(findall(!iszero, bfs_parents(g, w, dir = :out)), parents)) && (n += 1;)
    end
    n
end

answer2 = sum(countfalls(g, v) for v in vertices(g))

@show answer1
@show answer2
