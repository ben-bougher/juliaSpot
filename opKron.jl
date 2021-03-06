###########################################################################
# opKron opKron opKron opKron opKron opKron opKron opKron opKron opKron ###
###########################################################################
type opKron <:opSpot
    m::Int64
    n::Int64
    name::String
    children
    permutation::Array
	
	cflag::Bool
	sweepflag::Bool
	isDirac::Bool
	linear::Bool
	ms
	ns

    # opKron constructor
    function opKron(ops...)
        
        opList = {ops...}

        if ~isa(opList[1],opSpot)
            opList[1] = opMatrix(opList[1])
        end

        if length(size(opList[1])) > 1
            m,n = size(opList[1])
        else # tuple case
            m = size(opList[1],1)
            n = 1
        end

        for i=2:length(opList)
            if ~isa(opList[i],opMatrix)
                opList[i] = opMatrix(opList[i])
            end
            if length(size(opList[i])) > 1
                mi, ni = size(opList[i])
            else # tuple case
                mi = size(opList[i],1)
                ni = 1
            end

            m = m * mi
            n = n * ni
        end
		
		# Determine operator complexity
		cflag = opList[1].cflag
		sweepflag = opList[1].sweepflag
		isDirac = false
		linear = opList[1].linear
		
		for ind = 2:length(opList)
			theOp = opList[ind]
			cflag = cflag  || theOp.cflag
			sweepflag = sweepflag && theOp.sweepflag
			linear    = linear && theOp.linear
		end
		permutation = [1:length(opList)]
		
		# Evaluate the best permutation to use when a multiplication is applied
		# TODO: op.permutation=op.best_permutation();
		
		# Setting up implicit dimensions of output vector Flipped
		flipOpList = fliplr(opList)
		len = length(flipOpList)
		ms    = cell(1,len)
		ns    = cell(1,len)
		for u = 1:len
			child_op = flipOpList[u]
			if length(child_op.ms) > 1
				ms[u] = [child_op.ms[:]'];
			else
				ms[u] = [child_op.ms[:]];
			end
			if length(child_op.ns) > 1
				ns[u] = [child_op.ns[:]'];
			else
				ns[u] = [child_op.ns[:]];
			end
		end
		
        return new(m,n,"opKron",opList,permutation,cflag,sweepflag,isDirac,linear,ms,ns)
    end # opKron constructor
end

function char(op::opKron)
    str = ["Kron(", char(op.children[1])]

    # Get operators
    for i = 2:length(op.children)
        str = strcat(str,[", ",char(op.children[i])])
    end
    str = strcat(str,")")

    return str
end # Char

function multiply(op::opKron,x,mode::Int64)
	
    # The Kronecker product (KP) is applied to the right-hand matrix
    # taking in account the best order to apply the operators.
    # That necessitates to decompose the KP in successive matrix
    # products with terms of type I(a) kron A kron I(b).
    # A is the operator to apply. I(a) and I(b) are identity
    # matrices with respective sizes a and b.

    opList       = op.children    # Contains the list of opKron children
    ncol         = size(x,2)      # Number of columns of 'x'
    nbr_children = length(opList) # Number of children
    # Pre-registering of the sizes of opKron's children
    sizes = zeros(nbr_children,2)
    for i = [1:nbr_children]
        sm, sn     = size(opList[i])
        sizes[i,:] = [sm sn]
    end
    ######################Multiplication###########################
    if mode == 1 # Classic mode
        perm = op.permutation # Permutation to take in account.
        m    = op.m           # Height of the resulting matrix

        for i = [1:nbr_children]
            # Index of the operator A to consider.
            index = perm[i]

            # Calculation of the sizes of the identity matrices used
            # in the Kronecker product I(a) kron A kron I(b)

            # Size of I(a)
            a = 1
            for k = [1:(index-1)]
                if i .> find( perm .== k )[1]
                    a = a * sizes[k,1]
                else
                    a = a * sizes[k,2]
                end
            end

            # If 'x' has several columns. The initial matrix I(a)
            # kron A kron I(b) is replicated 'ncol' (number of
            # columns of x) times) along the diagonal.
            if ncol > 1
                a = a*ncol
            end

            # Size of I(b)
            b = 1            
            for k = (index+1):nbr_children
                if i .> find( perm .== k )[1]
                    b = b * sizes[k,1]
                else
                    b = b * sizes[k,2]
                end
            end

            # Size of the operator A=opList{index} to apply
            r = sizes[index,1]
            c = sizes[index,2]
            a = int(a); b = int(b); c = int(c); r = int(r);

            #(I(a) kron A kron I(b)) * x;
            t = reshape(reshape(x,(b,a*c)).',(c,a*b))
            x = reshape(multiply(opList[index],t,1)',(a,r*b))'
        end

        return reshape(x,(m,ncol))

    elseif mode == 2 # Transpose mode
        perm = op.permutation[length(opList):-1:1] # The
        # permutation has to be in the other direction since with
        # transposition, operators' computational costs will be
        # inverted.
        n=op.n; #Height of the resulting matrix
		
        for i = 1:nbr_children
            # Index of the operator A to consider.
            index = perm[i];
            # Calculation of the sizes of the identity matrices used
            # in the Kronecker product I(a) kron A kron I(b)

            # Size of I(a)
            a = 1
            for k = 1:(index-1)
                if (i .> find( perm .== k ))[1]
                    a = a * size(opList[k],2)
                else
                    a = a * size(opList[k],1)
                end
            end
            # If 'x' has several columns. The initial matrix I(a)
            # kron A kron I(b) is replicated 'ncol' (number of
            # columns of x) times) along the diagonal.
            if ncol > 1
                a = a*ncol
            end
			
            # Size of I(b)
            b = 1
            for k = (index+1):length(opList)
                if (i .> find( perm .== k ))[1]
                    b = b * size(opList[k],2)
                else
                    b = b * size(opList[k],1)
                end
            end
			
            # Size of the operator A=opList{index} to apply
            r = sizes[index,2]
            c = sizes[index,1]
            a = int(a); b = int(b); c = int(c); r = int(r);

            # (I(a) kron A kron I(b)) * x;
			
            t = reshape(reshape(x,(b,a*c)).',(c,a*b))
            x = reshape(applyMultiply(opList[index],t,2)',(a,r*b))'
        end
        return reshape(x,(n,ncol))
    end #if mode == 2
end # Multiply
