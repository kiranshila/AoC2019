using BenchmarkTools

wire1,wire2, = [split(x,',') for x in split(read("3.txt", String),'\n')]
movements = Dict('U'=> 1im, 'D'=>-1im, 'L'=>-1, 'R'=>1)

function wireLocations(wire)
    lastLocation = 0 + 0im
    wireL = 0
    locations = Dict()
    for direction in wire
        for _ in 1:parse(Int,direction[2:end])
            lastLocation += movements[direction[1]]
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

@show minimum([abs(real(position))+abs(imag(position)) for position in intersections]) # Part 1
@show minimum([locations1[key]+locations2[key] for key in intersections]) # Part 2