input = readlines(joinpath(@__DIR__, "data/input05"))

answer1 = 0
for s in input
    count(c in "aeiou" for c in s) > 2 || continue
    any(s[i] == s[i + 1] for i in 1:length(s) - 1) || continue
    any(occursin(sub, s) for sub in ["ab", "cd", "pq", "xy"]) && continue
    global answer1 += 1
end

answer2 = 0
for s in input
    any(occursin(s[i:i + 1], s[i + 2:end]) for i in 1:length(s) - 2) || continue
    any(s[i] == s[i + 2] for i in 1:length(s) - 2) || continue
    global answer2 += 1
end

@show answer1
@show answer2
