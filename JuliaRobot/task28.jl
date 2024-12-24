function fib(n)
    a = 0
    b = 1
    for _ in 2:n 
        b += a
        a = b - a 
    end
    return a
end
function fibRec(n)
    if n <= 2
        return n-1
    end
    return fibRec(n-1)+fibRec(n-2)
end
fibs = [0, 1]
function fibRecCache(n)
    if lastindex(fibs) < n
        for _ in lastindex(fibs)+1:n 
            append!(fibs, fibs[end]+fibs[end-1])
        end
    end
    return fibs[n]
end
for i in 1:20
    print(fib(i))
    print("\n")
end