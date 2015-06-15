/atom/movable/Bump(atom/obstacle)
	obstacle.Bumped(src)

/atom/proc/Bumped(atom/movable/bumper)

/atom/proc/Operated(mob/user)
/atom/proc/OperatedAtRange(mob/user)

/atom/proc/Applied(mob/user, item/item)
/atom/proc/AppliedAtRange(mob/user, item/item)

/atom/Click(location,control,params)
	var/character/user = usr

	if(get_dist(user, src) <= 1)
		if(user.active_slot.item)
			if(!user.active_slot.item.ApplyTo(src))
				Applied(user, user.active_slot.item)
		else
			Operated(user)
	else
		if(user.active_slot.item)
			AppliedAtRange(user,user.active_slot.item)
		else
			OperatedAtRange(user)

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

structure/proc/Stepped(atom/movable/by)


//Returns TRUE if a mob is stunned, but can still be pushed.
/mob/proc/IsStunned()
	return FALSE

/mob/proc/ClientMoved()

client/var/last_moved = -1

client/Move()
	if(mob.IsStunned()) return 0
	. = ..()
	if(.)
		if(last_moved < world.time) last_moved = world.time
		mob.ClientMoved()