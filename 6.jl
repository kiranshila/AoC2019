mutable struct CelestialObject
    name::String
    orbits::Union{CelestialObject,Nothing}
    satellites::Vector{CelestialObject}
end

CelestialObject(name::AbstractString) = CelestialObject(name,nothing,[])


function buildOrbits(orbitString)
    allObjects = Dict{String,CelestialObject}()
    for line in split(orbitString,'\n')
        orbits,thing = split(line,')')
        if !haskey(allObjects,thing)
            allObjects[thing] = CelestialObject(thing)
        end
        if !haskey(allObjects,orbits)
            allObjects[orbits] = CelestialObject(orbits)
        end
        allObjects[thing].orbits = allObjects[orbits]
        append!(allObjects[orbits].satellites,[allObjects[thing]])
    end
    return allObjects
end

function countOrbits(object::CelestialObject;stop=nothing)
    if object.orbits === stop
        return 0
    else
        return 1 + countOrbits(object.orbits;stop=stop)
    end
end

function listParents(object::CelestialObject)
    if object.orbits === nothing
        return []
    else
        return [object.orbits.name, listParents(object.orbits)...]
    end
end

part1(objects) = sum([countOrbits(object) for object in values(objects)])

allObjects = buildOrbits(read("6.txt",String))
@show part1(allObjects)

function part2(objects)
    # Find closest shared parent and count distance
    sharedParentName = (listParents(objects["SAN"]) ∩ listParents(objects["YOU"]))[1]
    return countOrbits(objects["SAN"],stop=objects[sharedParentName]) +
           countOrbits(objects["YOU"],stop=objects[sharedParentName])
end

@show part2(allObjects)