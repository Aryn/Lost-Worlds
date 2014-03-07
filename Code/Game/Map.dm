mob/var/can_control_ship = false
mob/verb/CloseMap()
	set hidden = 1
	game.map.StopShowing(src)

/world_map
	var/list/ports = list()
	var/obj/map_bg/map_bg = new
	var/RefSortedList/storms = new
	var/RefSortedList/icons = new
	var/obj/map_point/ship/ship

	var/list/viewing_mobs = list()

	proc/Initialize()
		for(var/i = citynames.len, i > 0, i--)
			var/x
			var/y
			var/done = false
			var/iterations = 40
			do
				x = rand(16,608)
				y = rand(16,448)
				done = true
				for(var/obj/map_point/port/existing_port in ports)
					if(DISTSQ(x-existing_port.map_x, y-existing_port.map_y) < SQ(64))
						done = false
				iterations--
			while(!done && iterations > 0)
			var/obj/map_point/port/test/port = new(x,y)
			if(!iterations) spawn(10) world << "\red Port failed: [port]"
			icons.Add(port)
			ports.Add(port)
		ship = new(0,0)
		icons.Add(ship)
		spawn Storms()

	proc/ShowTo(mob/M, can_control_ship=false)
		world << "Showing the world map to [M]"
		if(M.client)
			if(istype(M,/character)) M.can_control_ship = can_control_ship
			winshow(M,"worldmap",1)
			viewing_mobs.Add(M)
			world << "Map BG"
			M.client.screen += map_bg
			world << "Icons: [icons.contents.len]"
			M.client.screen += icons.contents

	proc/StopShowing(mob/M)
		M.can_control_ship = false
		if(M.client)
			winshow(M,"worldmap",0)
			M.client.screen -= icons.contents
			M.client.screen -= map_bg
		viewing_mobs.Remove(M)

	proc/ShowIcon(obj/O)
		icons.Add(O)
		for(var/mob/M in viewing_mobs)
			M.client.screen += O

	proc/EraseIcon(obj/O)
		icons.Remove(O)
		for(var/mob/M in viewing_mobs)
			M.client.screen -= O

/obj/map_point
	icon = 'Icons/HUD/MapPoints.dmi'
	layer = 2
	pixel_x = -8
	pixel_y = -8

	var/map_x
	var/map_y

	New(x,y)
		map_x = x
		map_y = y
		UpdatePosition()

/obj/map_bg
	icon = 'Textures/Map.png'
	screen_loc = "WorldMap:1,1"
	layer = 1

/obj/map_point/proc/SetPosition(x,y)
		map_x = x
		map_y = y
		UpdatePosition()

/obj/map_point/proc/UpdatePosition()
	screen_loc = "WorldMap:1:[round(map_x)+pixel_x],1:[round(map_y)+pixel_y]"

/obj/map_point/port
	icon_state = "port"
	var/data/port/route_data
	var/image/text_overlay
	New(x,y)
		. = ..(x,y)
		text_overlay = image(loc=src)
		text_overlay.maptext_width = 128
		text_overlay.maptext_height = 16
		text_overlay.maptext = "<small><font color=black>[name]</small></font>"
		text_overlay.pixel_y = -10
		text_overlay.pixel_x = -(length(name)*2)
		overlays += text_overlay

	Click()
		game.selected = src
		game.departure_time = world.time
		var/dist = sqrt(DISTSQ(map_x-game.map.ship.map_x, map_y-game.map.ship.map_y))
		var/time = dist / (game.map.ship.speed*10)
		game.accumulated_time += time
		//world << "[src] selected. [dist]px away."
		world << "ETA: [parse_time(time)]"
		//game.map.ship.SetPosition(map_x,map_y)

obj/map_point/ship
	icon_state = "ship"
	layer = 3
	var/matrix/rotation = new
	var/angle = 0
	var/speed = 32/MAP_TIMESCALE

	proc/FlyTo(x,y)
		var/dist_squared = DISTSQ(x-map_x,y-map_y)
		if(dist_squared < SQ(4)) //Get within four pixels and you're there
			game.Arrived()
			return

		var/angle_to_target = arctan2(x-map_x,y-map_y)
		//world << "Angle to target: [round(angle_to_target,0.1)] degrees."
		angle = ((y - map_y > 0 ? -angle_to_target : angle_to_target) + 360 + 90)
		dir = turn(NORTH,round(-angle,45))

		map_x += speed * sin(angle) * MAP_TICK_SPEED
		map_y += speed * cos(angle) * MAP_TICK_SPEED
		UpdatePosition()

/obj/map_point/port/test/New()
	var/cityname = pick(citynames)
	citynames -= cityname
	name = dd_replacetext(pick(cityfixes),"X",cityname)
	. = ..()

var/list/cityfixes = list("X City", "Xton", "Xpolis", "Fort X", "Xville", "X Square", "X Junction", "Xley")
var/list/citynames = list("Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot","Golf", "Hotel", "India", "Juliett",
						  "Kilo", "Lima", "Mike", "November", "Oscar", "Papa", "Quebec", "Romeo", "Sierra", "Tango",
						  "Uniform", "Victor", "Whiskey", "Xray", "Yankee", "Zulu")