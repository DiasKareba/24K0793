function sumRec(vect)
    if lastindex(vect) == 1
        return vect[1]
    end
    return vect[1] + sumRec(sub[2:end])
end
sum([1,2,3,4])