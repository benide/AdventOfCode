input = readline(joinpath(@__DIR__, "data/input03"))

function visits(path)
    visited = [(0,0)]
    for c in path
        c == '^' && push!(visited, last(visited) .+ (0, 1))
        c == 'v' && push!(visited, last(visited) .+ (0, -1))
        c == '<' && push!(visited, last(visited) .+ (-1, 0))
        c == '>' && push!(visited, last(visited) .+ (1, 0))
    end
    return unique(visited)
end

answer1 = length(visits(input))
answer2 = length(union(visits(input[1:2:end]), visits(input[2:2:end])))

@show answer1
@show answer2
