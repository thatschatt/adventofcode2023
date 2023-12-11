
function parseinput(filename)
    #lines = readlines("test11.txt")
    lines = readlines("input11.txt")
 
    starmap = reduce(vcat, permutedims.(collect.(lines))) #shamelessly stolen from stackexchange
    stars = (findall(x -> x == '#', starmap))
    
    return starmap, stars
end

function go()
    emptyrows = setdiff(1:size(starmap, 1), getindex.(stars, 1))
    emptycols = setdiff(1:size(starmap, 2), getindex.(stars, 2))
    @show emptyrows
    @show emptycols

    totaldist = 0
    for (n, star1) in enumerate(stars)
        for (m, star2) in enumerate(stars[n+1:end])
            v = min(star1[1], star2[1]):max(star1[1], star2[1])
            v_empty = length(intersect(emptyrows, v))

            h = min(star1[2], star2[2]):max(star1[2], star2[2])
            h_empty = length(intersect(emptycols, h))


       #     println("star $star1 with star $star2: $(length(v) + length(h) + v_empty + h_empty - 2)")
            totaldist += length(v) + length(h) + v_empty*999_999 + h_empty*999_999 - 2
   #         @show v
   #         @show h
   #         @show v_empty
   #         @show h_empty
   #         @show emptycols
        end
    end
    @show totaldist

    #first find every empty row and column
end

starmap, stars = parseinput("input11.txt")
go()