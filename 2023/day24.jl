input = readlines(joinpath(@__DIR__, "data/input24"))
temp = split.(input, " @ ")
pos = [parse.(Int, split(s[1], ", ")) for s in temp]
v = [parse.(Int, split(s[2], ", ")) for s in temp]

using LinearAlgebra

function test(p1, v1, p2, v2; m = 200000000000000, M = 400000000000000)
    @assert length(p1) == length(p2) == length(v1) == length(v2) == 2
    v = hcat(v1, -v2)
    if rank(v) < 2
        # could actually be true if they lie on the same line pointed at each other
        # just doing false here worked for this input...
        false
    else
        s, t = hcat(v1, -v2) \ (p2 .- p1)
        x, y = p1 + big(s) * v1
        s >= 0 && t >= 0 && m <= x <= M && m <= y <= M
    end
end

answer1 = 0
for i in 1:length(v) - 1, j in i + 1:length(v)
    answer1 += test(pos[i][1:2], v[i][1:2], pos[j][1:2], v[j][1:2])
end


# started to try and solve on paper. this is totally possible, but not worth the work.
# was told Z3 is a good idea. The Z3.jl package doesn't work.
# so...Icheated...used python. 
# below, p1 is pos[1] from julia, etc. redacted to not share any of the AoC input
# solution comes from github.com/rnbwdsh, but modified because there was no need to check all hailstones. 3 will do.

# import z3
# sol = z3.Solver()
# ps = z3.IntVector("p", 3)
# vs = z3.IntVector("v", 3)
# ts = z3.IntVector("t", 3)
# sol.add(z3.And([t >= 0 for t in ts]))
# p1 = [REDACTED]
# p2 = [REDACTED]
# p3 = [REDACTED]
# v1 = [REDACTED]
# v2 = [REDACTED]
# v3 = [REDACTED]
# for j in range(3):
#     sol.add(ps[j] + vs[j] * ts[0] == p1[j] + v1[j] * ts[0])
# for j in range(3):
#     sol.add(ps[j] + vs[j] * ts[1] == p2[j] + v2[j] * ts[1])
# for j in range(3):
#     sol.add(ps[j] + vs[j] * ts[2] == p3[j] + v3[j] * ts[2])
# sol.check()
# model = sol.model()
# answer2 = sum(model[ps[i]].as_long() for i in range(3))

answer2 = 618534564836937

@show answer1
@show answer2
