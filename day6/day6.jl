#no point in parsing an input this simple

t_test = [7, 15, 30]
R_test = [9, 40, 200]

t_inp = [61, 67, 75, 71]
R_inp = [430, 1036, 1307, 1150]

ts = t_test
Rs = R_test

ts = t_inp
Rs = R_inp

function getbounds(t, R)
    #this is just a quaratic equation
    return [ceil((-t + sqrt(t^2 - R*4))/(-2) + 1e-9), 
            floor((-t - sqrt(t^2 - R*4))/(-2) - 1e-9)] #if any race is with 1e-9, expect failure
end

println(prod([(1+diff(getbounds(t, R))[1]) for (t, R) in zip(t_test, R_test)]))
println(prod([(1+diff(getbounds(t, R))[1]) for (t, R) in zip(t_inp, R_inp)]))

#and now for the trivial part two:
println(diff(Int.(getbounds(71530, 940200)))[1]+1)
println(diff(Int.(getbounds(61_67_75_71, 430_1036_1307_1150)))[1]+1)