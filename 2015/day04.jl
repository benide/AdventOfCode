input = readline(joinpath(@__DIR__, "data/input04"))

using MD5
answer1 = findfirst(bytes2hex(md5(input * string(n)))[1:5] == "00000" for n in 1:100000000)
answer2 = findfirst(bytes2hex(md5(input * string(n)))[1:6] == "000000" for n in 1:100000000)

@show answer1
@show answer2
