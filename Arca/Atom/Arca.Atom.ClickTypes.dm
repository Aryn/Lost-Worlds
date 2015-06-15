/*
Procs in this category return TRUE if something happened.
*/

atom/movable/Click()
	var/character/user = usr
	if(istype(user))
		user.TryOperate(src)

atom/movable/proc/AppliedBy(mob/user, item/item)
	return FALSE

atom/movable/proc/OperatedBy(mob/user)
	return FALSE

atom/movable/proc/AppliedLongRange(mob/user, item/item)
	return FALSE

item/proc/ApplyTo(atom/movable/A)
	return FALSE

item/proc/ApplyLongRange(atom/movable/A)
	return FALSE

item/proc/DropOn(atom/movable/A)
	return FALSE