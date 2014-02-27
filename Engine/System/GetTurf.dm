
proc/GetTurf(atom/A)
	var/attempts = 15
	while(!isturf(A) && attempts-- > 0)
		A = A.loc
	return A