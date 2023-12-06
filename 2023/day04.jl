input = readlines(joinpath(@__DIR__, "data/input04"))

nums = zeros(Int, length(input))
for (i, card) in enumerate(input)
    a, b = split(card[11:end], "|")
    winning_numbers = parse.(Int, filter(!isempty, split(a, " ")))
    my_numbers = parse.(Int, filter(!isempty, split(b, " ")))
    nums[i] = length(intersect(winning_numbers, my_numbers))
end
answer1 = mapreduce(x -> 2^(x - 1), +, filter(!iszero, nums))

num_of_cards = ones(Int, length(input))
for i in eachindex(input)
    for j in intersect(i + 1:length(input), i + 1:i + nums[i])
        num_of_cards[j] += num_of_cards[i]
    end
end
answer2 = sum(num_of_cards)

@show answer1
@show answer2
