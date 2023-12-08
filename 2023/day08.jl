input = readlines(joinpath(@__DIR__, "data/input08"))

LR = [parse(Int, c) for c in replace(input[1], 'L' => '1', 'R' => '2')]
m = collect.(eachmatch.(r"[A-Z]{3}", input[3:end]))
d = Dict(m[1].match => (m[2].match, m[3].match) for m in m)

n = 0
current = "AAA"
while current != "ZZZ"
    global n += 1
    global current = d[current][LR[mod1(n, length(LR))]]
end
answer1 = n

n = 0
currents = [k for k in keys(d) if k[3] == 'A']
timetoz = zeros(Int, length(currents))
while any(iszero, timetoz)
    global n += 1
    lr = LR[mod1(n, length(LR))]
    for i in eachindex(currents)
        currents[i] = d[currents[i]][lr]
        if currents[i][3] == 'Z' && timetoz[i] == 0
            timetoz[i] = n
        end
    end
end
answer2 = lcm(timetoz)

@show answer1
@show answer2
