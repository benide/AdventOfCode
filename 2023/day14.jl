input = readlines(joinpath(@__DIR__, "data/input14"))
data = vcat([reshape([r for r in row], 1, length(input[1])) for row in input]...)

function tilt_north!(data)
    for j in axes(data, 2)
        a = findall(isequal('#'), data[:, j])
        pushfirst!(a, 0)
        push!(a, size(data, 2) + 1)
        for i in 2:length(a)
            m = a[i-1] + 1
            n = a[i] - 1
            c = count(isequal('O'), data[m:n, j])
            data[m:m+c-1, j] .= 'O'
            data[m+c:n, j] .= '.'
        end
    end
    return nothing
end

check_load(data) = sum(data[i, j] == 'O' ? size(data, 1) - i + 1 : 0 for j in axes(data, 2), i in axes(data, 1))

tilted_data = copy(data)
tilt_north!(tilted_data)
answer1 = check_load(tilted_data)

function spin!(data)
    tilt_north!(data)
    data .= rotr90(data)
    tilt_north!(data)
    data .= rotr90(data)
    tilt_north!(data)
    data .= rotr90(data)
    tilt_north!(data)
    data .= rotr90(data)
    return nothing
end


function find_cycle!(spin_data)::Tuple{Int, Int}
    hashes = Dict{UInt, Int}()
    i = 0
    while i < 10000
        h = hash(spin_data)
        if h in keys(hashes)
            return hashes[h], i
        else
            hashes[h] = i
            spin!(spin_data)
        end
        i += 1
    end
    return (-1, -1)
end

spin_data = copy(data)
num_cycles = 1000000000
a, b = find_cycle!(spin_data)
n = mod(num_cycles - b, b - a)
for i in 1:n
    spin!(spin_data)
end
answer2 = check_load(spin_data)

@show answer1
@show answer2
