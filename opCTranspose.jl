###########################################################################
#####                           opCTranspose                          #####
###########################################################################
type opCTranspose <: opSpot

	##############################
	# Properties
    m::Int64
    n::Int64
    name::String
    children
	
	cflag::Bool
	sweepflag::Bool
	isDirac::Bool
	linear::Bool
	ms
	ns
	
	# endof Properties
	##############################
	
	##############################
	# Constructor
	function opCTranspose(a)
		#----------Input Argument----------
		if isa(a,Array{Int,}) || isa(a,Array{Float64,}) || isa(a,Int) || isa(a,Float64)
			A = opMatrix(a)
		elseif isa(a,opSpot)
			A = a
		else
			throw(ArgumentError())
		end
		
		#----------Construct the operator----------
		(m,n) = size(A);
		cflag = A.cflag
		linear =A.linear
		sweepflag = true
		children = {A}
		ms = A.ns
		ns = A.ms
		
		return new(n,m,"opCTranspose",children,cflag,sweepflag,false,linear,ms,ns)
		
	end #endof Constructor
end #endof opCTranspose
	##############################
	
	#####conj#########################
	function Base.conj(op::opCTranspose)
		return transpose(op.children[1])
	end
	#####CTranspose#########################
	function ctranspose(A::opCTranspose)
		return A.children[1]
	end
	#####Transpose#########################
	function transpose(A::opCTranspose)
		return conj(A.children[1])
	end
	
	
	function multiply(op::opCTranspose,x,mode)
		A = op.children[1];
		if mode == 1
			return applyMultiply(A,x,2)
		else
			return applyMultiply(A,x,1)
		end
	end #endof multiply
	
	function double(op::opCTranspose)
		return transpose(conj(double(op.children[1])))
	end
