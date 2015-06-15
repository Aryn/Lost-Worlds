
/*
Proc that force-moves the atom into a new location, ignoring checks.
*/
atom/movable/var/last_moved

atom/movable/proc/ForceMove(atom/newloc)
	//loc.Exit(src)
	//newloc.Enter(src)
	var/atom/oldloc = loc

	var/area/area
	if(isturf(oldloc))
		area = loc:loc
		area.Exited(src)

	if(oldloc) oldloc.Exited(src)
	loc = newloc

	if(isturf(newloc))
		area = newloc.loc
		area.Entered(src)
	if(newloc) newloc.Entered(src)
	Moved(loc)

atom/movable/Move(turf/T)
	var/oldloc = loc
	. = ..()
	if(.)
		Moved(oldloc)
		if(isturf(T))
			for(var/structure/S in T)
				S.Stepped(src)

atom/movable/proc/MoveTimer(t = 1.#INF)
	var/start_time = world.time
	while(world.time < start_time + t)
		sleep(5)
		if(last_moved > start_time) return 0
	return 1

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