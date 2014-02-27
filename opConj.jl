###########################################################################
#####                              opConj                             #####
###########################################################################
type opConj <: opSpot

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
	
	function opConj(a)
		#----------Input Argument----------
		if isa(a,Array{Int,}) || isa(a,Array{Float64,}) || isa(a,Int) || isa(a,Float64)
			A = opMatrix(a)
		elseif isa(a,opSpot)
			A = a
		else
			throw(ArgumentError("Input operator is not valid."))
		end
		
		#----------Construct the operator----------
		m,n = size(A)
		cflag = A.cflag
		linear = A.linear
		sweepflag = true
		children = {A}
		ms = A.ms
		ns = A.ns
		
		return new(m,n,"opConj",children,cflag,sweepflag,false,linear,ms,ns)
	end #endof Constructor

end # endof opConj

	function Base.conj(op::opConj)
		return op.children[1]
	end
	
	function ctranspose(op::opConj)
		return transpose(op.children[1])
	end
	
	function transpose(op::opConj)
		return ctranspose(op.children[1])
	end
	
	function multiply(op::opConj,x,mode)
		return conj(multiply(op.children[1],conj(x),mode));
	end