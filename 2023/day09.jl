input = readlines(joinpath(@__DIR__, "data/input09"))
data = [parse.(Int, split(line, " ")) for line in input]

function find_next_digit(data::Vector{Int})
    next_digit = last(data)
    current = copy(data)
    while !iszero(current)
        diffs = [current[i + 1] - current[i] for i in 1:length(current) - 1]
        next_digit += last(diffs)
        current = diffs
    end
    return next_digit
end

answer1 = sum(find_next_digit.(data))

function find_prev_digit(data::Vector{Int})
    prev_digit = first(data)
    current = copy(data)
    i = 1
    while !(iszero(current))
        diffs = [current[i + 1] - current[i] for i in 1:length(current) - 1]
        prev_digit += first(diffs) * (-1)^i
        current = diffs
        i += 1
    end
    return prev_digit
end

answer2 = sum(find_prev_digit.(data))

@show answer1
@show answer2
