atom/proc/Sound(sound/sound, base_volume=100, distant_file)
	if(!istype(sound)) sound = sound(sound)
	sound.volume = base_volume
	//Immediate (mob can see sound source)
	var/list/hearers = hearers(src)
	for(var/mob/M in hearers)
		if(!M.client) continue
		M << sound

	//Obscured (source is in range but not visible)
	sound.volume = base_volume-30
	if(sound.volume <= 0 && !distant_file) return

	for(var/client/C)
		if(C.mob in hearers) continue
		var/atom/eye = C.eye
		if(!eye || eye.z != z || get_dist(eye,src) > world.view)
			if(distant_file) C << distant_file
		else
			C << sound