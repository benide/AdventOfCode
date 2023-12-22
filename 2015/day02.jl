input = [parse.(Int, s) for s in split.(readlines(joinpath(@__DIR__, "data/input02")), 'x')]

answer1 = mapreduce(function(x)
                        s1 = x[1]*x[2]
                        s2 = x[1]*x[3]
                        s3 = x[2]*x[3]
                        2s1 + 2s2 + 2s3 + min(s1, s2, s3)
                    end, +, input)
answer2 = mapreduce(x -> 2 * min(sum(x[[1,2]]), sum(x[[1,3]]), sum(x[[2,3]])) + prod(x), +, input)

@show answer1
@show answer2
