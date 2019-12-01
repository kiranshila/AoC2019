function fuelRequirement1(mass)
    return floor(mass / 3) - 2
end

@show sum([fuelRequirement1(parse(Float64,i)) for i in readlines("input1.txt")])

function fuelRequirement2(mass)
    requirement = floor(mass / 3) - 2
    requirement <= 0 ? 0 : requirement + fuelRequirement(requirement)
end

@show sum([fuelRequirement2(parse(Float64,i)) for i in readlines("input1.txt")])
