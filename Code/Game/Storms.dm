

/world_map/var/storm_count = 48
/world_map/var/min_wind_interval = 15
/world_map/var/max_wind_interval = 30
/world_map/var/next_wind_change

/world_map/Initialize()
	. = ..()
	wind_dir = rand(0,359)
	next_wind_change = world.time+rand(min_wind_interval,max_wind_interval)*MINUTES(1)*(MAP_TIMESCALE/STANDARD_TIMESCALE)

	for(var/i = 1, i <= storm_count, i++)
		var/obj/map_point/storm/storm = new
		storm.Regenerate()
		storms.Add(storm)
		//ShowIcon(storm)

/world_map/proc/Storms()
	if(world.time >= next_wind_change)
		wind_dir += rand(-90,90)
		next_wind_change = world.time+rand(min_wind_interval,max_wind_interval)*MINUTES(1)*(MAP_TIMESCALE/STANDARD_TIMESCALE)
		//world << "\blue The wind changed direction..."

	for(var/obj/map_point/storm/storm in storms.contents)

		var/dist_from_storm = DISTSQ((storm.map_x)-ship.map_x,(storm.map_y)-ship.map_y)
		var/visible_radius = 24*(storm.severity/100)+storm.radius

		if(dist_from_storm < SQ(visible_radius))
			if(!storm.visible) ShowIcon(storm)
			storm.visible = TRUE

			if(dist_from_storm < SQ(storm.radius))
				if(!storm.affecting)
					storm.Affect()
				storm.alpha = 225
			else
				if(storm.affecting)
					storm.Stop()
				storm.alpha = (storm.severity/120)*255

		else
			if(storm.visible) EraseIcon(storm)
			storm.visible = FALSE

		if(storm.lifetime++ > storm.severity*10)
			storm.Regenerate()
		else
			storm.StormMovement()

/world_map/var/wind_dir

/obj/map_point/storm
	var/severity
	var/storm_type
	var/radius
	var/angle = 0
	var/speed
	var/matrix/scale

	var/lifetime
	var/visible = FALSE
	var/affecting = FALSE
	var/storm_time

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

		map_x += speed * sin(angle) * MAP_TICK_SPEED
		map_y += speed * cos(angle) * MAP_TICK_SPEED
		if(map_x > 640 || map_x < 0 || map_y > 480 || map_y < 0) Regenerate()
		else UpdatePosition()

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
			map_x = rand(16,608) - sin(game.map.wind_dir) * rand(32,256)
			map_y = rand(16,448) - cos(game.map.wind_dir) * rand(32,256)
		else
			map_x = rand(16,608)
			map_y = rand(16,448)

		map_x = max(16,min(608,map_x))
		map_y = max(16,min(448,map_y))
		severity = 20
		if(prob(50) && severity <100)
			severity += 20
		speed = rand(2,16)/MAP_TIMESCALE
		lifetime = rand(0,19)
		icon = 'Icons/Hazards/Storms.dmi'
		PickStormType()
		angle = game.map.wind_dir + rand(-25,25)
		radius = 12
		while(prob(33) && radius < 32)
			radius += 4
		icon_state = "[radius*2]"
		UpdatePosition()
		alpha = (severity/120)*255

	proc/PickStormType()
		if(map_y < 160)
			storm_type = /weather/snow
			color = "#FFFFFF88"
		else if(map_y > 320)
			storm_type = /weather/lightning/dust
			color = "#AAAA0088"
		else
			storm_type = /weather/lightning/rain
			color = "#55555588"