# Loading all spot class files contained within this directory
load("spot.jl")

for file in readlines(`find . -name *.jl`)
    if chomp(file) != "./startup.jl" && chomp(file) != "./spot.jl"
        load(chomp(file))
    end
end