input = readlines(joinpath(@__DIR__, "data/input18"))
s = split.(input)
dirdict = Dict("R" => (1, 0), "U" => (0, -1), "L" => (-1, 0), "D" => (0, 1))
colordirdict = Dict('0' => (1, 0), '3' => (0, -1), '2' => (-1, 0), '1' => (0, 1))
dirs = [dirdict[dir] for dir in getindex.(s, 1)]
dists = parse.(Int, getindex.(s, 2))
colors = [parse(Int, string("0x", s[i][3][3:7])) for i in eachindex(s)]
colordirs = [colordirdict[s[i][3][8]] for i in eachindex(s)]

path = Tuple{Int, Int}[(0, 0)]
for (dir, dist) in zip(dirs, dists)
    push!(path, (last(path) .+ dist .* dir))
end
pop!(path)

path2 = Tuple{Int, Int}[(0, 0)]
for (dir, dist) in zip(colordirs, colors)
    push!(path2, (last(path2) .+ dist .* dir))
end
pop!(path2)

# This is a modification of the shoelace formula: https://en.wikipedia.org/wiki/Shoelace_formula
# The additional terms (pathlength/2 + 1) are because the path goes through the center of the surrounding trench, not the outer edge of the trench. The +1 in particular is because it is a loop, so you get 4 corners that don't cancel out, each of which contribute 1/4 of a unit.
shoelace_formula(path) = shoelace_formula(getindex.(path, 1), getindex.(path, 2))
function shoelace_formula(x::Vector{T}, y::Vector{T}) where T <: Real
    n = length(x)
    pathlength = sum(max(abs(x[i] - x[i == n ? 1 : i+1]), abs(y[i] - y[i == n ? 1 : i+1])) for i in 1:n)
    @assert n == length(y)
    abs(div(sum(x[i] * y[mod1(i + 1, n)] - x[mod1(i + 1, n)] * y[i] for i in 1:n), 2)) + div(pathlength, 2) + 1
end

answer1 = shoelace_formula(path)
answer2 = shoelace_formula(path2)

@show answer1
@show answer2
