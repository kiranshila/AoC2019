# Brute Force Solution
function isackwardsorted(x) # Base.issorted was really slow for some reason?
    for i in 1:length(x)-1
        if x[i] < x[i+1]
            return false
        end
    end
    return true
end

function checkDigits1(d)
    # Digits ascend
    if !isackwardsorted(d)
        return false
    else
        for i in 1:length(d)-1
            if d[i] == d[i+1]
                return true
            end
        end
        return false
    end
end

function checkDigits2(d)
    # Digits ascend
    if !isackwardsorted(d)
        return false
    else
        repeatCount = 1
        for i in length(d):-1:2
            if d[i] == d[i-1]
                repeatCount += 1
            elseif repeatCount == 2
                return true
            else
                repeatCount = 1
            end
        end
        return repeatCount == 2
    end
end

part1(range) = sum(@. checkDigits1(digits(range)))
part2(range) = sum(@. checkDigits2(digits(range)))

@show part1(125730:579381)
@show part2(125730:579381)