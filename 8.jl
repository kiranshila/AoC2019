using Plots
using LinearAlgebra

imageSize = (25,6)
pixelsPerLayer = imageSize[1]*imageSize[2]

s = readline("8.txt")
pixels = [parse(Int,s[i]) for i in 1:length(s)]
layers = [reshape(layer,imageSize) for layer in collect(Iterators.partition(pixels,pixelsPerLayer))]

# Part 1
minZeros,minLayer = findmin([count(i->i==0,layer) for layer in layers])
@show count(i->i==1,layers[minLayer]) * count(i->i==2,layers[minLayer])

# Part 2
result = zeros(Int,imageSize)
for i in 1:imageSize[1], j in 1:imageSize[2]
    # Traverse down layers
    for k in 1:length(layers)
        if layers[k][i,j] == 2 # Transparent
            continue
        elseif layers[k][i,j] == 0 # Black 
            result[i,j] = 0
            break
        elseif layers[k][i,j] == 1 # White
            result[i,j] = 1
            break
        end
    end
end

heatmap(result',aspect_ratio=:equal,yflip=true)
