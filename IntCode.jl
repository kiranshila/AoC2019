using OffsetArrays

struct instruction
    opcode::Int
    mode::Array{Int}
end

function instruction(x::Int)
    d = digits(x,pad=5)
    instruction(d[1]+10*d[2],d[3:end])
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

function runIntcode!(program::OffsetArray,input,output,i = 0)
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
            if isempty(input)
                return i # Waiting for next input
            end
            program[program[i+1]] = pop!(input)
            i += 2
        elseif inst.opcode == 4
            # write
            pushfirst!(output, vals(program,inst,i))
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
            println("Invalid Intcode at position $i with instruction $inst")
            return -99
            break
        end
    end
    return -1
end