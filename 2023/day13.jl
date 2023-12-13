input = readlines(joinpath(@__DIR__, "data/input13"))
i = findall(isequal(""), input)
data = Matrix{Char}[]
for j in 1:length(i)
    if j == 1
        push!(data, vcat([reshape([r for r in row], 1, length(input[1])) for row in input[1:i[1] - 1]]...))
    elseif j == length(i)
        push!(data, vcat([reshape([r for r in row], 1, length(input[i[j]+1])) for row in input[i[j]+1:end]]...))
    end
    if j != length(i)
        push!(data, vcat([reshape([r for r in row], 1, length(input[i[j]+1])) for row in input[i[j]+1:i[j+1]-1]]...))
    end
end

answer1 = 0
for d in data
    r = 0
    for i in axes(d, 1)
        if i != 1
            n = min(size(d, 1) - i + 1, i - 1)
            if d[i-1:-1:i-n, :] == d[i:i+n-1, :]
                r = i-1
                break
            end
        end
    end
    if r > 0
        answer1 += 100r
    else
        for j in axes(d, 2)
            if j != 1
                n = min(size(d, 2) - j + 1, j - 1)
                if d[:, j-1:-1:j-n] == d[:, j:j+n-1]
                    r = j-1
                    break
                end
            end
        end
        answer1 += r
    end
end

answer2 = 0
for d in data
    r = 0
    for i in axes(d, 1)
        if i != 1
            n = min(size(d, 1) - i + 1, i - 1)
            if count(d[i-1:-1:i-n, :] .!= d[i:i+n-1, :]) == 1
                r = i-1
                break
            end
        end
    end
    if r > 0
        answer2 += 100r
    else
        for j in axes(d, 2)
            if j != 1
                n = min(size(d, 2) - j + 1, j - 1)
                if count(d[:, j-1:-1:j-n, :] .!= d[:, j:j+n-1, :]) == 1
                    r = j-1
                    break
                end
            end
        end
        answer2 += r
    end
end

@show answer1
@show answer2
