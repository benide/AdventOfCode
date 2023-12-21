input = readlines(joinpath(@__DIR__, "data/input21"))
data = stack(input, dims = 1)
const start = findfirst(isequal('S'), data)
data[start] = '.'
const plotmap = map(isequal('.'), data)

function f(nsteps = 64)
    current = falses(size(plotmap)...)
    current[start] = true
    for _ in 1:nsteps
        next = falses(size(plotmap)...)
        for j in axes(next, 2)
            for i in axes(next, 1)
                if current[i, j]
                    i > 1 && plotmap[i - 1, j] && (next[i - 1, j] = true;)
                    j > 1 && plotmap[i, j - 1] && (next[i, j - 1] = true;)
                    i < size(next, 1) && plotmap[i + 1, j] && (next[i + 1, j] = true;)
                    j < size(next, 2) && plotmap[i, j + 1] && (next[i, j + 1] = true;)
                end
            end
        end
        current .= next
    end
    return count(current)
end

answer1 = f()

# using a (2n - 1) x (2n - 1) grid of plotmaps, find the number of plots that can be visited within this grid with nsteps
function g(n, nsteps)
    x = size(plotmap, 1) * (2n - 1)
    y = size(plotmap, 2) * (2n - 1)
    s = CartesianIndex(start[1] + (n - 1) * size(plotmap, 1), start[2] + (n - 1) * size(plotmap, 2))
    p = repeat(plotmap, outer = (2n - 1, 2n - 1))
    current = falses(x, y)
    current[s] = true
    for i in 1:nsteps
        next = falses(x, y)
        for j in axes(next, 2)
            for i in axes(next, 1)
                if current[i, j]
                    i > 1 && p[i - 1, j] && (next[i - 1, j] = true;)
                    j > 1 && p[i, j - 1] && (next[i, j - 1] = true;)
                    i < size(next, 1) && p[i + 1, j] && (next[i + 1, j] = true;)
                    j < size(next, 2) && p[i, j + 1] && (next[i, j + 1] = true;)
                end
            end
        end
        current .= next
    end
    return sum(current)
end

# I don't fully understand the solution to part 2 here.
# I believe it relies on the fact that the entire boundary is accessible and that the entire row and column with S are accessible and that the grid is square.
@assert all(isone, plotmap[1, :])
@assert all(isone, plotmap[end, :])
@assert all(isone, plotmap[:, 1])
@assert all(isone, plotmap[:, end])
@assert all(isone, plotmap[start[1], :])
@assert all(isone, plotmap[:, start[2]])
@assert size(plotmap, 1) == size(plotmap, 2)

# it might also depend on S being the center
@assert 2start[1]-1 == 2start[2]-1 == size(plotmap, 1)

nsteps = 26501365 # number of steps we need to take

# the number of plots visited increases quadratically
h(x) = g(3, mod(nsteps, size(plotmap, 1)) + x * size(plotmap, 1))
a, b, c = [0 0 1; 1 1 1; 4 2 1] \ h.(0:2) .|> Int
x = div(nsteps, size(plotmap, 1))
answer2 = a * x^2 + b * x + c

@show answer1
@show answer2
