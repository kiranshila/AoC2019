include("IntCode.jl")

data = [parse(Int64,i) for i in split(readline("5.txt"),',')]

# Part 1
program = IntCode(data)
input = [1]
output = []
runIntcode!(program,input=input,output=output)
@show output

# Part 2
program = IntCode(data)
input = [5]
output = []
runIntcode!(program,input=input,output=output)
@show output