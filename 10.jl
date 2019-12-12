function buildMap(filename)
    lines = readlines(filename)
    map = [i == '#' for i in lines[1]]'
    for line in lines[2:end]
        map = [map;[i == '#' for i in line]']
    end
    return map
end

map = buildMap("10.txt")

function countInSlopes(slopes,rows,cols,i,j,sweep)
    count = 0
    for slope in slopes
        for step in sweep
            if (((step * slope.num + i) > rows) || ((step * slope.den + j) > cols)) ||
                (((step * slope.num + i) < 1) || ((step * slope.den + j) < 1))
                break
            elseif map[step * slope.num + i,step * slope.den + j]
                count += 1
                break
            end
        end
    end
    return count
end

function destroyInSlopes(slopes,rows,cols,i,j,sweep,destroyed)
    for slope in slopes
        for step in sweep
            if (((step * slope.num + i) > rows) || ((step * slope.den + j) > cols)) ||
                (((step * slope.num + i) < 1) || ((step * slope.den + j) < 1))
                break
            elseif map[step * slope.num + i,step * slope.den + j]
                map[step * slope.num + i,step * slope.den + j] = false
                push!(destroyed,(step * slope.num + i,step * slope.den + j))
                #println("Destroy Asteroid at location $((step * slope.num + i,step * slope.den + j))")
                break
            end
        end
    end
end

function countVisableAsteroids(map,i,j)
    rows = size(map)[1]
    cols = size(map)[2]
    count = 0
    # Straight up
    count += any(map[1:i-1,j])
    # Quadrant I
    slopes = unique([((row-i)//(col-j)) for row in i-1:-1:1, col in j+1:cols])
    count += countInSlopes(slopes,rows,cols,i,j,1:cols-j)
    # Check right
    count += any(map[i,j+1:end])
    # Quadrant IV
    slopes = unique([((row-i)//(col-j)) for row in i+1:rows, col in j+1:cols])
    count += countInSlopes(slopes,rows,cols,i,j,1:cols-j)
    # Check down
    count += any(map[i+1:end,j])
    # Quadrant III
    slopes = unique([((row-i)//(col-j)) for row in i+1:rows, col in j-1:-1:1])
    count += countInSlopes(slopes,rows,cols,i,j,-1:-1:-j+1)
    # Check left
    count += any(map[i,1:j-1])
    # Quadrant II
    slopes = unique([((row-i)//(col-j)) for row in i-1:-1:1, col in j-1:-1:1])
    count += countInSlopes(slopes,rows,cols,i,j,-1:-1:-j+1)
    return count
end

function findBestLocation(map)
    bestCount = 0
    bestLocation = nothing
    for i in CartesianIndices(map)
        if map[i]
            i,j = i.I
            count = countVisableAsteroids(map,i,j)
            if count > bestCount
                bestCount = count
                bestLocation = (i,j)
            end
        end
    end
    return bestCount,bestLocation
end

@show findBestLocation(map)

function destroyVisableAsteroids!(map,i,j,destroyed=[])
    rows = size(map)[1]
    cols = size(map)[2]
    # Straight up
    location = findfirst(map[i-1:-1:1,j])
    if location != nothing # Found asterioid
        map[i-location,j] = false
        push!(destroyed,(i-location,j))
        #println("Destroyed asteroid at $((i-location,j))")
    end
    # Quadrant I
    slopes = sort(unique([((row-i)//(col-j)) for row in i-1:-1:1, col in j+1:cols]))
    destroyInSlopes(slopes,rows,cols,i,j,1:cols-j,destroyed)
    # Check right
    location = findfirst(map[i,j+1:end])
    if location != nothing # Found asterioid
        map[i,j+location] = false
        push!(destroyed,(i,j+location))
        #println("Destroyed asteroid at $((i,j+location))")
    end
    # Quadrant IV
    slopes = sort(unique([((row-i)//(col-j)) for row in i+1:rows, col in j+1:cols]))
    destroyInSlopes(slopes,rows,cols,i,j,1:cols-j,destroyed)
    # Check down
    count = findfirst(map[i+1:end,j])
    if location != nothing # Found asterioid
        map[i+location,j] = false
        push!(destroyed,(i+location,j))
        #println("Destroyed asteroid at $((i+location,j))")
    end
    # Quadrant III
    slopes = sort(unique([((row-i)//(col-j)) for row in i+1:rows, col in j-1:-1:1]))
    destroyInSlopes(slopes,rows,cols,i,j,-1:-1:-j+1,destroyed)
    # Check left
    count = findfirst(map[i,1:j-1])
    if location != nothing # Found asterioid
        map[i,j-location] = false
        push!(destroyed,(i,j-location))
        #println("Destroyed asteroid at $((i,j-location))")
    end
    # Quadrant II
    slopes = sort(unique([((row-i)//(col-j)) for row in i-1:-1:1, col in j-1:-1:1]))
    destroyInSlopes(slopes,rows,cols,i,j,-1:-1:-j+1,destroyed)
    return destroyed
end

map = buildMap("10.txt")
destroyed = destroyVisableAsteroids!(map,30,29)

@show ((destroyed[200][2]-1) * 100) + (destroyed[200][1]-1)