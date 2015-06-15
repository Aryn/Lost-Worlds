/structure/ladder
	name = "Ladder"
	icon = 'Icons/Ship/Ladder.dmi'
	is_anchored = TRUE
	pixel_y = 12

	var/next_level = 0

/structure/ladder/up
	icon_state = "up"
	next_level = 1

/structure/ladder/down
	icon_state = "down"
	next_level = -1

/structure/ladder/New(turf/T)
	. = ..()
	#ifdef MAP_WARNINGS
	if(!T.top) log_warning("Ladder on sky at [x],[y],[z]")
	#endif
	T.top.muted_footstep = TRUE
	#ifdef MAP_WARNINGS
	spawn(10)
		if(!(locate(/structure/ladder) in locate(x,y,z+next_level)))
			log_warning("Asymmetrical [src] at [x],[y],[z]")
	#endif

/structure/ladder/Stepped(mob/M)
	if(ismob(M))
		if(M.client) M.client.last_moved = world.time+6
		var/turf/up = locate(x,y,z+next_level)
		Sound(pick(footsteps_support))
		up.Sound(pick(footsteps_support))
		spawn(3)
			if(M && M.loc == loc)
				M.ForceMove(up)
				Sound(pick(footsteps_support))
				up.Sound(pick(footsteps_support))
				sleep(3)
				Sound(pick(footsteps_support))
				up.Sound(pick(footsteps_support))