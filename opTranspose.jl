###########################################################################
#####                           opTranspose                           #####
###########################################################################
type opTranspose <: opSpot

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
	function opTranspose(a)
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
		
		return new(n,m,"opTranspose",children,cflag,sweepflag,false,linear,ms,ns)
		
	end #endof Constructor
end #endof opTranspose
	##############################
	
	#####conj#########################
	function Base.conj(op::opTranspose)
		return ctranspose(op.children[1])
	end
	#####CTranspose#########################
	function ctranspose(A::opTranspose)
		return conj(A.children[1])
	end
	#####Transpose#########################
	function transpose(A::opTranspose)
		return A.children[1]
	end
	
	function multiply(op::opTranspose,x,mode)
		A = op.children[1];
		return applyMultiply(opCTranspose(opConj(A)),x,mode)
	end #endof multiply
	
	function double(op::opTranspose)
		return transpose(double(op.children[1]))
	end
