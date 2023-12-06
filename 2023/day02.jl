input = readlines(joinpath(@__DIR__, "data/input02"))
answer1 = answer2 = 0
f(game, color) = maximum(parse.(Int, getindex.(getproperty.(eachmatch(Regex("([0-9]+) " * color), game), :captures), 1)))
for (i, game) in enumerate(input)
    r = f(game, "red"); g = f(game, "green"); b = f(game, "blue");
    r <= 12 && g <= 13 && b <= 14 && (global answer1 += i;)
    global answer2 += r * g * b
end

@show answer1
@show answer2
