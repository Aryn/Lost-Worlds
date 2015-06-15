

/world_map/var/storm_count = 48
/world_map/var/min_wind_interval = 15
/world_map/var/max_wind_interval = 30
/world_map/var/next_wind_change
/world_map/var/next_storm_update = 0
/world_map/var/show_all_storms = FALSE

//world_map/var/list/storm_outline = list()

/world_map/Initialize()
	. = ..()
	wind_dir = rand(0,359)
	wind_speed = rand() * 2
	next_wind_change = world.time+rand(min_wind_interval,max_wind_interval)*MINUTES(1)*(MAP_TIMESCALE/STANDARD_TIMESCALE)

	//for(var/r = 12, r <= 32, r+=4)
	//	storm_outline["[r*2]"] = icon('Icons/Hazards/Storms-Inside.dmi',"[r*2]")

	for(var/i = 1, i <= storm_count, i++)
		var/obj/map_point/storm/storm = new
		storm.Regenerate()
		storms.Add(storm)
		//ShowIcon(storm)

/world_map/proc/Storms()
	if(world.time >= next_wind_change)
		wind_dir += rand(-90,90)
		wind_speed = rand() * 2
		next_wind_change = world.time+rand(min_wind_interval,max_wind_interval)*MINUTES(1)*(MAP_TIMESCALE/STANDARD_TIMESCALE)
		//world << "\blue The wind changed direction..."

	var/tracking = FALSE
	if(world.time > next_storm_update)
		next_storm_update = world.time + SECONDS(1) * (MAP_TIMESCALE/STANDARD_TIMESCALE)
		tracking = TRUE

	for(var/obj/map_point/storm/storm in storms)

		var/dist_from_storm = DISTSQ((storm.map_x)-ship.map_x,(storm.map_y)-ship.map_y)
		var/visible_radius = 24*(storm.severity/100)+storm.radius

		if(dist_from_storm < SQ(visible_radius) || show_all_storms)
			if(!storm.visible) ShowIcon(storm)
			storm.visible = TRUE

			if(dist_from_storm < SQ(storm.radius))
				if(!storm.affecting)
					storm.Affect()
					//storm.overlays += storm_outline["[storm.radius*2]"]
				storm.alpha = 250

			else
				if(storm.affecting)
					storm.Stop()
					//storm.overlays -= storm_outline["[storm.radius*2]"]
				storm.alpha = (storm.severity/120)*255

		else
			if(storm.visible) EraseIcon(storm)
			storm.visible = FALSE

		if(storm.lifetime++ > storm.severity*10)
			storm.Regenerate()
		else
			storm.StormMovement()

		if(tracking) storm.TrackStorm()

/world_map/var/wind_dir
/world_map/var/wind_speed = 1

/obj/map_point/storm
	var/severity
	var/weather/storm_type
	var/radius
	var/angle = 0
	var/speed
	var/matrix/scale

	var/lifetime
	var/time_since_update = 0
	var/visible = FALSE
	var/affecting = FALSE
	var/storm_time

	var/secret_x = 0
	var/secret_y = 0

	var/image/outline

	pixel_x = -32
	pixel_y = -32

	mouse_opacity = 0

	New()
		. = ..()
		spawn(1)
			Regenerate(FALSE)
			lifetime = rand(0,severity*5)

	proc/StormMovement()
		//world << "Angle to target: [round(angle_to_target,0.1)] degrees."
		angle = angle + rand(-5,5)*MAP_TICK_SPEED
		if(angle%360 < (game.map.wind_dir-65)) angle = game.map.wind_dir-65
		if(angle%360 > (game.map.wind_dir+65)) angle = game.map.wind_dir+65

		secret_x += speed * game.map.wind_speed * sin(angle) * MAP_TICK_SPEED
		secret_y += speed * game.map.wind_speed * cos(angle) * MAP_TICK_SPEED
		if(secret_x > 640 || secret_x < 0 || secret_y > 480 || secret_y < 0) Regenerate()

	proc/TrackStorm()
		map_x = secret_x
		map_y = secret_y
		UpdatePosition()

	proc/ChangeRadius(r)
		radius = r

	proc/Affect()
		//world << "<font color=yellow><b>You are caught in a [severity > 50 ? "<font color=red>severe</font>" : ""] [storm_type] storm!</b></font>"
		StartWeather(storm_type, severity)
		storm_time = world.time
		affecting = TRUE

	proc/Stop()
		//world << "\green <b>The [storm_type] storm has passed.</b>"
		//var/time = (world.time - storm_time)/10
		//world << "\green You were in the storm for [parse_time(time)]."
		EndWeather(storm_type, severity)
		//world << "([parse_time(STD_CONVERSION(time))] Standard)"
		affecting = FALSE

	proc/Regenerate(into_wind = TRUE)
		if(affecting)
			Stop()
		screen_loc = null

		if(into_wind)
			secret_x = rand(16,624) - sin(game.map.wind_dir) * rand(128,256)
			secret_y = rand(16,464) - cos(game.map.wind_dir) * rand(128,256)
		else
			secret_x = rand(16,624)
			secret_y = rand(16,464)

		secret_x = max(16,min(624,secret_x))
		secret_y = max(16,min(464,secret_y))
		map_x = secret_x
		map_y = secret_y
		severity = 20
		while(prob(50) && severity <100)
			severity += 20
		speed = rand(2,16)/MAP_TIMESCALE
		lifetime = rand(0,19)
		icon = 'Icons/Hazards/StormsH.dmi'
		PickStormType()
		angle = game.map.wind_dir + rand(-25,25)
		radius = 12
		while(prob(60) && radius < 32)
			radius += 4
		icon_state = "[radius*2]"
		UpdatePosition()
		alpha = (severity/120)*255

	proc/PickStormType()
		if(map_y < 160)
			storm_type = /weather/snow
			color = "#FFFFFFFF"
			name = "Snow"
		else if(map_y > 320)
			storm_type = /weather/lightning/dust
			color = "#AAAA00FF"
			name = "Dust"
		else
			storm_type = /weather/lightning/rain
			color = "#555555FF"
			name = "Rain"