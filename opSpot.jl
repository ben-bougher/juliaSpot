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

function transpose(op::opSpot)
	return opTranspose(op)
end

function ctranspose(op::opSpot)
	return opCTranspose(op)
end

function applyMultiply(op::opSpot,x,mode)
	
	# TODO: op.counter.plus1(mode)
	
	# For border case: empty x
	if isempty(x)
		if mode == 1
			return zeros(op.m,0)
		else
			return zeros(op.n,0)
		end
	end
	
	if op.sweepflag
		y = op.multiply(x,mode);
	else
		x_n = size(x,2);
		if x_n == 1
			y = op.multiply(x,mode);
		else
		for i=x_n:-1:1
			y[:,i] = op.multiply(x[:,i],mode);
		end
	end
	return y
end #endof applyMultiply




end #endof opSpot

