var/list/weather_images
var/list/aux_weather_images
var/aux_weather_on = false

proc/SetWeatherImage(state, color)
	if(!weather_images)
		weather_images = list()
		for(var/i = 1, i <= 9, i++)
			weather_images.Add(image('Icons/Area/WeatherSplit.dmi', layer=LIGHT_LAYER-2))

	for(var/turf/T in outside_turfs)
		T.overlays -= weather_images[((T.y%3)*3)+((T.x%3)+1)]

	if(state)
		var/i = 0
		for(var/image/weather_img in weather_images)
			weather_img.icon_state = "[state] [i%3],[round(i/3)]"
			if(color) weather_img.color = color
			++i
			//world << "\icon[weather_img]"

		for(var/turf/T in outside_turfs)
			T.overlays += weather_images[((T.y%3)*3)+((T.x%3)+1)]

proc/SetAuxWeatherImage(state, color)
	aux_weather_on = false
	if(!aux_weather_images)
		aux_weather_images = list()
		for(var/i = 1, i <= 9, i++)
			aux_weather_images.Add(image('Icons/Area/WeatherSplit.dmi', layer=LIGHT_LAYER-1))

	for(var/turf/T in outside_turfs)
		T.overlays -= aux_weather_images[((T.y%3)*3)+((T.x%3)+1)]

	if(state)
		var/i = 0
		for(var/image/weather_img in aux_weather_images)
			weather_img.icon_state = "[state] [i%3],[round(i/3)]"
			if(color) weather_img.color = color
			++i
			//world << "\icon[weather_img]"

		for(var/turf/T in outside_turfs)
			T.overlays += aux_weather_images[((T.y%3)*3)+((T.x%3)+1)]

		aux_weather_on = true