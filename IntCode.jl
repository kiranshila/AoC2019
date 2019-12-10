using OffsetArrays

mutable struct IntCode
    relativeBase::Int
    RAM::OffsetArray
    intcodePointer::Int
    isRunning::Bool
    isComplete::Bool
end

function IntCode(x::String)
    RAM = OffsetArray([parse(Int64,i) for i in split(x,',')],-1)
    push!(RAM,zeros(Int,length(RAM)*10)...)
    IntCode(0,RAM,0,false,false)
end

function IntCode(x::Array{Int})
    RAM = OffsetArray(deepcopy(x),-1)
    push!(RAM,zeros(Int,length(RAM)*10)...)
    IntCode(0,RAM,0,false,false)
end

function get(program,mode,i)
    raw = program.RAM[i] # Raw value at position i
    if mode == 0 # Positional
        return program.RAM[raw]
    elseif mode == 1 # Immediate
        return raw
    elseif mode == 2 # Offset
        return program.RAM[raw + program.relativeBase]
    end
end

function set(program,mode,i,val)
    raw = program.RAM[i] # Raw value at position i
    if mode == 0 || mode == 1
        program.RAM[raw] = val
    elseif mode == 2
        program.RAM[raw+program.relativeBase] = val
    end
end

function runIntcode!(program::IntCode;input=[],output=[])
    program.isRunning = true
    while program.intcodePointer < length(program.RAM)
        # First is an instruction
        rawDigits = digits(program.RAM[program.intcodePointer],pad=5)
        opcode = rawDigits[1]+10*rawDigits[2]
        modes = rawDigits[3:end]
        if opcode == 1
            # add
            a = get(program,modes[1],program.intcodePointer+1)
            b = get(program,modes[2],program.intcodePointer+2)
            set(program,modes[3],program.intcodePointer+3,a+b)
            program.intcodePointer += 4
        elseif opcode == 2
            # mul
            a = get(program,modes[1],program.intcodePointer+1)
            b = get(program,modes[2],program.intcodePointer+2)
            set(program,modes[3],program.intcodePointer+3,a*b)
            program.intcodePointer += 4
        elseif opcode == 3
            # read
            if isempty(input)
                program.isRunning = false
                return # Waiting for next input
            end
            set(program,modes[1],program.intcodePointer+1,pop!(input))
            program.intcodePointer += 2
        elseif opcode == 4
            # write
            pushfirst!(output, get(program,modes[1],program.intcodePointer+1))
            program.intcodePointer += 2
        elseif opcode == 5
            # jmp-if-true
            a = get(program,modes[1],program.intcodePointer+1)
            b = get(program,modes[2],program.intcodePointer+2)
            a != 0 ? program.intcodePointer = b : program.intcodePointer += 3
        elseif opcode == 6
            # jmp-if-false
            a = get(program,modes[1],program.intcodePointer+1)
            b = get(program,modes[2],program.intcodePointer+2)
            a == 0 ? program.intcodePointer = b : program.intcodePointer += 3
        elseif opcode == 7
            # less
            a = get(program,modes[1],program.intcodePointer+1)
            b = get(program,modes[2],program.intcodePointer+2)
            set(program,modes[3],program.intcodePointer+3,Int(a<b))
            program.intcodePointer += 4
        elseif opcode == 8
            # eql
            a = get(program,modes[1],program.intcodePointer+1)
            b = get(program,modes[2],program.intcodePointer+2)
            set(program,modes[3],program.intcodePointer+3,Int(a==b))
            program.intcodePointer += 4
        elseif opcode == 9
            # change relative relativeBase
            program.relativeBase += get(program,modes[1],program.intcodePointer+1)
            program.intcodePointer += 2
        elseif opcode == 99
            # exit
            program.isComplete = true
            break
        else
            println("Invalid Intcode at position $(program.intcodePointer)")
            program.isRunning = false
            return -99
        end
    end
    program.isComplete = true
    program.isRunning = false
    return -1
end