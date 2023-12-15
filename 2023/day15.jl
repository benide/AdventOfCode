input = readlines(joinpath(@__DIR__, "data/input15"))[1]
data = String.(split(input, ","))

function h(s::AbstractString)
    v = 0
    for c in s
        v = mod((v + Int(c)) * 17, 256)
    end
    return v
end

answer1 = sum(h.(data))

labels = [match(r"[a-zA-Z]++", s).match for s in data]
hashes = h.(labels)
operation = Int[('=' in s) ? parse(Int, match(r"[0-9]++", s).match) : -1 for s in data]
boxes = [Tuple{AbstractString, Int}[] for i in 0:255] # (lens index, focal length)
for i in eachindex(labels)
    if operation[i] < 0
        deleteat!(boxes[hashes[i] + 1], findall(b -> b[1] == labels[i], boxes[hashes[i] + 1]))
    else
        j = findfirst(b -> b[1] == labels[i], boxes[hashes[i] + 1])
        if isnothing(j)
            push!(boxes[hashes[i] + 1], (labels[i], operation[i]))
        else
            boxes[hashes[i] + 1][j] = (labels[i], operation[i])
        end
    end
end

answer2 = sum(i * sum([j * l for (j, (_, l)) in enumerate(box)]) for (i, box) in enumerate(boxes))

@show answer1
@show answer2
