#juliaSpot
=========

##The Julia implementation of the Spot Linear Algebra Package
Tested on julia<br />
-v0.2.0<br />
-v0.2.1<br />
-v0.3.0-prerelease

##To Start it:
1. cd to juliaSpot folder and start Julia
2. type in: require("startup.jl")<br />
Things should be loaded properly at this point

## To Use it:
####Example: Fourier Transform Operator

x = rand(10,1); # my data<br />
A = opDFT(10);  # the operator

A * x # Do Fourier transform on x