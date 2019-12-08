using OffsetArrays

struct instruction
    opcode::Int
    mode::Array{Int}
end

function instruction(x::Int)
    d = digits(x,pad=5)
    instruction(d[1]+10*d[2],d[3:end])
end

# Not in base yet - Just to make input nice
function input(prompt::String="")::String
    print(prompt)
    return chomp(readline())
end

function value(program::OffsetArray,input,mode) 
    if mode == 1 # Immediate
        return input 
    elseif mode == 0 # Position
        return program[input] 
    end
end

function vals(program,inst,i)
    # This will determine how many parameters to take
    if inst.opcode in [1,2,5,6,7,8]
        a = value(program,program[i+1],inst.mode[1])
        b = value(program,program[i+2],inst.mode[2])
        return a,b
    elseif inst.opcode in [4]
        return value(program,program[i+1],inst.mode[1])
    end
end


function runIntcode!(program::OffsetArray,i = 0)
    output = []
    while i < length(program)
        # First is an instruction
        inst = instruction(program[i])
        if inst.opcode == 1
            # add
            program[program[i+3]] = +(vals(program,inst,i)...)
            i += 4
        elseif inst.opcode == 2
            # mul
            program[program[i+3]] = *(vals(program,inst,i)...)
            i += 4
        elseif inst.opcode == 3
            # read
            if length(args) == 0
                program[program[i+1]] = parse(Int,input("Input: "))
            else
                program[program[i+1]] = args[argPointer]
                argPointer += 1
            end
            i += 2
        elseif inst.opcode == 4
            # write
            if length(args) == 0
                println("Output: $(vals(program,inst,i))")
            else
                append!(output,vals(program,inst,i))
            end
            i += 2
        elseif inst.opcode == 5
            # jmp-if-true
            a,b = vals(program,inst,i)
            a != 0 ? i = b : i += 3
        elseif inst.opcode == 6
            # jmp-if-false
            a,b = vals(program,inst,i)
            a == 0 ? i = b : i += 3
        elseif inst.opcode == 7
            # less
            program[program[i+3]] = Int(<(vals(program,inst,i)...))
            i += 4
        elseif inst.opcode == 8
            # eql
            program[program[i+3]] = Int(==(vals(program,inst,i)...))
            i += 4
        elseif inst.opcode == 99
            # exit
            break
        else
            print("Invalid Intcode")
            break
        end
    end
    return output
end

#program = OffsetArray([parse(Int64,i) for i in split(readline("5.txt"),',')],-1)

#runIntcode!(program)