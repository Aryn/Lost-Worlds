/hook/game_start/proc/JoinStructures()
	for(var/structure/joining/J)
		J.Join()
	return 1

structure/joining/var/jdir = 0
structure/joining/is_anchored = 1

structure/joining/proc/Join()
	jdir = 0
	for(var/d = 1, d < 16, d*=2)
		for(var/structure/J in get_step(src,d))
			if(J)
				if(istype(J, /structure/joining))
					var/structure/joining/JJ = J
					if(!JJ.CanJoin(src)) continue
				if(CanJoin(J))
					jdir |= d

	icon_state = "[jdir]"

structure/joining/proc/CanJoin(structure/J)
	return J.type == type