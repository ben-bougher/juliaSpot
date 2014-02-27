###########################################################################
# opMatrix opMatrix opMatrix opMatrix opMatrix opMatrix opMatrix opMatrix #
###########################################################################
type opMatrix <: opSpot

    # Properties ############################
    m::Int64
    n::Int64
    name::String
    matrix #used to be children here

    cflag::Bool
    sweepflag::Bool
    isDirac::Bool
    linear::Bool
    ms
    ns
	children
	
    function opMatrix(x)
        if length(size(x)) > 1
            m,n = size(x)
        else # tuple case
            m = size(x,1)
            n = 1
        end
		
	    cflag=false
	    sweepflag=true
	    isDirac=false
	    linear=false
	    ms={m}
	    ns={n}
        return new(m,n,"opMatrix",x,cflag,sweepflag,isDirac,linear,ms,ns,{})
    end
end

# double ####################################
function double(op::opMatrix)
    return op.matrix
end

# Multiply ##################################
function multiply(op::opMatrix,x,mode::Int64)
    if mode == 1
        return op.matrix * x;
    else
        return op.matrix' * x;
    end
end
function multiply(op1::opSpot,op2::opSpot)
    return double(op1) * double(op2);
end


# divide  Solve a linear system with the operator.
function divide(op::opMatrix,b,mode)
    if mode == 1
        return op.matrix \ b;
    else
        return op.matrix' \ b;
    end
end # function divide