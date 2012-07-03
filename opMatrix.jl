###########################################################################
# opMatrix opMatrix opMatrix opMatrix opMatrix opMatrix opMatrix opMatrix #
###########################################################################
type opMatrix <: opSpot

    # Properties ############################
    m::Int64
    n::Int64
    name::String
    children

    function opMatrix(x)
        if length(size(x)) > 1
            m,n = size(x)
        else # tuple case
            m = size(x,1)
            n = 1
        end
        return new(m,n,"opMatrix",x)
    end
end

# double ####################################
function double(op::opMatrix)
    return op.children
end

# Multiply ##################################
function multiply(op::opMatrix,x,mode::Int64)
    if mode == 1
        return op.children * x;
    else
        return op.children' * x;
    end
end

# divide  Solve a linear system with the operator.
function divide(op::opMatrix,b,mode)
    if mode == 1
        return op.children \ b;
    else
        return op.children' \ b;
    end
end # function divide