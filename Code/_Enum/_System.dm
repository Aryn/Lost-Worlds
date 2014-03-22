//Commands
#define NORMAL 1
#define BATTLE 2

//Density
atom/movable/proc/IsDense(atom/mover)
	return density

turf/Enter(atom/A)
	if(exposed_tile && exposed_tile.IsDense(A)) return 0
	else
		for(var/atom/movable/M in src)
			if(M.IsDense(A)) return 0
	return 1