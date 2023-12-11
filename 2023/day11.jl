input = readlines(joinpath(@__DIR__, "data/input11"))
data = vcat([reshape([r for r in row], 1, length(input[1])) for row in input]...)
indices = Tuple.(findall(isequal('#'), data))
rows = Int[]
cols = Int[]
for i in size(data, 1):-1:1
    if all(isequal('.'), data[i, :])
        push!(rows, i)
    end
end
for j in size(data, 2):-1:1
    if all(isequal('.'), data[:, j])
        push!(cols, j)
    end
end
    
answer1 = 0
answer2 = 0
for a in 1:length(indices) - 1
    for b in a+1:length(indices)
        m1 = min(indices[a][1], indices[b][1])
        M1 = max(indices[a][1], indices[b][1])
        m2 = min(indices[a][2], indices[b][2])
        M2 = max(indices[a][2], indices[b][2])
        for i in m1+1:M1
            answer1 += (i in rows) ? 2 : 1
            answer2 += (i in rows) ? 1000000 : 1
        end
        for j in m2+1:M2
            answer1 += (j in cols) ? 2 : 1
            answer2 += (j in cols) ? 1000000 : 1
        end
    end
end

@show answer1
@show answer2
