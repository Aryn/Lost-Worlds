client/Move()
	if(last_moved > world.time - mob.move_delay) return 0
	//var/character/char = mob
	//if(istype(char) && char.combatant)
	//	src << "\red You are in a battle!"
	//	return 0
	. = ..()

mob/var/move_delay = 2
mob/glide_size = 4