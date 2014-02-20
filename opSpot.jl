## JULIASPOT ## The Julia Implementation of the Spot Linear Algebra Package

abstract opSpot

# Spot level functions

# Base.size
function Base.size(A::opSpot)
    return A.m,A.n
end

# Base.length
function Base.length(A::opSpot)
    return max(A.m,A.n)
end


##################################################
##### Multiplication frontend                #####
##################################################
#Both are opSpot
function *(op1::opSpot, op2::opSpot)
    return opFoG(op1,op2)
end

#Only one is opSpot
function *(op::opSpot, x)
    return opFoG(op,x)
end
function *(x,op::opSpot)
    return opFoG(op,x)
end

