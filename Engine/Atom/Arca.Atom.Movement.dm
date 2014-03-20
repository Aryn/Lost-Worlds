
/*
Proc that force-moves the atom into a new location, ignoring checks.
*/
atom/movable/var/last_moved

atom/movable/proc/ForceMove(atom/newloc)
	//loc.Exit(src)
	//newloc.Enter(src)
	var/area/area
	if(isturf(loc))
		area = loc:loc
		area.Exited(src)
	loc = newloc
	loc.Exited(src)

	if(isturf(newloc))
		area = newloc.loc
		area.Entered(src)
	newloc.Entered(src)
	Moved(loc)

atom/movable/Move(turf/T)
	var/oldloc = loc
	. = ..()
	if(.)
		Moved(oldloc)
		if(isturf(T))
			for(var/structure/S in T)
				S.Stepped(src)

/*
Proc that catches all movement, forced or otherwise.
*/

atom/movable/proc/Moved(atom/oldloc)
	last_moved = world.time

atom/movable/proc/Bumped(atom/movable/by)

atom/movable/Bump(atom/movable/thing)
	. = ..()
	thing.Bumped(src)

structure/proc/Stepped(atom/movable/by)