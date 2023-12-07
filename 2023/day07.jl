input = readlines(joinpath(@__DIR__, "data/input07"))
hands = split.(input, " ")

function hands_lessthan(x, y)
    x_counts = [count(isequal(c), x[1]) for c in x[1]]
    y_counts = [count(isequal(c), y[1]) for c in y[1]]
    cx = maximum(count(isequal(c), x[1]) for c in x[1])
    cy = maximum(count(isequal(c), y[1]) for c in y[1])
    cx == cy || (return cx < cy;)
    (cx == 5 || cx == 4) && (return highcard_lessthan(x, y);)

    if cx == 3
        if 2 in x_counts
            if 2 in y_counts
                return highcard_lessthan(x, y)
            else
                return false
            end
        elseif 2 in y_counts
            return true
        else
            return highcard_lessthan(x, y)
        end
    end

    if cx == 2
        if count(isequal(2), x_counts) == 4
            if count(isequal(2), y_counts) == 4
                return highcard_lessthan(x, y)
            else
                return false
            end
        elseif count(isequal(2), y_counts) == 4
            return true
        else
            return highcard_lessthan(x, y)
        end
    end

    return highcard_lessthan(x, y)
end

function highcard_lessthan(x, y)
    x[1] == y[1] && (return true;)
    s = "23456789TJQKA"
    a = x[1][1]; b = y[1][1];
    a == b || (return findfirst(isequal(a), s) <= findfirst(isequal(b), s);)
    a = x[1][2]; b = y[1][2];
    a == b || (return findfirst(isequal(a), s) <= findfirst(isequal(b), s);)
    a = x[1][3]; b = y[1][3];
    a == b || (return findfirst(isequal(a), s) <= findfirst(isequal(b), s);)
    a = x[1][4]; b = y[1][4];
    a == b || (return findfirst(isequal(a), s) <= findfirst(isequal(b), s);)
    a = x[1][5]; b = y[1][5];
    a == b || (return findfirst(isequal(a), s) <= findfirst(isequal(b), s);)
end

function hands_lessthan2(x, y)
    x_counts = [count(isequal(c), x[1]) for c in x[1]]
    y_counts = [count(isequal(c), y[1]) for c in y[1]]

    i = findall(!isequal('J'), x[1])
    j = findall(isequal('J'), x[1])
    if !isempty(j) && !isempty(i)
        m = maximum(x_counts[i])
        k = setdiff(findall(isequal(m), x_counts), j)
        x_counts[k[1:m]] .+= length(j)
        x_counts[j] .= x_counts[k[1]]
    end
    cx = maximum(x_counts)

    i = findall(!isequal('J'), y[1])
    j = findall(isequal('J'), y[1])
    if !isempty(j) && !isempty(i)
        m = maximum(y_counts[i])
        k = setdiff(findall(isequal(m), y_counts), j)
        y_counts[k[1:m]] .+= length(j)
        y_counts[j] .= y_counts[k[1]]
    end
    cy = maximum(y_counts)

    cx == cy || (return cx < cy;)
    (cx == 5 || cx == 4) && (return highcard_lessthan2(x, y);)

    if cx == 3
        if 2 in x_counts
            if 2 in y_counts
                return highcard_lessthan2(x, y)
            else
                return false
            end
        elseif 2 in y_counts
            return true
        else
            return highcard_lessthan2(x, y)
        end
    end

    if cx == 2
        if count(isequal(2), x_counts) == 4
            if count(isequal(2), y_counts) == 4
                return highcard_lessthan2(x, y)
            else
                return false
            end
        elseif count(isequal(2), y_counts) == 4
            return true
        else
            return highcard_lessthan2(x, y)
        end
    end

    return highcard_lessthan2(x, y)
end

function highcard_lessthan2(x, y)
    x[1] == y[1] && (return true;)
    s = "J23456789TQKA"
    a = x[1][1]; b = y[1][1];
    a == b || (return findfirst(isequal(a), s) <= findfirst(isequal(b), s);)
    a = x[1][2]; b = y[1][2];
    a == b || (return findfirst(isequal(a), s) <= findfirst(isequal(b), s);)
    a = x[1][3]; b = y[1][3];
    a == b || (return findfirst(isequal(a), s) <= findfirst(isequal(b), s);)
    a = x[1][4]; b = y[1][4];
    a == b || (return findfirst(isequal(a), s) <= findfirst(isequal(b), s);)
    a = x[1][5]; b = y[1][5];
    a == b || (return findfirst(isequal(a), s) <= findfirst(isequal(b), s);)
end

answer1 = sum(parse.(Int, getindex.(sort(hands, lt = hands_lessthan), 2)) .* (1:length(input)))
answer2 = sum(parse.(Int, getindex.(sort(hands, lt = hands_lessthan2), 2)) .* (1:length(input)))

@show answer1
@show answer2
