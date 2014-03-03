client/Move()
	if(last_moved > world.time - mob.move_delay) return 0
	. = ..()

mob/var/move_delay = 2