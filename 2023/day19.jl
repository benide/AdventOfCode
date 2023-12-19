input = readlines(joinpath(@__DIR__, "data/input19"))
temp = findfirst(isequal(""), input)
workflows = Dict{String, Vector{String}}(match(r"^[^{]+", s).match => split(match(r"{([^}]+)}", s).captures[1], ',') for s in input[1:temp-1])
parts = [(x = parse(Int, match(r"x=(\d+)", s).captures[1]),
          m = parse(Int, match(r"m=(\d+)", s).captures[1]),
          a = parse(Int, match(r"a=(\d+)", s).captures[1]),
          s = parse(Int, match(r"s=(\d+)", s).captures[1])) for s in input[temp+1:end]]

function test(part::NamedTuple{(:x, :m, :a, :s), NTuple{4, Int64}}, workflow::Vector{String})
    for i in 1:length(workflow) - 1
        val = part[Symbol(workflow[i][1])]
        t, c = split(workflow[i][3:end], ':')
        if workflow[i][2] == '<'
            if val < parse(Int, t)
                return c
            end
        elseif workflow[i][2] == '>'
            if val > parse(Int, t)
                return c
            end
        else
            @error "parse error"
        end
    end
    return last(workflow)
end

function test(part::NamedTuple{(:x, :m, :a, :s), NTuple{4, Int64}}, workflows::Dict{String, Vector{String}})
    curr = "in"
    while true
        curr = test(part, workflows[curr])
        curr == "A" && return true
        curr == "R" && return false
    end
end

indices = findall([test(p, workflows) for p in parts])
answer1 = sum(sum(parts[i]) for i in indices)


const cache = Vector{Pair{Symbol, UnitRange}}[]
function test!(part::Dict{Symbol, UnitRange} = Dict{Symbol, UnitRange}(:x => 1:4000, :m => 1:4000, :a => 1:4000, :s => 1:4000), workflow::AbstractString = "in")::Nothing
    curr = copy(part)
    for i in 1:length(workflows[workflow]) - 1
        letter = Symbol(workflows[workflow][i][1])
        t, c = split(workflows[workflow][i][3:end], ':')
        testval = parse(Int, t)
        if workflows[workflow][i][2] == '<'
            successful = copy(curr)
            successful[letter] = intersect(curr[letter], 1:testval-1)
            curr[letter] = intersect(curr[letter], testval:4000)
        elseif workflows[workflow][i][2] == '>'
            successful = copy(curr)
            successful[letter] = intersect(curr[letter], testval+1:4000)
            curr[letter] = intersect(curr[letter], 1:testval)
        else
            @error "parse error"
        end
        if !isempty(successful[letter]) && c != "R"
            if c == "A"
                push!(cache, collect(successful))
            else
                test!(successful, c)
            end
        end
        isempty(curr[letter]) && return nothing
    end
    if last(workflows[workflow]) == "A"
        push!(cache, collect(curr))
    elseif last(workflows[workflow]) != "R"
        test!(curr, last(workflows[workflow]))
    end
    return nothing
end

empty!(cache)
test!()
answer2 = sum(length(c[1][2]) * length(c[2][2]) * length(c[3][2]) * length(c[4][2]) for c in cache)

@show answer1
@show answer2
