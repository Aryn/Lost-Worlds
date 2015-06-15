var/global_ambience/outside/wind_sound = new/global_ambience/outside/wind
var/global_ambience/outside/engine_sound = new/global_ambience/outside/engine

/global_ambience/outside/storm
	start = 'Sounds/Weather/Thunderstorm/Start.ogg'
	start_length = 47
	volume = 75
	inside_volume = 15
	loop = 'Sounds/Weather/Thunderstorm/Loop.ogg'
	end = 'Sounds/Weather/Thunderstorm/End.ogg'
	channel = 2

/global_ambience/outside/rain
	start = 'Sounds/Weather/Rain/Start.ogg'
	start_length = 9
	volume = 150
	inside_volume = 50
	loop = 'Sounds/Weather/Rain/Loop.ogg'
	end = 'Sounds/Weather/Rain/End.ogg'
	channel = 2

/global_ambience/outside/dust
	start = 'Sounds/Weather/Sandstorm/Start.ogg'
	start_length = 11
	volume = 100
	inside_volume = 20
	loop = 'Sounds/Weather/Sandstorm/Loop.ogg'
	end = 'Sounds/Weather/Sandstorm/End.ogg'
	channel = 2

/global_ambience/outside/wind
	loop = 'Sounds/Ambience/Wind.ogg'
	channel = 1
	volume = 100
	inside_volume = 15

/global_ambience/outside/strong_wind
	start = 'Sounds/Weather/Gale/Start.ogg'
	start_length = 8
	loop = 'Sounds/Weather/Gale/Loop.ogg'
	end = 'Sounds/Weather/Gale/End.ogg'
	channel = 2
	volume = 80
	inside_volume = 20

/global_ambience/outside/hail
	start = 'Sounds/Weather/Hail/Start.ogg'
	start_length = 9
	loop = 'Sounds/Weather/Hail/Loop.ogg'
	end = 'Sounds/Weather/Hail/End.ogg'
	channel = 2
	volume = 100
	inside_volume = 30

/global_ambience/outside/engine
	loop = 'Sounds/Ambience/Engine.ogg'
	channel = 3
	volume = 25
	inside_volume = 5

area/Entered(character/C)
	. = ..()
	if(istype(C)) ApplyWeatherSound(C)

area/proc/ApplyWeatherSound(character/C)
	if(weather.amb && weather.amb.playing) weather.amb.SetVol(C, weather.amb.inside_volume)
	wind_sound.SetVol(C,wind_sound.inside_volume)
	if(engine_sound.playing) engine_sound.SetVol(C,engine_sound.inside_volume)

area/outside/ApplyWeatherSound(character/C)
	if(weather.amb && weather.amb.playing) weather.amb.SetVol(C, weather.amb.volume)
	wind_sound.SetVol(C, wind_sound.volume)
	if(engine_sound.playing) engine_sound.SetVol(C,engine_sound.volume)

area/surface/ApplyWeatherSound(character/C)
	if(weather.amb && weather.amb.playing) weather.amb.SetVol(C, 0)
	wind_sound.SetVol(C, wind_sound.inside_volume)
	if(engine_sound.playing) engine_sound.SetVol(C, 0)