include("IntCode.jl")
using Combinatorics

program = OffsetArray([parse(Int64,i) for i in split(readline("7.txt"),',')],-1)

function maximizeThrust(program)
    program = deepcopy(program)
    bestThrust = -Inf
    bestPhase = []
    for phases in permutations(0:4)
        output = Int[]
        A,B,C,D,E = [deepcopy(program) for _ in 1:5]
        runIntcode!(A,[0,phases[1]],output)
        runIntcode!(B,[output[1],phases[2]],output)
        runIntcode!(C,[output[1],phases[3]],output)
        runIntcode!(D,[output[1],phases[4]],output)
        runIntcode!(E,[output[1],phases[5]],output)
        if output[1] > bestThrust
            bestThrust = output[1]
            bestPhase = phases
        end
    end
    return bestThrust,bestPhase
end

@show maximizeThrust(program)

function maximizeFeedbackThrust(program)
    program = deepcopy(program)
    bestThrust = -Inf
    bestPhase = []
    for phases in permutations(5:9)
        input = 0
        A,B,C,D,E = [deepcopy(program) for _ in 1:5]

        lastI = fill(0,5)
        inputs = fill(Int[],5)
        outputs = fill(Int[],5)

        # Wire inputs to outputs
        inputs[1] = outputs[5] = [0, phases[1]]
        inputs[2] = outputs[1] = [phases[2]]
        inputs[3] = outputs[2] = [phases[3]]
        inputs[4] = outputs[3] = [phases[4]]
        inputs[5] = outputs[4] = [phases[5]]

        # Run until completion
        while all(i->i != -1, lastI)
            lastI[1] = runIntcode!(A,inputs[1],outputs[1],lastI[1])
            lastI[2] = runIntcode!(B,inputs[2],outputs[2],lastI[2])
            lastI[3] = runIntcode!(C,inputs[3],outputs[3],lastI[3])
            lastI[4] = runIntcode!(D,inputs[4],outputs[4],lastI[4])
            lastI[5] = runIntcode!(E,inputs[5],outputs[5],lastI[5])
        end

        if outputs[5][1] > bestThrust
            bestThrust = outputs[5][1]
            bestPhase = phases
        end
    end
    return bestThrust,bestPhase
end

@show maximizeFeedbackThrust(program)