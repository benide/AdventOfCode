input = readlines(joinpath(@__DIR__, "data/input01"))

function f(s)
    parse(Int, s[findfirst(c in '0':'9' for c in s)] * s[findlast(c in '0':'9' for c in s)])
end

function g(s)
    numstrings = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
    matches = collect(eachmatch(Regex("[0-9]|" * join(numstrings, "|")), s, overlap = true))
    offsets = getproperty.(matches, :offset)
    i = findmin(offsets)[2]
    j = findmax(offsets)[2]
    first = if matches[i].match in numstrings
        findfirst(num == matches[i].match for num in numstrings) - 1
    else
        parse(Int, matches[i].match)
    end
    last = if matches[j].match in numstrings
        findfirst(num == matches[j].match for num in numstrings) - 1
    else
        parse(Int, matches[j].match)
    end
    return first * 10 + last
end

answer1 = sum(f.(input))
answer2 = sum(g.(input))
