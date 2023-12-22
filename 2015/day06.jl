input = readlines(joinpath(@__DIR__, "data/input06"))

instructions = [begin
                    action = s[6:8] == "off" ? :off : (s[6:7] == "on" ? :on : :toggle)
                    a, b = [parse.(Int, split(m.match, ',')) for m in eachmatch(r"\d+,\d+", s)]
                    (action, a[1]:b[1], a[2]:b[2])
                end for s in input]

lights = falses(1000, 1000)

for (action, i, j) in instructions
    action == :on && (lights[i, j] .= true;)
    action == :off && (lights[i, j] .= false;)
    action == :toggle && (lights[i, j] .⊻= true;)
end

answer1 = count(lights)
    
lights2 = zeros(Int, 1000, 1000)

for (action, i, j) in instructions
    action == :on && (lights2[i, j] .+= 1;)
    action == :off && (for i2 in i, j2 in j
                           lights2[i2, j2] = max(lights2[i2, j2] - 1, 0)
                       end;)
    action == :toggle && (lights2[i, j] .+= 2;)
end

answer2 = sum(lights2)

@show answer1
@show answer2
