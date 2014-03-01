/*
Procs in this category return one of:
FAILED - The operation was a failure. A message may have been printed to this effect.
CONTINUE - The operation did not complete. Try a different one.
SUCCESS - The operation succeeded, and no more operations should be tried.
*/

atom/movable/Click()
	var/character/user = usr
	if(istype(user))
		user.TryOperate(src)

atom/movable/proc/AppliedBy(mob/user, item/item)
	return CONTINUE

atom/movable/proc/OperatedBy(mob/user)
	return CONTINUE

atom/movable/proc/AppliedLongRange(mob/user, item/item)
	return CONTINUE

item/proc/ApplyTo(atom/movable/A)
	return CONTINUE

item/proc/ApplyLongRange(atom/movable/A)
	return CONTINUE

item/proc/DropOn(atom/movable/A)
	return CONTINUE