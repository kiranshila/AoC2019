# Part 1
program = [parse(Int64,i) for i in split(readline("2.txt"),',')]
program[2] = 12
program[3] = 2
function runIntcode!(program,offset=1)
    # Step 1 - Get opcode
    opcode = program[offset]
    if opcode == 1
        # Add routine
        program[program[offset+3]+1] = program[program[offset+1]+1] + program[program[offset+2]+1]
    elseif opcode == 2
        # Multiply routine
        program[program[offset+3]+1] = program[program[offset+1]+1] * program[program[offset+2]+1]
    elseif opcode == 99
        return program[1]
    end
    runIntcode!(program,offset+4)
end

@show runIntcode!(program)

# Part 2
function matchTarget(target)
    for i in 0:99, j in 0:99
        program = [parse(Int64,i) for i in split(readline("2.txt"),',')]
        program[2] = i
        program[3] = j
        if runIntcode!(program) == target
            println("Got $(100 * i + j)")
        end
    end
end

matchTarget(19690720)

