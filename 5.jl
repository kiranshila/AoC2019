using OffsetArrays

struct instruction
    opcode::Int
    mode::Array{Int}
end

function instruction(x::Int)
    d = digits(x,pad=5)
    instruction(d[1]+10*d[2],d[3:end])
end

# Not in base yet
function input(prompt::String="")::String
    print(prompt)
    return chomp(readline())
end

value(program::OffsetArray,input,mode) = if mode == 1 return input else return program[input] end

function runIntcode!(program::OffsetArray)
    i = 0
    while i < length(program)
        # First is an instruction
        inst = instruction(program[i])
        if inst.opcode == 1
            # add - two inputs and an output
            a = value(program,program[i+1],inst.mode[1])
            b = value(program,program[i+2],inst.mode[2])
            program[program[i+3]] = a + b
            # Move PC
            i += 4
        elseif inst.opcode == 2
            # mul - two inputs and an output
            a = value(program,program[i+1],inst.mode[1])
            b = value(program,program[i+2],inst.mode[2])
            program[program[i+3]] = a * b
            # Move PC
            i += 4
        elseif inst.opcode == 3
            # read
            program[program[i+1]] = parse(Int,input("Input: "))
            i += 2
        elseif inst.opcode == 4
            # write
            println("Output: $(value(program,program[i+1],inst.mode[1]))")
            i += 2
        elseif inst.opcode == 5
            # jmp-if-true
            if value(program,program[i+1],inst.mode[1]) != 0
                i = value(program,program[i+2],inst.mode[2])
            else
                # Move the PC
                i += 3
            end
        elseif inst.opcode == 6
            # jmp-if-false
            if value(program,program[i+1],inst.mode[1]) == 0
                i = value(program,program[i+2],inst.mode[2])
            else
                # Move the PC
                i += 3
            end
        elseif inst.opcode == 7
            # less
            if value(program,program[i+1],inst.mode[1]) < value(program,program[i+2],inst.mode[2])
                program[program[i+3]] = 1
            else
                program[program[i+3]] = 0
            end
            # Move the PC
            i += 4
        elseif inst.opcode == 8
            # less
            if value(program,program[i+1],inst.mode[1]) == value(program,program[i+2],inst.mode[2])
                program[program[i+3]] = 1
            else
                program[program[i+3]] = 0
            end
            # Move the PC
            i += 4
        elseif inst.opcode == 99
            # exit
            break
        else
            print("Invalid Intcode")
            break
        end
    end
    println("Program Complete")
end

program = OffsetArray([parse(Int64,i) for i in split(readline("5.txt"),',')],-1)

runIntcode!(program)