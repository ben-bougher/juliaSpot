###########################################################################
#####                              opDFT                              #####
###########################################################################
type opDFT <: opOrthogonal

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
	
	funHandle
	centered
	# endof Properties
	##############################
	
	##############################
	# Constructors
	function opDFT(m::Int,centered)
		if ~isa(m,Int) || m < 0
			error("First argument to opDFT has to be a positive integer.")
		end
		
		centered = centered == true
		
		cflag = true;
		sweepflag = true;
		isDirac = false;
		linear = false;
		ms = m;
		ns = m;
		
		if centered
			funHandle = opDFT_centered_intrnl;
		else
			funHandle = opDFT_intrnl;
		end
		
		return new(m,m,"opDFT",{},cflag,sweepflag,isDirac,linear,ms,ns,funHandle,centered)
	end
	function opDFT(m::Int)
		return opDFT(m,false)
	end
	#endof Constructors
	##############################
	
	##############################
	# PRIVATE FUNCTIONS
	
	function opDFT_intrnl(op,x,mode)
		# One-dimensional DFT
		n = op.n;
		
		if mode == 1
			# Analysis
			y = fft(full(x),1);
			y = y / sqrt(n);
		else
			# Synthesis
			y = ifft(full(x),1);
			y = y * sqrt(n);
		end
	end # opDFT_intrnl
	
	function opDFT_centered_intrnl(op,x,mode)
		n = op.n;
		if mode == 1
			y = fftshift(fft(full(x),1))
			return y / sqrt(n);
		else
			y = ifft(ifftshift(full(x)),1)
			return y * sqrt(n);
		end
	end # opDFT_centered_intrnl
	
	# endof PRIVATE FUNCTIONS
	##############################
end #opDFT

function multiply(op::opDFT,x,mode)
	return op.funHandle(op,x,mode);
end

# TODO: Add function divide(op::opDFT,b,mode) 
