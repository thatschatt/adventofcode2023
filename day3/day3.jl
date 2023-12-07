
function checkispart(lines, n, m)
    try
        if !isdigit(lines[n][m]) && lines[n][m] != '.'
            return true
        end
    catch
        return false
    end
    return false
end

function checkisgear!(gearpos, lines, n, m)
    # should really be warpped up i nthe getpart function
    #   but doing the multioutputs ia a little fiddly for
    #   the |= we are currently using
    # mutating an array to make getting the coords easy
    try
        if lines[n][m] == '*'
            gearpos[1] = n
            gearpos[2] = m
            return true
        end
    catch
        return false
    end
    return false
end

function go(filename)
    lines = readlines(filename)
    # plan here is every time we hit a set of numbers, 
    #   exhaustively check around them. I guess this
    #   does more lookups than necessayr, but whatever

    # for part2, I will create a dict mapping the coords
    #   of each * to the list of part numbers next to it
    #   I will also enumberate every part, to make mapping thins out later easier

    totalsum = 0
    partn = 1
    partnumbers = Vector{Int}()
    gears = Dict{Tuple{Int, Int}, Array{Int}}() #this dict maps positions of gears to every partn touching it
    for (n, line) in enumerate(lines)
        currentno = 0
        validpart = false
        isgear = false
        for (m, c) in enumerate(line) #loop through one by one to make indices trackable
            if !isdigit(c)
                if currentno != 0
                    println("found number $currentno, valid=$validpart")
                    push!(partnumbers, currentno)
                    partn += 1
                    if validpart 
                        totalsum += currentno
                    end
                end
                currentno = 0
                validpart = false 
                isgear = false   
            else
                currentno = 10*currentno + parse(Int, c)
                #now fto check for the part status
                for a in -1:1, b in -1:1
                    validpart |= checkispart(lines, n-a, m-b)
                end

                if validpart #just label gear like this, than we add to the dict later
                    gp = [0, 0]
                    for a in -1:1, b in -1:1
                        isgear |= checkisgear!(gp, lines, n-a, m-b)
                    end

                    if isgear #push the part number if it's a gear
                        if haskey(gears, (gp[1], gp[2]))
                            push!(gears[(gp[1], gp[2])], partn)
                        else
                            gears[(gp[1], gp[2])] = [partn]
                        end
                    end
                end
            end
        end
        if currentno != 0
            println("found number $currentno, valid=$validpart")
            push!(partnumbers, currentno)
            partn += 1
            if validpart 
                totalsum += currentno
            end
        end
    end
    println("parts:")
    display(partnumbers)
    println("gears:")
    display(gears)

    println("sum is $totalsum")
    totalrat = 0
    for g in keys(gears)
        if g == (0, 0)
            continue
        end
        parts = unique(gears[g])
        if length(parts) == 2
            gearrat = partnumbers[parts[1]] *  partnumbers[parts[2]]
            println("valid gear at $g, parts $(partnumbers[parts[1]]) and $(partnumbers[parts[2]]), ratio = $gearrat")
            totalrat += gearrat
        end

    end
    println("total ratio is $totalrat")
end

go("input3.txt")