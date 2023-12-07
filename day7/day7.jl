using Scanf
using StatsBase

function parsefile(filename)
    lines = readlines(filename)
    cards = Array{Char}(undef, length(lines), 5)
    bids = Array{Int}(undef, length(lines))
    for (n, line) in enumerate(lines)
        _, c, bids[n] = @scanf(line, "%s %d", String, Int)
        cards[n, :] = collect(c)
    end
    return cards, bids
end

function gethand(cards)
    # return the hand type (1=high card, 7=5 of a kind)
    uniq = unique(cards)
    if length(uniq) == 1 #5-of-a-kind
        return 7
    elseif length(uniq) == 2 #either 4-oak or full house
        if sum(uniq[1] .== cards) == 4 || sum(uniq[1] .== cards) == 1 #4oak
            return 6
        else
            return 5
        end
    elseif length(uniq) == 3 #3oak or 2 pair
        if sum(cards .== mode(cards)) == 3 #3oak
            return 4
        else
            return 3
        end
    elseif length(uniq) == 4
        return 2
    else
        return 1
    end
end

function gethandwithjoker(initcards)
    # return the hand type (1=high card, 7=5 of a kind)

    #hack to remove jokers
    cards = copy(initcards)
    for (n, c) in enumerate(initcards)
        if cards[n] == 'J'
            cards[n] = '!' + n
        end
    end

  #  cards = initcards[initcards .!= 'J']
    uniq = unique(cards)
    if length(uniq) == 1 && length(cards) == 5 #5-of-a-kind
        return 7
    elseif length(uniq) == 2 #either 4-oak or full house
        if sum(uniq[1] .== cards) == 4 || sum(uniq[1] .== cards) == 1 #4oak
            return 6
        else
            return 5
        end
    elseif length(uniq) == 3 #3oak or 2 pair
        if sum(cards .== mode(cards)) == 3 #3oak
            return 4
        else
            return 3
        end
    elseif length(uniq) == 4
        return 2
    else
        return 1
    end
end

#function comparehands(hand1::Array{Char}, hand2::Array{Char})
function comparehands(hand1, hand2)
   
    s1 = gethand(hand1)
    s2 = gethand(hand2)
   # println("hand1 = $s1, hand2 = $s2")
    if s1 != s2
        return s1 < s2
    end
    for n in 1:5
        if cardscore[hand1[n]] < cardscore[hand2[n]]
            return true
        elseif cardscore[hand1[n]] > cardscore[hand2[n]]
            return false
        end
    end
end

function comparehandswithjoker(hand1, hand2)

    jokerpromotion = [
        #   1J  2J  3J  4J  5J   
            2   4   6   7   7   # 1 HC 
            4   6   7   2   7   # 2 1p 
            5   3   3   3   7   # 3 2p
            6   7   4   4   7   # 4 3oak
            5   5   5   5   7   # 5 FH
            7   6   6   6   7   # 6 4oak
            7   7   7   7   7   # 7 5oak
    ] #love me a promotion matrix
   
    s1 = gethandwithjoker(hand1)
    nj = sum(hand1 .== 'J')
    if nj > 0
        s1 = jokerpromotion[s1, nj]
    end
    println("$hand1; nj= $nj, score= $s1")

    s2 = gethandwithjoker(hand2)
    nj = sum(hand2 .== 'J')
    if nj > 0
        s2 = jokerpromotion[s2, nj]
    end
    println("$hand2; nj= $nj, score= $s2")

   # println("hand1 = $s1, hand2 = $s2")
    if s1 != s2
        return s1 < s2
    end
    for n in 1:5
        if cardscoreJ[hand1[n]] < cardscoreJ[hand2[n]]
            return true
        elseif cardscoreJ[hand1[n]] > cardscoreJ[hand2[n]]
            return false
        end
    end
end

cards, bids = parsefile("input7.txt")

for c in eachslice(cards, dims=1)
    comparehandswithjoker(c, cards[1,:])
end

global cardscore =  Dict('A' => 14, 'K' => 13, 'Q' => 12, 'J' => 11, 'T' => 10)
[cardscore[Char('0' + n)] = n for n in 2:10]
global cardscoreJ = cardscore
cardscoreJ['J'] = 1

rankings = sortperm(eachslice(cards, dims=1), lt=comparehands)
totalwinnings = sum(bids[rankings] .* (1:length(rankings)))
println("part 1 = $totalwinnings")

rankings = sortperm(eachslice(cards, dims=1), lt=comparehandswithjoker)
totalwinnings = sum(bids[rankings] .* (1:length(rankings)))
println("part 2 = $totalwinnings")
