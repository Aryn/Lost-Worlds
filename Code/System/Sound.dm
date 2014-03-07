

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

var/global_ambience/storm_sound = new/global_ambience/storm
var/global_ambience/wind_sound = new/global_ambience/wind
var/global_ambience/engine_sound = new/global_ambience/engine

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
		//loop.status = SOUND_UPDATE

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

/global_ambience/storm
	start = 'Sounds/Weather/StormStart.ogg'
	start_length = 48
	volume = 75
	loop = 'Sounds/Weather/Storm2.ogg'
	end = 'Sounds/Weather/StormEnd.ogg'
	channel = 2

/global_ambience/wind
	loop = 'Sounds/Weather/WindLoop.ogg'
	channel = 1
	volume = 40

/global_ambience/engine
	loop = 'Sounds/Ship/Engine.ogg'
	channel = 3
	volume = 50