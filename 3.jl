wire1,wire2, = [split(x,',') for x in split(read("3.txt", String),'\n')]

function wireLocations(wire)
    lastLocation = [0,0]
    wireL = 0
    locations = Dict()
    for direction in wire
        update = nothing
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
            lastLocation = update(lastLocation)
            wireL += 1
            if !haskey(locations,lastLocation)
                locations[lastLocation] = wireL
            end
        end
    end
    return locations
end

locations1 = wireLocations(wire1)
locations2 = wireLocations(wire2)

intersections = keys(locations1) ∩ keys(locations2)

@show minimum([abs(x)+abs(y) for (x,y) in intersections]) # Part 1
@show minimum([locations1[key]+locations2[key] for key in intersections]) # Part 2