var/weather/weather = new

var/list/outside_turfs

/hook/startup/proc/SelectOutsideTurfs()
	outside_turfs = list()

	for(var/area/outside/A)
		for(var/turf/T in A)
			outside_turfs.Add(T)


	return TRUE

area/outside/New(turf/loc)
	. = ..()
	if(world.time > 10 && !istype(loc.loc, /area/outside)) outside_turfs.Add(loc)

area/New(turf/loc)
	. = ..()
	if(!loc) return
	if(world.time > 10 && !istype(src,/area/outside) && istype(loc.loc, /area/outside)) outside_turfs.Remove(loc)

mob/verb/Start_Weather(new_weather as anything in typesof(/weather))
	StartWeather(new_weather, 20)

mob/verb/End_Weather(new_weather as anything in typesof(/weather))
	EndWeather(new_weather, 20)

mob/verb/Lightning()
	var/weather/lightning/l_weather = weather
	if(istype(l_weather)) l_weather.Lightning()

mob/verb/Turbulence_Lol()
	Turbulence()

proc/WeatherReport()
	world << "<u>Weather Report</u>"

	var/wind_desc = "Calm"
	var/wind_dir
	var/wind_bearing = game.map.wind_dir + 180
	if(wind_bearing > 360) wind_bearing -= 360

	if(game.map.wind_speed > 1.7)
		wind_desc = "Extreme"
	else if(game.map.wind_speed > 1.2)
		wind_desc = "Strong"
	else if(game.map.wind_speed > 0.9)
		wind_desc = "Moderate"
	else if(game.map.wind_speed > 0.5)
		wind_desc = "Slight"

	if(wind_bearing < 22.5 || wind_bearing > 360-22.5) wind_dir = "North"
	else if(wind_bearing < 67.5) wind_dir = "Northeast"
	else if(wind_bearing < 112.5) wind_dir = "East"
	else if(wind_bearing < 157.5) wind_dir = "Southeast"
	else if(wind_bearing < 202.5) wind_dir = "South"
	else if(wind_bearing < 247.5) wind_dir = "Southwest"
	else if(wind_bearing < 292.5) wind_dir = "West"
	else						  wind_dir = "Northwest"

	world << "[wind_desc] winds coming from the [wind_dir] at [wind_bearing] degrees."

	//NextCity:
	var/list/cities = game.route.Copy()
	var/list/storm_reports = list()
	for(var/i = 1, i <= game.route.len / 2, i++)
		var/obj/map_point/port/P = pick(cities)
		cities.Remove(P)
		var/clear_skies = TRUE
		for(var/obj/map_point/storm/storm in game.map.storms)
			var/dist = DISTSQ(storm.map_x - P.map_x, storm.map_y - P.map_y)
			if(dist < SQ(32))
				if(!storm_reports[storm.name])
					storm_reports[storm.name] = list()
				storm_reports[storm.name] += P
				clear_skies = FALSE
				break
			else if(dist < SQ(64 + storm.radius))
				clear_skies = FALSE
		if(clear_skies)
			if(!storm_reports["Clear"])
				storm_reports["Clear"] = list()
			storm_reports["Clear"] += P

	for(var/storm in storm_reports)
		if(storm == "Clear")
			world << "[storm] skies in [dd_list2text(storm_reports[storm], ", ")]."
		else
			world << "[storm] storm warning for [dd_list2text(storm_reports[storm], ", ")]."

proc/ChangeWeather(type, severity=5)
	ASSERT(ispath(type, /weather))
	var/weather/new_weather = new type()
	new_weather.Change()
	new_weather.severity = 0
	new_weather.AddSeverity(severity)

proc/StartWeather(type, severity)
	if(weather.type == /weather) //clear skies
		ChangeWeather(type, severity)
	else
		if(weather.type == type)
			weather.AddSeverity(severity)
			return

		if((weather.type == /weather/snow && type == /weather/lightning/rain) || (weather.type == /weather/lightning/rain && type == /weather/snow))
			ChangeWeather(/weather/hail, weather.severity + severity)

		if(weather.type == /weather/lightning/dust && type == /weather/lightning/rain)
			ChangeWeather(/weather/lightning/rain, weather.severity)

