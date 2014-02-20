# Loading all spot class files contained within this directory
include("opSpot.jl")

for file in readlines(`find . -name *.jl`)
    if chomp(file) != "./startup.jl" && chomp(file) != "./opSpot.jl"
        println(chomp(file))
        include(chomp(file))
    end
end