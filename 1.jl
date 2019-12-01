function fuelRequirement1(mass)
    return floor(mass / 3) - 2
end

@show result = sum([fuelRequirement1(parse(Float64,i)) for i in readlines("input1.txt")])

function fuelRequirement2(mass)
    requirement = floor(mass / 3) - 2
    if requirement <= 0
        return 0
    else
        return requirement + fuelRequirement(requirement)
    end
end

@show result = sum([fuelRequirement2(parse(Float64,i)) for i in readlines("input1.txt")])
