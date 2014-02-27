# Test all the spot operators
using Base.Test
# How to use this: 
# 	in command-line (outside of julia), type: "julia testJSpot.jl"
#


# ----- load julia spot ------------------
println("loading spot")
require("startup.jl")
println("\n")


# ==================== Tests Start ====================

##### test opMatrix #####

# make operator
a = rand(3,5)
A = opMatrix(a)

# make vector
x1 = rand(5,1) # 1-D
x2 = rand(5,2) # 2-D

println("====================")
println("===== opMatrix =====")
println("====================")

println("opMatrix : double");
@test double(A)==a

println("opMatrix : multiply vector(1 vector)");
@test A*x1 == a*x1;

println("opMatrix : multiply vector(2 vectors)");
@test A*x2 == a*x2;

println("\n")


##### test opCTranspose #####

# make operator
a = rand(3,5) + im * rand(3,5)
A = opMatrix(a)'

# make vector
x1 = rand(3,1) # 1-D
x2 = rand(3,2) # 2-D

println("====================")
println("=== opCTranspose ===")
println("====================")

println("opCTranspose : double");
@test double(A)==a'

println("opCTranspose : multiply vector(1 vector)");
@test A*x1 == a'*x1;

println("opCTranspose : multiply vector(2 vectors)");
@test A*x2 == a'*x2;

println("\n")

##### test opTranspose #####

# make operator
a = rand(3,5) + im * rand(3,5)
A = transpose(opMatrix(a))

# make vector
x1 = rand(3,1) # 1-D
x2 = rand(3,2) # 2-D

println("====================")
println("=== opTranspose ===")
println("====================")

println("opTranspose : double");
@test double(A)==transpose(a)

println("opTranspose : multiply vector(1 vector)");
@test length(find(abs(real(A*x1 - transpose(a)*x1)) .> 0.0000001)) == 0 #almost equal
@test length(find(abs(imag(A*x1 - transpose(a)*x1)) .> 0.0000001)) == 0 #almost equal

println("opTranspose : multiply vector(2 vectors)");
@test length(find(abs(real(A*x2 - transpose(a)*x2)) .> 0.0000001)) == 0 #almost equal
@test length(find(abs(imag(A*x2 - transpose(a)*x2)) .> 0.0000001)) == 0 #almost equal

println("\n")

##### test opFoG #####

# make operator
a = rand(3,5)
A = opMatrix(a)
b = rand(5,7)
B = opMatrix(b)

c = a * b
C = A * B

# make vector
x1 = rand(7,1) # 1-D
x2 = rand(7,2) # 2-D

println("====================")
println("====== opFoG =======")
println("====================")

println("opFoG : double");
@test double(C)==c

println("opFoG : multiply vector(1 vector)");
@test length(find(abs((C*x1 - c*x1) .> 0.0000001))) == 0 #almost equal


println("opFoG : multiply vector(2 vectors)");
@test length(find(abs((C*x2 - c*x2) .> 0.0000001))) == 0 #almost equal

println("\n")


##### test opKron #####

# make operator
A = opKron(rand(3,7),rand(5,11))

# make vector
x = rand(77,1) # 1-D

println("====================")
println("====== opKron ======")
println("====================")

println("opKron : double");
double(A);

println("opKron : multiply vector(1 vector)");
@test length(find(abs((double(A)*x - A * x)) .> 0.0000001))== 0 #almost equal


println("\n")





println("All Tests Done!")
