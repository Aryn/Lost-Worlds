
/*
Proc that force-moves the atom into a new location, ignoring checks.
*/

atom/movable/proc/ForceMove(atom/newloc)
	//loc.Exit(src)
	//newloc.Enter(src)
	loc = newloc
	loc.Exited(src)
	newloc.Entered(src)
	Moved(loc)

atom/movable/Move()
	var/oldloc = loc
	. = ..()
	if(.)
		Moved(oldloc)

/*
Proc that catches all movement, forced or otherwise.
*/

atom/movable/proc/Moved(atom/oldloc)