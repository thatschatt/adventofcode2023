using Scanf

function parse(filename)
    lines = readlines(filename)

    directions = map(x -> x == 'L' ? 1 : 2, collect(lines[1]))
    nodes = Dict{String, Tuple{String, String}}()
    for line in lines[3:end]
        start, r, l = match(r"(...) = \((...), (...)\)", line).captures
        nodes[start] = (r, l)
    end
    return (directions, nodes)
end

function go(directions, nodes)
    node = "AAA"
    n = 0
    while node != "ZZZ"
        node = nodes[node][directions[n%length(directions) + 1 ]]
        n += 1
    end
    return n
end

function go(directions, nodes, firstnode)
    node = firstnode
    n = 0
    while node[3] != 'Z'
        node = nodes[node][directions[n%length(directions) + 1 ]]
        n += 1
    end
    return n
end

function go2(directions, nodes) #ok this doesn't work. Instead we need to getect loops? Seems iffy.
    ghostnodes = String.(getproperty.(filter!(x->x!=nothing, match.(r"..A", keys(nodes))), :match)) #sexy matching for all nodes ending in A
    n = 0
    println(ghostnodes)
    while n < 10000
        n_end = 0
        for g in 1:length(ghostnodes)
            ghostnodes[g] = nodes[ghostnodes[g]][directions[n%length(directions) + 1 ]]
            if ghostnodes[g][3] == 'Z'
                n_end += 1
            end
        end
        n += 1
        if n%1000000 == 0
            println(ghostnodes)
        end
        if n_end == length(ghostnodes)
            return n
        end
    end
    return n
end

directions, nodes = parse("input8.txt")
ghostnodes = String.(getproperty.(filter!(x->x!=nothing, match.(r"..A", keys(nodes))), :match)) #sexy matching for all nodes ending in A
loopn = [go(directions, nodes, g) for g in ghostnodes]
println(lcm(loopn))

#go2(directions, nodes)
