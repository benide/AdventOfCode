input = readlines(joinpath(@__DIR__, "data/input03"))

mat = permutedims(hcat([[input[i]...] for i in eachindex(input)]...), (2, 1))
partnumbers = collect.(eachmatch.(r"([0-9]+)", input))
ranges_of_influence = [NTuple{2, UnitRange{Int64}}[] for i in eachindex(input)]
answer1 = 0
for i in eachindex(input)
    rows = intersect(i - 1:i + 1, 1:length(input))
    for m in partnumbers[i]
        cols = intersect(1:length(input[i]), m.offset - 1:m.offset + length(m.match))
        if any(c ∉ ".0123456789" for c in mat[rows, cols])
            answer1 += parse(Int, m.match)
        end
        push!(ranges_of_influence[i], (rows, cols))
    end
end

answer2 = 0
for j in axes(mat, 2)
    for i in axes(mat, 1)
        if mat[i, j] == '*'
            n = 0
            temp = 1
            for i2 in eachindex(ranges_of_influence)
                for j2 in eachindex(ranges_of_influence[i2])
                    if i in ranges_of_influence[i2][j2][1] && j in ranges_of_influence[i2][j2][2]
                        temp *= parse(Int, partnumbers[i2][j2].match)
                        n += 1
                    end
                end
            end
            n == 2 && (answer2 += temp;)
        end
    end
end
