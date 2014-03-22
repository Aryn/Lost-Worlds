
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