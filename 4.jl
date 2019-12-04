# Brute Force Solution
function checkDigits1(d)
    # Digits ascend
    if !issorted(reverse(d))
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
    if !issorted(reverse(d))
        return false
    else
        i = length(d)
        repeatCount = 1
        while i >= 2
            if d[i] == d[i-1]
                repeatCount += 1
            elseif repeatCount == 2
                return true
            else
                repeatCount = 1
            end
            i -= 1
        end
        return repeatCount == 2
    end
end

function solve()
    countPart1 = 0
    countPart2 = 0
    for i in 125730:579381
        d = digits(i)
        checkDigits1(d) ? countPart1 += 1 : nothing
        checkDigits2(d) ? countPart2 += 1 : nothing
    end
    return countPart1,countPart2
end


@show solve()