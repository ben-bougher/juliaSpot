## JULIASPOT ## The Julia Implementation of the Spot Linear Algebra Package

abstract opSpot

# Spot level functions

# size
function size(A::opSpot)
    return A.m,A.n
end

# length
function length(A::opSpot)
    return max(A.m,A.n)
end

# Multiplication frontend
function *(op::opSpot, x)
    return multiply(op,x,1)
end