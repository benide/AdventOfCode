input = readlines(joinpath(@__DIR__, "data/input12"))

function parseline(line, num_copies)
    a, b = split(line)
    return join(fill(a, num_copies), '?'), repeat(parse.(Int, split(b, ',')), num_copies)
end

data1 = parseline.(input, 1)
data2 = parseline.(input, 5)

const cache = Dict{Tuple{Vector{String}, Vector{Int}}, Int}()

function f(line::Tuple{String, Vector{Int}})
    blocks = string.(getproperty.(collect(eachmatch(r"[#?]++", line[1])), :match))
    f(blocks, line[2])
end

function f(blocks::Vector{String}, nums::Vector{Int})
    get!(cache, (blocks, nums)) do
        if isempty(nums)
            any('#' in b for b in blocks) ? 0 : 1
        elseif sum(nums) > sum(length.(blocks))
            0
        elseif nums[1] > length(blocks[1])
            '#' in blocks[1] ? 0 : f(blocks[2:end], nums)
        elseif '?' in blocks[1]
            b = blocks[1]
            i = findfirst(==('?'), b)
            test1 = filter!(!isempty, [b[1:i-1]; b[i+1:end]; blocks[2:end]])
            test2 = filter!(!isempty, [b[1:i-1] * "#" * b[i+1:end]; blocks[2:end]])
            f(test1, nums) + f(test2, nums)
        else
            length(blocks[1]) == nums[1] ? f(blocks[2:end], nums[2:end]) : 0
        end
    end
end

answer1 = sum(f.(data1))
answer2 = sum(f.(data2))

@show answer1
@show answer2
