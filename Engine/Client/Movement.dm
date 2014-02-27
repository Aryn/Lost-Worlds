
//Returns true if a mob is stunned, but can still be pushed.
/mob/proc/IsStunned()
	return false

client/Move()
	if(mob.IsStunned()) return 0
	. = ..()