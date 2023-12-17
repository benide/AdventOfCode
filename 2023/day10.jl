input = readlines(joinpath(@__DIR__, "data/input10"))
data = stack(input, dims = 1)

function find_connections(i, j, data)
    connections = Tuple{Int, Int}[]
    if data[i, j] == 'S'
        i != 1 && data[i - 1, j] in "|7F" && push!(connections, (i - 1, j))
        i != size(data, 1) && data[i + 1, j] in "|JL" && push!(connections, (i + 1, j))
        j != 1 && data[i, j - 1] in "-FL" && push!(connections, (i, j - 1))
        j != size(data, 2) && data[i, j + 1] in "-7J" && push!(connections, (i, j + 1))
    elseif data[i, j] == '-'
        j != 1 && data[i, j - 1] in "-FL" && push!(connections, (i, j - 1))
        j != size(data, 2) && data[i, j + 1] in "-7J" && push!(connections, (i, j + 1))
    elseif data[i, j] == '|'
        i != 1 && data[i - 1, j] in "|7F" && push!(connections, (i - 1, j))
        i != size(data, 1) && data[i + 1, j] in "|JL" && push!(connections, (i + 1, j))
    elseif data[i, j] == 'J'
        i != 1 && data[i - 1, j] in "|7F" && push!(connections, (i - 1, j))
        j != 1 && data[i, j - 1] in "-FL" && push!(connections, (i, j - 1))
    elseif data[i, j] == 'F'
        i != size(data, 1) && data[i + 1, j] in "|JL" && push!(connections, (i + 1, j))
        j != size(data, 2) && data[i, j + 1] in "-7J" && push!(connections, (i, j + 1))
    elseif data[i, j] == 'L'
        i != 1 && data[i - 1, j] in "|7F" && push!(connections, (i - 1, j))
        j != size(data, 2) && data[i, j + 1] in "-7J" && push!(connections, (i, j + 1))
    elseif data[i, j] == '7'
        i != size(data, 1) && data[i + 1, j] in "|JL" && push!(connections, (i + 1, j))
        j != 1 && data[i, j - 1] in "-FL" && push!(connections, (i, j - 1))
    end
    return connections
end

function find_path(i, j, data)
    path = [(i, j)]
    c = find_connections(i, j, data)
    while c ⊈ path && !isempty(c)
        push!(path, first(setdiff(c, path)))
        c = find_connections(last(path)..., data)
    end
    return path
end

function is_point_in_path(p, path)
    m1 = maximum(getindex.(path, 1))
    m2 = maximum(getindex.(path, 2))
    if p in path || p[1] ∉ 1:m1 || p[2] ∉ 1:m2
        return false
    else
        q = p .+ (1, 0)
        while q[1] <= m1 && q ∉ path
            q = q .+ (1, 0)
        end
        if q[1] > m1
            return false
        else
            curr = findfirst(isequal(q), path)
            next = mod1(curr + 1, length(path))
            prev = mod1(curr - 1, length(path))
            d = path[next][2] - path[prev][2]
            return d > 0
        end
    end
end

i, j = Tuple(findfirst(isequal('S'), data))
path = find_path(i, j, data)

answer1 = div(length(path), 2)
answer2 = count(p -> is_point_in_path(Tuple(p), path), eachindex(IndexCartesian(), data))

@show answer1
@show answer2
