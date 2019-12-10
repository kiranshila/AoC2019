include("IntCode.jl")

# Part 1
data = [parse(Int64,i) for i in split(readline("2.txt"),',')]
data[2] = 12
data[3] = 2
program = IntCode(data)
runIntcode!(program)
@show program.RAM[0]

# Part 2
function matchTarget(target)
    for i in 0:99, j in 0:99
        data = [parse(Int64,i) for i in split(readline("2.txt"),',')]
        data[2] = i
        data[3] = j
        program = IntCode(data)
        runIntcode!(program)
        if program.RAM[0] == target
            println("Got $(100 * i + j)")
        end
    end
end

matchTarget(19690720)

