/turf/ground
	layer = 0.5
	name = "Ground"
	icon = 'Icons/World/Ground.dmi'
	icon_state = "grass"

/turf/ground/dirt
	icon_state = "255"

	proc/Autojoin()
		var/joinflag = 0

		joinflag |= MatchTurf(NORTH, 1)
		joinflag |= MatchTurf(EAST, 4)
		joinflag |= MatchTurf(SOUTH, 16)
		joinflag |= MatchTurf(WEST, 64)

		joinflag |= MatchTurf(NORTHEAST, 2, 5, joinflag)
		joinflag |= MatchTurf(SOUTHEAST, 8, 20, joinflag)
		joinflag |= MatchTurf(SOUTHWEST, 32, 80, joinflag)
		joinflag |= MatchTurf(NORTHWEST, 128, 65, joinflag)
		icon_state = "[joinflag]"

	proc/MatchTurf(direction, flag, mask=0, joinflag=0)
		if((joinflag & mask) != mask) return 0
		var/tile/T = get_step(src, direction)
		if(!T || istype(T, type))
			return flag
		else
			return 0

/hook/game_start/proc/UpdateTerrain()
	world << "\green Updating Ground..."
	for(var/turf/ground/dirt/S)
		S.Autojoin()
	return 1