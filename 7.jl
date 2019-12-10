include("IntCode.jl")
using Combinatorics

data = [parse(Int64,i) for i in split(readline("7.txt"),',')]
program = IntCode(data)

function maximizeThrust(program)
    program = deepcopy(program)
    bestThrust = -Inf
    bestPhase = []
    for phases in permutations(0:4)
        output = Int[]
        A,B,C,D,E = [deepcopy(program) for _ in 1:5]
        runIntcode!(A,input = [0,phases[1]], output = output)
        runIntcode!(B,input = [output[1],phases[2]], output = output)
        runIntcode!(C,input = [output[1],phases[3]], output = output)
        runIntcode!(D,input = [output[1],phases[4]], output = output)
        runIntcode!(E,input = [output[1],phases[5]], output = output)
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

        inputs = fill(Int[],5)
        outputs = fill(Int[],5)

        # Wire inputs to outputs
        inputs[1] = outputs[5] = [0, phases[1]]
        inputs[2] = outputs[1] = [phases[2]]
        inputs[3] = outputs[2] = [phases[3]]
        inputs[4] = outputs[3] = [phases[4]]
        inputs[5] = outputs[4] = [phases[5]]

        # Run until completion
        while !all(i->i.isComplete,[A,B,C,D,E])
            runIntcode!(A,input = inputs[1],output = outputs[1])
            runIntcode!(B,input = inputs[2],output = outputs[2])
            runIntcode!(C,input = inputs[3],output = outputs[3])
            runIntcode!(D,input = inputs[4],output = outputs[4])
            runIntcode!(E,input = inputs[5],output = outputs[5])
        end

        if outputs[5][1] > bestThrust
            bestThrust = outputs[5][1]
            bestPhase = phases
        end
    end
    return bestThrust,bestPhase
end

@show maximizeFeedbackThrust(program)