proc/EndWeather(type, severity)
	if(weather.type == type)
		weather.AddSeverity(-severity)
		if(weather.severity <= 0) ChangeWeather(/weather)
	else
		if(weather.type == /weather/hail && type == /weather/lightning/rain)
			ChangeWeather(/weather/snow, weather.severity - severity)
		if(weather.type == /weather/hail && type == /weather/snow)
			ChangeWeather(/weather/lightning/rain, weather.severity - severity)

proc/TurbulenceLoop()
	if(prob(weather.severity * game.map.ship.Instability() / 5))
		Turbulence()

proc/Turbulence()
	world << pick('Sounds/Ambience/Creak1.ogg','Sounds/Ambience/Creak2.ogg','Sounds/Ambience/Creak3.ogg',
	'Sounds/Ambience/Creak4.ogg','Sounds/Ambience/Creak5.ogg','Sounds/Ambience/Creak6.ogg')
	for(var/client/c in game.players)
		if(c.mob.last_moved > world.time - 30)
			if(prob(80)) step_rand(c.mob)
		c.SlowShake(20)

/weather
	var/name = "Clear"
	var/adj = "clear"

	var/image = ""
	var/color = "#FFFFFFFF"

	var/aux_image
	var/aux_color

	var/global_ambience/outside/amb

	var/ambient_light = 4
	var/severity = 5

/weather/proc/Change()
	if(weather && weather.amb) weather.amb.Stop()
	weather = src
	SetWeatherImage(image, color)
	if(aux_image) SetAuxWeatherImage(aux_image, aux_color)
	else if(aux_weather_on) SetAuxWeatherImage(null)

	if(amb) amb.Play()
	if(lighting_controller.ambient != ambient_light) lighting_controller.ChangeAmbient(ambient_light)

/weather/proc/AddSeverity(s)
	severity += s

/weather/proc/Tick()

/weather/snow
	name = "Snow"
	adj = "snowing"

	image = "wind"
	color = "#AAAAAA33"
	aux_image = "snow"
	aux_color = "#FFFFFFFE"
	amb = new/global_ambience/outside/strong_wind
	ambient_light = 5

/weather/hail
	name = "Hail"
	adj = "hailing"

	image = "wind"
	color = "#AACCCC66"
	aux_image = "hail"
	aux_color = "#FFFFFFFE"

	amb = new/global_ambience/outside/hail
	ambient_light = 5

var/light/lightning_strike = new(5,5)

/weather/lightning

	Tick()
		if(prob(severity  * game.map.ship.Instability() / 5)) Lightning()

	proc/Lightning()
		lighting_controller.FlashAmbient(2)
		if(prob(10))
			var/turf/struck = pick(outside_turfs)
			world << pick('Sounds/Weather/DirectLightning.ogg','Sounds/Weather/DirectLightning2.ogg')
			lightning_strike.atom = struck
			lightning_strike.Flash(2)
			for(var/client/c in game.players)
				c.VShake(8, 16)
		else
			world << pick('Sounds/Weather/Lightning1.ogg','Sounds/Weather/Lightning2.ogg','Sounds/Weather/Lightning3.ogg')



var/global_ambience/amb_rain = new/global_ambience/outside/rain
var/global_ambience/amb_storm = new/global_ambience/outside/storm

/weather/lightning/rain
	name = "Rain"
	adj = "raining"

	image = "rain"
	ambient_light = 2

/weather/lightning/rain/AddSeverity(s)
	. = ..()
	if(severity >= 70)
		SetWeatherImage("downpour")
		if(!amb)
			amb = amb_storm
			amb.Play()
		ambient_light = 1
		if(lighting_controller.ambient != 1)
			lighting_controller.ChangeAmbient(1)
	else
		ambient_light = 2
		if(lighting_controller.ambient != 2)
			lighting_controller.ChangeAmbient(2)
		if(severity >= 45)
			SetWeatherImage("heavy rain")
			if(amb == amb_rain || !amb)
				if(amb) amb.Stop()
				amb = amb_storm
				amb.Play()
		else
			SetWeatherImage("rain")
			if(amb == amb_storm || !amb)
				if(amb) amb.Stop()
				amb = amb_rain
				amb.Play()


/weather/lightning/dust
	name = "Dust Storm"
	adj = "dusting?"

	image = "wind"
	color = "#FFCCAA44"
	aux_image = "dust"
	aux_color = "#FFAAAA66"
	amb = new/global_ambience/outside/dust

	ambient_light = 3