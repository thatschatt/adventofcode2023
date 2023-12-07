using Scanf

# note: the numbers on the input files are massive, so there is no way we can just make dense arrays for the maps

function parseinput(filename)
    lines = readlines(filename)

    seeds = parse.(Int, split(split(lines[1], ":")[2]))
    println("seeds: $(seeds')")

    sourceranges = Vector{Vector{UnitRange{Int64}}}() #hopefully julia's range type will save us
    destranges = Vector{Vector{UnitRange{Int64}}}() 

    n = 0
    for line in lines[2:end]
        if isempty(line) #ignore blanks
            n += 1
            push!(sourceranges, Vector{UnitRange{Int64}}()) 
            push!(destranges, Vector{UnitRange{Int64}}())
            continue
        elseif !isdigit(line[1]) #incerment n then skip over headers
            continue
        end

        _, dest, source, rlen = @scanf(line, "%d %d %d", Int, Int, Int)
        push!(sourceranges[n], source:(source+rlen-1))
        push!(destranges[n], dest:(dest+rlen-1))     
    end
    return seeds, sourceranges, destranges
end

function go(seeds, sourceranges, destranges)

  #  display(sourceranges)
  #  display(destranges)

    minloc = Inf
    for seedstart in seeds
        seed = seedstart
        for (sources, dests) in zip(sourceranges, destranges) #looping each map
            for (source, dest) in zip(sources, dests)
                if seed ∈ source
                    newseed = (seed - source[1]) + dest[1]
               #     println("seed $seed source $source[1] dest $dest[1]")
                    println("went from $seed to $newseed")
                    seed = newseed
                    break
                end
            end
        end
        println("*** final location is $seed")
        if seed < minloc
            minloc = seed
        end
    end
    println("smallest location is $minloc\n\n")


    ## now comes part 2. Only need to redefine the seeds to be ranges
    # big difference is now for each location, we have to loop over the whole map
    # this gets tricky because we can't discard anything until we've gone down the whole tree
    #
    # so basically we need to do a full tree search for each interval this overlaps with the current one

    # feels like this is gonna be recursion
    seeds = map(:, seeds[1:2:end], seeds[1:2:end] .+ seeds[2:2:end].-1)

  #  seeds = [82:83]

    smallest = Inf
    for s in seeds
        sm = getmapping(sourceranges, destranges, s, 1, Inf)
        smallest = Int(min(sm, smallest))
    end
    println("---------------------")
    println("smallest was $smallest")
    println("---------------------")
end


function getmapping(sourceranges, destranges, seeds, mapn, smallest)
 #   println("map level $mapn")
#    println("# # # # # # # #  # # # # #  # #")
#    println("seeds at function entry $seeds")
    
    if mapn == 8
   #     println("final dest is $(seeds)")
        if seeds[1] < smallest
            return seeds[1]
        else
            return smallest
        end
    end
    
    # ok so we can't just take intersections because you can't have a discontinuous one
    # need to start at the bottom of the range and send it down the line piece by piece
    sourcestarts = [x[1] for x in sourceranges[mapn]]
    sortedsource = sourceranges[mapn][sortperm(sourcestarts)]
    sorteddest = destranges[mapn][sortperm(sourcestarts)]

  #  println("sources at function entry $(sortedsource)")
  #  println("dests at function entry $(sorteddest)")

    for (source, dest) in zip(sortedsource, sorteddest)
  #      println("source in loop $(source)")
  #      println("dest in loop  $(dest)")
        # for each source in the map:
        #   1: check if there are any uncaught parts of the seed
        #       if so, run those with the seed as dest, then trim the seed range
        #   2: take the interect of the source and seed, and send it on. Again, trim the output
        # we need to manually update ranges, setdiff() won't save us here

        if seeds[1] < source[1] #we got uncovered parts
            smallest = getmapping(sourceranges, destranges, seeds[1]:source[1]-1, mapn+1, smallest)
            seeds = source[1]:min(seeds[end], source[end]) #redefine range
        end
        
        if isempty(seeds)
            break
        end

        if seeds[1] > source[end] #are the seeds all after the source?
            continue
        end

        if seeds[end] <= source[end] #seeds are completely inside source
            smallest = getmapping(sourceranges, destranges, seeds .+ (dest[1] - source[1]), mapn+1, smallest)
            seeds= 0:-1 #make it empty
            break #this must be the last sourcerange
        end

        if seeds[end] > source[end] #and seed overlap
            #we only prcess the overlap, and leave the rest for the next loop iteration
            smallest = getmapping(sourceranges, destranges, (seeds[1]:source[end]) .+ (dest[1] - source[1]), mapn+1, smallest)
            seeds = source[end]+1:seeds[end]
        end

    end
    if !isempty(seeds) #process te last tail
        smallest = getmapping(sourceranges, destranges, seeds, mapn+1, smallest)
    end
    return smallest
end

seeds, sourceranges, destranges = parseinput("input5.txt")
go(seeds, sourceranges, destranges)