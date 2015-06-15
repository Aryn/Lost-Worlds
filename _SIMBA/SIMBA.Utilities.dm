proc/GetTurf(atom/atom)
	while(atom && !isturf(atom))
		atom = atom.loc
	return atom