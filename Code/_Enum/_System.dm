//Commands
#define NORMAL 1
#define BATTLE 2

//Density
atom/movable/proc/IsDense(atom/mover)
	return density

turf/Enter(atom/A)
	if(top && top.IsDense(A)) return 0
	else
		for(var/atom/movable/M in src)
			if(M.IsDense(A)) return 0
	return 1