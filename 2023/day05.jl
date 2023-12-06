input = readlines(joinpath(@__DIR__, "data/input05"))

seeds = parse.(Int, split(input[1][8:end], " "))
seed_to_soil = vcat([reshape(parse.(Int, split(input[i], " ")), 1, 3) for i in 4:15]...)
soil_to_fertilizer = vcat([reshape(parse.(Int, split(input[i], " ")), 1, 3) for i in 18:34]...)
fertilizer_to_water = vcat([reshape(parse.(Int, split(input[i], " ")), 1, 3) for i in 37:75]...)
water_to_light = vcat([reshape(parse.(Int, split(input[i], " ")), 1, 3) for i in 78:118]...)
light_to_temperature = vcat([reshape(parse.(Int, split(input[i], " ")), 1, 3) for i in 121:152]...)
temperature_to_humidity = vcat([reshape(parse.(Int, split(input[i], " ")), 1, 3) for i in 155:196]...)
humidity_to_location = vcat([reshape(parse.(Int, split(input[i], " ")), 1, 3) for i in 199:244]...)

seedranges = [seeds[i]:seeds[i] + seeds[i + 1] - 1 for i in 1:2:length(seeds)]
map1 = [(r[2]:r[2] + r[3] - 1, r[1]:r[1] + r[3] - 1) for r in eachrow(seed_to_soil)]
map2 = [(r[2]:r[2] + r[3] - 1, r[1]:r[1] + r[3] - 1) for r in eachrow(soil_to_fertilizer)]
map3 = [(r[2]:r[2] + r[3] - 1, r[1]:r[1] + r[3] - 1) for r in eachrow(fertilizer_to_water)]
map4 = [(r[2]:r[2] + r[3] - 1, r[1]:r[1] + r[3] - 1) for r in eachrow(water_to_light)]
map5 = [(r[2]:r[2] + r[3] - 1, r[1]:r[1] + r[3] - 1) for r in eachrow(light_to_temperature)]
map6 = [(r[2]:r[2] + r[3] - 1, r[1]:r[1] + r[3] - 1) for r in eachrow(temperature_to_humidity)]
map7 = [(r[2]:r[2] + r[3] - 1, r[1]:r[1] + r[3] - 1) for r in eachrow(humidity_to_location)]

function addintervals!(m)
    push!(m, (0:minimum(getproperty.(getindex.(m, 1), :start))-1, 0:minimum(getproperty.(getindex.(m, 1), :start))-1))
    push!(m, (maximum(getproperty.(getindex.(m, 1), :stop))+1:2^63-1, maximum(getproperty.(getindex.(m, 1), :stop))+1:2^63-1))
    filter!(!isempty, m)
    sort!(m, lt = (x, y) -> x[1].start <= y[1].start)
    for i in 1:length(m) - 1
        if m[i + 1][2].start > m[i][1].stop + 1
            push!(m, (m[i][1].stop + 1:m[i + 1][1].start - 1, m[i][1].stop + 1:m[i + 1][1].start - 1))
        end
    end
end

addintervals!(map1)
addintervals!(map2)
addintervals!(map3)
addintervals!(map4)
addintervals!(map5)
addintervals!(map6)
addintervals!(map7)

function g(ranges, m)
    final = UnitRange{Int}[]
    for r in ranges
        append!(final, filter!(!isempty, [intersect(r, m[i][1]) .- (m[i][1].start - m[i][2].start) for i in eachindex(m)]))
    end
    return final
end

s = [s:s for s in seeds]
s = g(s, map1)
s = g(s, map2)
s = g(s, map3)
s = g(s, map4)
s = g(s, map5)
s = g(s, map6)
s = g(s, map7)
answer1 = minimum(minimum.(s))

s = seedranges
s = g(s, map1)
s = g(s, map2)
s = g(s, map3)
s = g(s, map4)
s = g(s, map5)
s = g(s, map6)
s = g(s, map7)
answer2 = minimum(minimum.(s))

@show answer1
@show answer2
