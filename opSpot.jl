## JULIASPOT ## The Julia Implementation of the Spot Linear Algebra Package

abstract opSpot

# Spot level functions

# Base.size
function Base.size(A::opSpot)
    return A.m,A.n
end
function Base.size(A::opSpot,ind::Int64)
    if ind==1
		return A.m
	elseif ind==2
		return A.n
	else
		throw(ArgumentError("invalid index"))
	end
end

# Base.length
function Base.length(A::opSpot)
    return max(A.m,A.n)
end


##### Multiplication #########################
#Both are opSpot
function *(op1::opSpot, op2::opSpot)
    return opFoG(op1,op2)
end

#Only first one is spot
function *(op::opSpot, x)
    p = length(x)
	if p > 1 # if p is not scalar
		p = size(x,1)
	end
	
	if length(x)==1 && op.n != 1
		return opFoG(op,x)
	elseif op.n !=p && !isscalar(op)
		throw(ArgumentError("Dimension must agree"))
	else
		if length(op)==0 # if it's empty
			return zeros(op.m,size(x,2))
		elseif length(x)==0
			return zeros(op.m,0)
		else
			return applyMultiply(op,x,1)
		end
	end
end

# Only second one is spot
function *(x,op::opSpot)
    if length(x)==1 && op.m != 1
		return opFoG(x,op)
	else
		return (x' * op')'
	end
end

# other functions
function isscalar(x)
	return length(x)==1
end


##### Transpose and CTranspose #########################
function transpose(op::opSpot)
	return opTranspose(op)
end

function ctranspose(op::opSpot)
	return opCTranspose(op)
end

##### double #########################
function double(A::opSpot)
	if (size(A,1) < size(A,2)) && ~isa(A, opTranspose) && ~isa(A, opCTranspose)
		return (A'*speye(size(A,1)))'
	else
		return A*speye(size(A,2))
	end
end
##### applyMultiply #########################
function applyMultiply(op::opSpot,x,mode)
	# TODO: op.counter.plus1(mode) # this is for benchmarking
	
	# For border case: empty x
	if isempty(x)
		if mode == 1
			return zeros(op.m,0)
		else
			return zeros(op.n,0)
		end
	end
	
	if mode ==1 # y has to be pre-defined in Julia
		y = zeros(size(op,1),size(x,2))
	else
		y = zeros(size(op,2),size(x,2))
	end
	
	if op.sweepflag
		y = multiply(op,x,mode);
	else
		x_n = size(x,2);
		if x_n == 1
			y = multiply(op,x,mode);
		else
		for i=x_n:-1:1
			y[:,i] = multiply(op,x[:,i],mode);
		end
	end
	return y
end #endof applyMultiply

end #endof opSpot