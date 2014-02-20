#juliaSpot
=========

##The Julia implementation of the Spot Linear Algebra Package

##To Start it:
1. Start Julia
2. type in: require("startup.jl")
Things should be loaded properly at this point

## To Use it:
example - opMatrix and opFoG:

A = opMatrix(rand(2,3)) # creates a 2x3 random matrix wrapped in opMatrix
B = opMatrix(rand(3,5)) # creates a 2x3 random matrix wrapped in opMatrix

C = A * B				# creates a 2x5 opFoG containing A and B as children

double(C)				# display the value of the C matrix