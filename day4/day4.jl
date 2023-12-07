using Scanf

function go(filename)
    lines = readlines(filename)
    totalscore = 0
    for line in lines
        cardn, cards = split(line, ':')
        wins, scratchs = split(cards, '|')
        display(wins)
        display(scratchs)


        winners = parse.(Int, split(wins))
        scratch = parse.(Int, split(scratchs))

        winningnos = length(intersect(winners, scratch))
      #  display(winners)
      #  display(scratch)
      #  println(intersect(winners, scratch))
      score = (winningnos != 0) ? 2^(winningnos-1) : 0
      println("winners: $winningnos, score = $score")
        totalscore += score
    end
    display(totalscore)

end

struct card
    n::Int
    winners::Array{Int}
    scratch::Array{Int}
    winningnos::Int
end

function go2(filename)
    # strategy this time is to creat a card struct, then read everything in
    # we then create an array of pointers to cards, initally just with 1:N,
    # and then filled up with more as we go

    lines = readlines(filename)
    cards = Vector{card}()
    for line in lines
        cardn, cardstr = split(line, ':')
        wins, scratchs = split(cardstr, '|')

        n = parse(Int, split(cardn)[2])
        winners = parse.(Int, split(wins))
        scratch = parse.(Int, split(scratchs))
        winningnos = length(intersect(winners, scratch))
        push!(cards, card(n, winners, scratch, winningnos))
    end
    display(cards)

    mycards = collect(1:length(cards)) #we start with one of each card
    for cardn in mycards
        winningnos = cards[cardn].winningnos
        for i in 1:winningnos
            push!(mycards, cardn+i)
        end
    # score = (winningnos != 0) ? 2^(winningnos-1) : 0
    # println("card no: $cardn, winners: $winningnos, score = $score")   
    end
    println("total cards = $(length(mycards))")
end


go2("input4.txt")
