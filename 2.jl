using OffsetArrays

# Part 1
program = OffsetArray([parse(Int64,i) for i in split(readline("2.txt"),',')],-1)
program[1] = 12
program[2] = 2
function runIntcode!(program,offset=0)
    # Step 1 - Get opcode
    opcode = program[offset]
    if opcode == 1
        # Add routine
        program[program[offset+3]] = program[program[offset+1]] + program[program[offset+2]]
    elseif opcode == 2
        # Multiply routine
        program[program[offset+3]] = program[program[offset+1]] * program[program[offset+2]]
    elseif opcode == 99
        return program[0]
    end
    runIntcode!(program,offset+4)
end

@show runIntcode!(program)

# Part 2
function matchTarget(target)
    for i in 0:99, j in 0:99
        program = OffsetArray([parse(Int64,i) for i in split(readline("2.txt"),',')],-1)
        program[1] = i
        program[2] = j
        if runIntcode!(program) == target
            println("Got $(100 * i + j)")
        end
    end
end

matchTarget(19690720)

