
function go(filename)
    lines = readlines(filename)
    valsum = 0
    for line in lines
        vals = parse.(Int, split(line))
        v = getnextval(vals)
        println(v)
        valsum += v
    end
    println("sum is $valsum")
end

function go2(filename)
    lines = readlines(filename)
    valsum = 0
    for line in lines
        vals = parse.(Int, split(line))
        v = getprevval(vals)
        println(v)
        valsum += v
    end
    println("sum is $valsum")
end

function getnextval(vals)
    d = diff(vals)
    if all(d .== 0)
        return vals[end]
    else
        return vals[end] + getnextval(d)
    end
end

function getprevval(vals)
    d = diff(vals)
    if all(d .== 0)
        return vals[1]
    else
        return vals[1] - getprevval(d)
    end
end


go("test9.txt")
go2("test9.txt")

go("input9.txt")
go2("input9.txt")