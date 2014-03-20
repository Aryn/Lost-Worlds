

var/footsteps_wood = list('Sounds/Footsteps/Wood1.ogg','Sounds/Footsteps/Wood2.ogg','Sounds/Footsteps/Wood3.ogg',
						  'Sounds/Footsteps/Wood4.ogg','Sounds/Footsteps/Wood5.ogg','Sounds/Footsteps/Wood6.ogg')
var/footsteps_metal = list('Sounds/Footsteps/Metal1.ogg','Sounds/Footsteps/Metal2.ogg','Sounds/Footsteps/Metal3.ogg',
						   'Sounds/Footsteps/Metal4.ogg','Sounds/Footsteps/Metal5.ogg','Sounds/Footsteps/Metal6.ogg')
var/footsteps_support = list('Sounds/Footsteps/Support1.ogg','Sounds/Footsteps/Support2.ogg','Sounds/Footsteps/Support3.ogg',
							 'Sounds/Footsteps/Support4.ogg','Sounds/Footsteps/Support5.ogg','Sounds/Footsteps/Support6.ogg')

tile/var/muted_footstep = false
tile/proc/Footstep()
	return pick(footsteps_wood)

tile/floor/metal/Footstep()
	return pick(footsteps_metal)

tile/support/Footstep()
	return pick(footsteps_support)

/global_ambience
	var/playing = false

	var/channel
	var/volume = 100
	var/sound/start
	var/start_length
	var/sound/loop
	var/sound/end

	New()
		start = sound(start, channel=channel, volume = volume)
		loop = sound(loop, repeat=1, channel=channel, volume = volume)
		end = sound(end, channel=channel, volume = volume)

	proc/SetVol(mob/M, n)
		var/sound/s = sound(loop, repeat=1, channel=channel, volume = n)
		s.status = SOUND_UPDATE
		M << s

	proc/Play(mob/M)
		playing = true
		if(M)
			M << start
			spawn(start_length)
				if(M && playing)
					M << loop
		else
			for(M)
				Play(M)

	proc/Stop(mob/M)
		playing = false
		if(M)
			M << end
		else
			for(M)
				Stop(M)

/global_ambience/outside/var/inside_volume
/global_ambience/outside/Play(mob/M)
	if(M)
		var/master_volume = inside_volume
		if(isturf(M.loc))
			var/area/A = M.loc
			A = A.loc
			if(istype(A,/area/outside))
				master_volume = volume

		start.volume = master_volume
		loop.volume = master_volume
	. = ..()

/global_ambience/outside/Stop(mob/M)
	if(M)
		var/master_volume = inside_volume
		if(isturf(M.loc))
			var/area/A = M.loc
			A = A.loc
			if(istype(A,/area/outside))
				master_volume = volume

		end.volume = master_volume
	. = ..()