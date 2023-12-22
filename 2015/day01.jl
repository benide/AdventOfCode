input = readline(joinpath(@__DIR__, "data/input01"))

answer1 = count(isequal('('), input) - count(isequal(')'), input)
answer2 = findfirst(2count(isequal('('), input[1:i]) < i for i in 1:length(input))

@show answer1
@show answer2
