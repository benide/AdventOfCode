input = readlines(joinpath(@__DIR__, "data/input12"))

function bigline(line)
    a, b = split(line)
    return string(a, "?", a, "?", a, "?", a, "?", a, " ", b, ",", b, ",", b, ",", b, ",", b)
end
biginput = [bigline(line) for line in input]

function check(line)
    length.(getproperty.(collect(eachmatch(r"#++", line)), :match)) == parse.(Int, split(split(line, ' ')[2], ','))
end

include("GrayCode.jl") # old code, repurposed
function f(line)
    qs = count(isequal('?'), line)
    indices = findall(isequal('?'), line)
    hs = count(isequal('#'), line)
    nums = parse.(Int, split(split(line, ' ')[2], ','))
    total = sum(nums)
    strs = filter(isempty, split(split(line)[1], '.'))

    n = 0
    str = [c for c in line]
    for gray in GrayCode(qs, total - hs, mutate = true)
        for (i, g) in zip(indices, gray)
            str[i] = iszero(g) ? '.' : '#'
        end
        check(string(str...)) && (n += 1;)
    end
    print(".")
    return n
end

answer1 = sum(f.(input))
# answer2 = sum(f.(biginput)) # there is no way this would ever finish

# no idea what I'm doing below here...

function g(line)
    a, b = split(line)
    c = string.(getproperty.(collect(eachmatch(r"[#?]++", line)), :match))
    d = parse.(Int, split(b, ','))
    return c, d
end

function f2(line)
    strs, nums = g(line)
    extra = length(nums) - length(strs)
    lens = length.(strs)
    n = 0
    return findfirst(sum(nums[1:i]) + i - 1 > length(strs[1]) for i in eachindex(nums)) - 1
    # for s in strs

    # end
    # return n
end

asnwer2 = sum(f2.(biginput))
