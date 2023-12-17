input = readlines(joinpath(@__DIR__, "data/input16"))
data = stack(input, dims = 1)

energized = zeros(UInt8, size(data)...)
beams = zeros(UInt8, size(data)...)

const R = 0x01
const U = 0x02
const L = 0x04
const D = 0x08

beams[1] = R
energized[1] |= R

function update!(beams, energized, data)
    nextbeams = zeros(UInt8, size(beams)...)
    for ind in eachindex(IndexCartesian(), data)
        i, j = Tuple(ind)
        if !iszero(beams[i, j])
            if data[i, j] == '.'
                if !iszero(R & beams[i, j])
                    if j < size(beams, 2)
                        nextbeams[i, j + 1] |= R
                        energized[i, j + 1] |= R
                    end
                end
                if !iszero(U & beams[i, j])
                    if i > 1
                        nextbeams[i - 1, j] |= U
                        energized[i - 1, j] |= U
                    end
                end
                if !iszero(L & beams[i, j])
                    if j > 1
                        nextbeams[i, j - 1] |= L
                        energized[i, j - 1] |= L
                    end
                end
                if !iszero(D & beams[i, j])
                    if i < size(beams, 1)
                        nextbeams[i + 1, j] |= D
                        energized[i + 1, j] |= D
                    end
                end
            elseif data[i, j] == '\\'
                if !iszero(R & beams[i, j])
                    if i < size(beams, 1)
                        nextbeams[i + 1, j] |= D
                        energized[i + 1, j] |= D
                    end
                end
                if !iszero(U & beams[i, j])
                    if j > 1
                        nextbeams[i, j - 1] |= L
                        energized[i, j - 1] |= L
                    end
                end
                if !iszero(L & beams[i, j])
                    if i > 1
                        nextbeams[i - 1, j] |= U
                        energized[i - 1, j] |= U
                    end
                end
                if !iszero(D & beams[i, j])
                    if j < size(beams, 2)
                        nextbeams[i, j + 1] |= R
                        energized[i, j + 1] |= R
                    end
                end
            elseif data[i, j] == '/'
                if !iszero(R & beams[i, j])
                    if i > 1
                        nextbeams[i - 1, j] |= U
                        energized[i - 1, j] |= U
                    end
                end
                if !iszero(U & beams[i, j])
                    if j < size(beams, 2)
                        nextbeams[i, j + 1] |= R
                        energized[i, j + 1] |= R
                    end
                end
                if !iszero(L & beams[i, j])
                    if i < size(beams, 1)
                        nextbeams[i + 1, j] |= D
                        energized[i + 1, j] |= D
                    end
                end
                if !iszero(D & beams[i, j])
                    if j > 1
                        nextbeams[i, j - 1] |= L
                        energized[i, j - 1] |= L
                    end
                end
            elseif data[i, j] == '|'
                if !iszero(R & beams[i, j]) || !iszero(L & beams[i, j])
                    if i > 1
                        nextbeams[i - 1, j] |= U
                        energized[i - 1, j] |= U
                    end
                    if i < size(beams, 1)
                        nextbeams[i + 1, j] |= D
                        energized[i + 1, j] |= D
                    end
                end
                if !iszero(U & beams[i, j])
                    if i > 1
                        nextbeams[i - 1, j] |= U
                        energized[i - 1, j] |= U
                    end
                end
                if !iszero(D & beams[i, j])
                    if i < size(beams, 1)
                        nextbeams[i + 1, j] |= D
                        energized[i + 1, j] |= D
                    end
                end
            elseif data[i, j] == '-'
                if !iszero(R & beams[i, j])
                    if j < size(beams, 2)
                        nextbeams[i, j + 1] |= R
                        energized[i, j + 1] |= R
                    end
                end
                if !iszero(U & beams[i, j]) || !iszero(D & beams[i, j])
                    if j < size(beams, 2)
                        nextbeams[i, j + 1] |= R
                        energized[i, j + 1] |= R
                    end
                    if j > 1
                        nextbeams[i, j - 1] |= L
                        energized[i, j - 1] |= L
                    end
                end
                if !iszero(L & beams[i, j])
                    if j > 1
                        nextbeams[i, j - 1] |= L
                        energized[i, j - 1] |= L
                    end
                end
            end
        end
    end
    beams .= nextbeams
    return nothing
end

prevenergized = zeros(UInt8, size(energized)...)
while energized != prevenergized
    prevenergized .= energized
    update!(beams, energized, data)
end

answer1 = count(!iszero, energized)

answer2 = answer1
for i in axes(data, 1)
    local energized = zeros(UInt8, size(data)...)
    local beams = zeros(UInt8, size(data)...)
    beams[i, 1] = R
    energized[i, 1] |= R
    local prevenergized = zeros(UInt8, size(energized)...)
    while energized != prevenergized
        prevenergized .= energized
        update!(beams, energized, data)
    end
    global answer2 = max(answer2, count(!iszero, energized))
    local energized = zeros(UInt8, size(data)...)
    local beams = zeros(UInt8, size(data)...)
    beams[i, end] = L
    energized[i, end] |= L
    local prevenergized = zeros(UInt8, size(energized)...)
    while energized != prevenergized
        prevenergized .= energized
        update!(beams, energized, data)
    end
    global answer2 = max(answer2, count(!iszero, energized))
end
for j in axes(data, 2)
    local energized = zeros(UInt8, size(data)...)
    local beams = zeros(UInt8, size(data)...)
    beams[1, j] = D
    energized[1, j] |= D
    local prevenergized = zeros(UInt8, size(energized)...)
    while energized != prevenergized
        prevenergized .= energized
        update!(beams, energized, data)
    end
    global answer2 = max(answer2, count(!iszero, energized))
    local energized = zeros(UInt8, size(data)...)
    local beams = zeros(UInt8, size(data)...)
    beams[end, j] = U
    energized[end, j] |= U
    local prevenergized = zeros(UInt8, size(energized)...)
    while energized != prevenergized
        prevenergized .= energized
        update!(beams, energized, data)
    end
    global answer2 = max(answer2, count(!iszero, energized))
end

@show answer1
@show answer2
