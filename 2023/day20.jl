input = readlines(joinpath(@__DIR__, "data/input20"))
# input = ["broadcaster -> a, b, c",
#          "%a -> b",
#          "%b -> c",
#          "%c -> inv",
#          "&inv -> a"]
# input = ["broadcaster -> a",
#          "%a -> inv, con",
#          "&inv -> b",
#          "%b -> con",
#          "&con -> output"]

abstract type AOCModule end

mutable struct Flipflop <: AOCModule
    state::Bool
    parents::Vector{Int}
    children::Vector{Int}
    name::String
end

mutable struct Conjunction <: AOCModule
    memory::Vector{Bool}
    parents::Vector{Int}
    children::Vector{Int}
    name::String
end

mutable struct Broadcast <: AOCModule
    children::Vector{Int}
    name::String
end

mutable struct Output <: AOCModule
    state::Bool
    parents::Vector{Int}
    name::String
end

function create_modules(input)
    names = [strip(split(i, " -> ")[1], ['&', '%']) for i in input]
    outputnames = union([setdiff(split(split(i, " -> ")[2], ", "), names) for i in input]...)
    append!(names, outputnames)
    children = [findall(n in split(split(i, " -> ")[2], ", ") for n in names) for i in input]
    append!(children, [Int[] for _ in outputnames])
    parents = [findall(i in c for c in children) for i in eachindex(children)]
    modules = AOCModule[if s[1] == 'b'
                            Broadcast(children[i], names[i])
                        elseif s[1] == '%'
                            Flipflop(false, parents[i], children[i], names[i])
                        elseif s[1] == '&'
                            Conjunction(falses(length(parents[i])), parents[i], children[i], names[i])
                        end for (i, s) in enumerate(input)]
    for (i, n) in enumerate(outputnames)
        push!(modules, Output(false, parents[i + length(input)], n))
    end
    adjm = zeros(Int, length(names), length(names))
    for i in axes(adjm, 1)
        for j in children[i]
            adjm[i, j] = 1
        end
    end
    fullnames = [[split(i, " -> ")[1] for i in input]; outputnames]
    return modules, adjm, fullnames
end

sendlow(m::Broadcast, senderindex) = (false, m.children)
sendhigh(m::Broadcast, senderindex) = (true, m.children)
sendlow(m::Output, senderindex) = (m.state = false; (false, Int[]))
sendhigh(m::Output, senderindex) = (m.state = true; (true, Int[]))
sendlow(m::Flipflop, senderindex) = (m.state ⊻= true, m.children)
sendhigh(::Flipflop, senderindex) = (false, Int[])

function sendlow(m::Conjunction, senderindex)
    i = findfirst(isequal(senderindex), m.parents)
    m.memory[i] = false
    (!all(m.memory), m.children)
end

function sendhigh(m::Conjunction, senderindex)
    i = findfirst(isequal(senderindex), m.parents)
    m.memory[i] = true
    (!all(m.memory), m.children)
end

sendsignal(m::AOCModule, senderindex, signal) = signal ? sendhigh(m, senderindex) : sendlow(m, senderindex)

function pressbutton(modules::Vector{AOCModule})
    pulsestack = Tuple{Bool, Vector{Int}, Int}[] # (low/high, dests, src)
    broadcastindex = findfirst(isa.(modules, Broadcast))
    push!(pulsestack, (false, modules[broadcastindex].children, broadcastindex))
    low = 1
    high = 0

    # these nodes were picked manually...
    isgfhigh = false
    isvchigh = false
    isdbhigh = false
    isqxhigh = false
    gf = findfirst("gf" == m.name for m in modules)
    vc = findfirst("vc" == m.name for m in modules)
    db = findfirst("db" == m.name for m in modules)
    qx = findfirst("qx" == m.name for m in modules)

    while !isempty(pulsestack)
        signal, to, from = popfirst!(pulsestack)
        signal ? (high += length(to);) : (low += length(to);)
        for i in to
            next = sendsignal(modules[i], from, signal)
            isempty(next[2]) || push!(pulsestack, (next..., i))
            all(modules[gf].memory) && (isgfhigh = true;)
            all(modules[vc].memory) && (isvchigh = true;)
            all(modules[db].memory) && (isdbhigh = true;)
            all(modules[qx].memory) && (isqxhigh = true;)
        end
    end
    return low, high, isgfhigh, isvchigh, isdbhigh, isqxhigh
end

modules, adjm, names = create_modules(input)
totallow = 0
totalhigh = 0
gf = vc = db = qx = -1 # manually figure out which nodes to pick here...
i = 0
while i < 1000 || min(gf, vc, db, qx) < 0
    i += 1
    low, high, isgf, isvc, isdb, isqx = pressbutton(modules)
    if i <= 1000
        totallow += low
        totalhigh += high
    end
    if isgf && gf == -1
        gf = i
    end
    if isvc && vc == -1
        vc = i
    end
    if isdb && db == -1
        db = i
    end
    if isqx && qx == -1
        qx = i
    end
end
answer1 = totallow * totalhigh
answer2 = lcm(gf, vc, db, qx)

@show answer1
@show answer2
