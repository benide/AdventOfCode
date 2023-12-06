input = readlines(joinpath(@__DIR__, "data/input06"))

time = parse.(Int, split(input[1], r"\s+")[2:end])
dist = parse.(Int, split(input[2], r"\s+")[2:end])
answer1 = prod(length(filter(x -> x > 0, (1:time[i]) .* (time[i] .- (1:time[i])) .- dist[i])) for i in eachindex(time))

time2 = parse(Int, filter(isdigit, input[1]))
dist2 = parse(Int, filter(isdigit, input[2]))
i = round(Int, (time2 + sqrt(time2^2 - 4dist2)) / 2)
j = round(Int, (time2 - sqrt(time2^2 - 4dist2)) / 2)
i, j = sort([i, j])
answer2 = length(i:j)

@show answer1
@show answer2
