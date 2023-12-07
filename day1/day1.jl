using Scanf

function go(filename)
    lines = readlines(filename)
    totalcal = 0
    for line in lines
        firstD = -1
        lastD = -1
        for c in line #i'm sure i could do this with a regex, but i aint
            if isdigit(c)
                if firstD == -1
                    firstD = parse(Int, c)
                    lastD = firstD
                else
                    lastD = parse(Int, c)
                end
            end
        end
        println(line)
        println("$firstD $lastD")
        cal = 10*firstD + lastD
        totalcal += cal
    end
    return totalcal
end

function getdigit(line, matches, first=true)
    D = 0
    if first
        firstind = 99999
    else
        firstind = 0
        end
    ind = 1:2
    for n in 1:9
        if first
            ind = findfirst(matches[n], line)
        else
            ind = findlast(matches[n], line)
        end
        if !isnothing(ind)
            if first
                if ind[1] < firstind
                    firstind = ind[1]
                    D = n
                end
            else
                if ind[1] > firstind
                    firstind = ind[1]
                    D = n
                end
            end
        end
    end
    return D, firstind
end

function go2(filename)
    # so this time I'll have to do it using substrings
    # I tihnk the plan is to loop through the 10 digits, looksing for either
    #  that digit string, or the digit itself
    lines = readlines(filename)
    totalcal = 0
    digitwords = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
    digits = "123456789"
    for line in lines
        firstDword, indw = getdigit(line, digitwords, true)
        firstDchar, indc = getdigit(line, digits, true)
        if indw < indc
            firstD = firstDword
        else
            firstD = firstDchar
        end

        lastDword, indw = getdigit(line, digitwords, false)
        lastDchar, indc = getdigit(line, digits, false)

        if indw > indc
            lastD = lastDword
        else
            lastD = lastDchar
        end

        println("$line $firstD $lastD")
        cal = 10*firstD + lastD
        totalcal += cal
    end
    return totalcal
end

display(go2("input1.txt"))