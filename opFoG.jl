###########################################################################
#####                              opFoG                              #####
###########################################################################
type opFoG <: opSpot

    # Properties ############################
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

    function opFoG(A::opSpot,b)
		# Input matrices are immediately cast as opMatrix's.
        if isa(b,Array{Int,}) || isa(b,Array{Float64,}) || isa(b,Int) || isa(b,Float64)
		#if b is vector or numeric
			B = opMatrix(b)
		elseif isa(b,opSpot)
			B = b #if b is already spot
		else
			throw(ArgumentError("Input type not recognized"))
		end
		
		# Check operator consistency and complexity
		(mA,nA)	= size(A)
		(mB,nB) = size(B)
		
		compatible = isa(b,Int) || nA==mB
		if ~compatible
			throw(ArgumentError("Incompatible in size"))
		end
		
		# Determine size
		if isa(b,Int)
			m = max(mA,mB)
			n = max(nA,nB)
		else
			m = mA
			n = nB
		end
		
		# Construct operator
		cflag = A.cflag || B.cflag
		linear = A.linear || B.linear
		isDirac=false;
		sweepflag = A.sweepflag || B.sweepflag
		children = {A,B}
		precedence = 3;
		ms = A.ms
		ns = B.ns
		
		return new(m,n,"opFoG",children,cflag,sweepflag,isDirac,linear,ms,ns)
    end
end

##################################################
##### double                                 #####
##################################################
function double(op::opFoG)
	C1 = op.children[1]
	C2 = op.children[2]
	return double(C1) * double(C2)
end


