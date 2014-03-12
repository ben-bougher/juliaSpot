###########################################################################
#####                          opOrthogonal                           #####
###########################################################################
abstract opOrthogonal <: opSpot
	function mldivide(op,b)
		op' * b;
	end
# endof opOrthogonal

