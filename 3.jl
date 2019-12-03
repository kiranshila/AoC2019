example = "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83"
example2 = "R8,U5,L5,D3\nU7,R6,D4,L4"
example3 = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7"


s = open("3.txt") do file
    input = read(file, String)
end

function part1(input)
    wireLocations = Dict()
    wires = split(input,'\n')
    for (wireIndex,wire) in enumerate(wires)
        if wire == ""
            continue
        end
        lastLocation = [0,0]
        update = nothing
        for direction in split(wire,',')
            if direction[1] == 'U'
                update = x->[x[1],x[2] + 1]
            elseif direction[1] == 'D'
                update = x->[x[1],x[2] - 1]
            elseif direction[1] == 'L'
                update = x->[x[1] - 1,x[2]]
            elseif direction[1] == 'R'
                update = x->[x[1] + 1,x[2]]
            end

            for i in 1:parse(Int,direction[2:end])
                nextLocation = update(lastLocation)
                if !haskey(wireLocations,nextLocation)
                    wireLocations[nextLocation] = [wireIndex]
                else
                    append!(wireLocations[nextLocation],wireIndex)
                end
                lastLocation = nextLocation
            end
        end
    end

    minDistance = Inf
    minPoint = nothing
    for (key,value) in wireLocations
        if length(unique(value)) > 1
            # Calculate manhattan distance
            distance = abs(key[1]) + abs(key[2])
            if distance < minDistance
                minDistance = distance
                minPoint = key
            end
        end
    end
    return minDistance,minPoint
end

function part2(input)
    wireLocations = Dict()
    wires = split(input,'\n')
    for (wireIndex,wire) in enumerate(wires)
        if wire == ""
            continue
        end
        lastLocation = [0,0]
        stepCounter = 0
        update = nothing
        for direction in split(wire,',')
            if direction[1] == 'U'
                update = x->[x[1],x[2] + 1]
            elseif direction[1] == 'D'
                update = x->[x[1],x[2] - 1]
            elseif direction[1] == 'L'
                update = x->[x[1] - 1,x[2]]
            elseif direction[1] == 'R'
                update = x->[x[1] + 1,x[2]]
            end

            for i in 1:parse(Int,direction[2:end])
                nextLocation = update(lastLocation)
                stepCounter += 1
                if !haskey(wireLocations,nextLocation)
                    wireLocations[nextLocation] = Dict(wireIndex => stepCounter)
                else
                    if !haskey(wireLocations[nextLocation],wireIndex)
                        wireLocations[nextLocation][wireIndex] = stepCounter
                    end
                end
                lastLocation = nextLocation
            end
        end
    end

    minDistance = Inf
    minPoint = nothing
    for (key,value) in wireLocations
        if length(value) > 1
            # Calculate step distance
            distance = value[1] + value[2]
            if distance < minDistance
                minDistance = distance
                minPoint = key
            end
        end
    end
    return minDistance,minPoint
end