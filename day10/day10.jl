#since ther eis only a single starting point, I'll just hardcode it's value. Then it becomesa super simple lookup game

function go()
   # lines = readlines("input10.txt")
    lines = readlines("input10.txt")
    start = '7' #input10 ; 'F' #in the complex test case

    pipes = reduce(vcat, permutedims.(collect.(lines))) #shamelessly stolen from stackexchange
    startind = findfirst(x -> x=='S', pipes)

    currentind = [startind[1]  startind[2]]
    direction = [1 0] #start going down in the test case

    currentind += direction
    n = 1

    ispipe = zeros(Bool, size(pipes)) #store every pipe we see
    ispipe[currentind[1], currentind[2]] = true

    while pipes[currentind[1], currentind[2]] != 'S'
        if pipes[currentind[1], currentind[2]] == 'L' && direction == [1 0] #down to right
            direction = [0 1]
        elseif pipes[currentind[1], currentind[2]] == 'L' && direction == [0 -1] #left to up 
            direction = [-1 0]

        elseif pipes[currentind[1], currentind[2]] == 'J' && direction == [1 0] #down to left 
            direction = [0 -1]    
        elseif pipes[currentind[1], currentind[2]] == 'J' && direction == [0 1] #right to up 
            direction = [-1 0]

        elseif pipes[currentind[1], currentind[2]] == '7' && direction == [-1 0] #up to left 
            direction = [0 -1]    
        elseif pipes[currentind[1], currentind[2]] == '7' && direction == [0 1] #right to down 
            direction = [1 0]

        elseif pipes[currentind[1], currentind[2]] == 'F' && direction == [-1 0] #up to right 
            direction = [0 1]    
        elseif pipes[currentind[1], currentind[2]] == 'F' && direction == [0 -1] #left to down 
            direction = [1 0]
        end
        currentind += direction
        ispipe[currentind[1], currentind[2]] = true
        n += 1
    end
    println("total loop path is $n")

    ispipe[startind] = true
    pipes[startind] = start

    #ok this idea didn't work, because one batch of tiles can contian multiple crossings. Maybe best computing corssings using actual symbols?
    inloop = 0
    for row in 1:length(lines)
        for col in 1:size(pipes, 2)
            if ispipe[row, col]
                print(pipes[row, col])
                continue
            end
            # otherwise we have to compute crossings. This isn't quite as easy as counting tiles

            crossings = 0
            lastsec = '.'
            for (n, p) in enumerate(pipes[row, col:end])
                if !ispipe[row, col+n-1]
                    continue
                end
                
                if p == '|'
                    crossings += 1
                elseif p == 'F' || p == 'L' #leading into a pipe, we decide if it was a crossing when we leave
                    lastsec = p
                elseif p == 'J' && lastsec == 'F' #only a crossing if we came from 'F'
                    crossings += 1
                elseif p == '7' && lastsec == 'L' #only a crossing if it came from 'L'
                    crossings += 1
                end
            end

            if isodd(crossings)
                print('o')
                inloop += 1
            else
                print('.')
            end
        end
        print('\n')
    end

    println("\ntotal inside loop is $inloop")



end

#for part 2 I will create a matrix marking every point of the loop
#then i will simply do an exhaustive search on every tile to see if it crosses an odd number of loop points "

go()