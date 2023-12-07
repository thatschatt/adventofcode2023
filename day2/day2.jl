using Scanf

function go(filename)
    lines = readlines(filename)
    target = Dict("red"=>12, "green"=>13, "blue"=>14)
    totalpossible = 0
    for (n, line) in enumerate(lines)
        gamen, results = split(line, ':')
        _, id = @scanf(line, "Game %d", Int) #not actually sure i needed to do this

        possible = true
        for set in split(results, ';')
            for res in split(set, ',')
                _, num, col = @scanf(res, " %d %s", Int, String)
                possible &= (target[col] >= num)
            end
        end
        if possible
            totalpossible += id
        end
    end
    display(totalpossible)
end

function go2(filename)
    lines = readlines(filename)
    totalpower = 0
    
    for (n, line) in enumerate(lines)
        gamen, results = split(line, ':')
        _, id = @scanf(line, "Game %d", Int) #not actually sure i needed to do this
        
        mincubes = Dict("red"=>0, "green"=>0, "blue"=>0)
        for set in split(results, ';')
            for res in split(set, ',')
                _, num, col = @scanf(res, " %d %s", Int, String)
                mincubes[col] = max(mincubes[col], num) 
            end
        end
        power = mincubes["red"] * mincubes["blue"] * mincubes["green"]
        totalpower += power
    end
    display(totalpower)
end

go("input2.txt")
go2("input2.txt")