mob/var/can_control_ship = FALSE
mob/verb/CloseMap()
	set hidden = 1
	game.map.StopShowing(src)

/world_map
	var/list/ports = list()
	var/obj/map_borders/map_borders = new
	var/obj/map_grid/map_grid = new
	var/list/storms = new
	var/list/icons = new
	var/obj/map_point/ship/ship
	var/icon/border_icon

	var/list/viewing_mobs = list()

	proc/Initialize()
		border_icon = icon('Textures/Borders/Borders-1.png')
		for(var/i = citynames.len, i > 0, i--)
			var/x
			var/y
			var/done = FALSE
			var/iterations = 40
			do
				x = rand(32,624)
				y = rand(32,464)
				done = TRUE
				for(var/obj/map_point/port/existing_port in ports)
					if(DISTSQ(x-existing_port.map_x, y-existing_port.map_y) < SQ(64))
						done = FALSE
				iterations--
			while(!done && iterations > 0)
			var/obj/map_point/port/test/port = new(x,y)

			var/nation_color = game.map.border_icon.GetPixel(x,y)
			if(nations[nation_color])
				port.nation = nations[nation_color]
			else
				CRASH("Port spawned on unidentified territory color @ [x], [y]: [nation_color]")

			if(!iterations) spawn(10) world << "\red Port failed: [port]"
			icons.Add(port)
			ports.Add(port)
		ship = new(0,0)
		icons.Add(ship)

	proc/ShowTo(mob/M, can_control_ship=FALSE)
		world << "Showing the world map to [M]"
		if(M.client)
			if(istype(M,/character)) M.can_control_ship = can_control_ship
			winshow(M,"worldmap",1)
			viewing_mobs.Add(M)
			world << "Map BG"
			M.client.screen += map_borders
			M.client.screen += map_grid
			world << "Icons: [icons.len]"
			M.client.screen += icons

	proc/StopShowing(mob/M)
		M.can_control_ship = FALSE
		if(M.client)
			winshow(M,"worldmap",0)
			M.client.screen -= icons
			M.client.screen -= map_grid
			M.client.screen -= map_borders
		viewing_mobs.Remove(M)

	proc/ShowIcon(obj/O)
		//world << "Showing [O]"
		icons.Add(O)
		for(var/mob/M in viewing_mobs)
			M.client.screen += O

	proc/EraseIcon(obj/O)
		//world << "Unshowing [O]"
		icons.Remove(O)
		for(var/mob/M in viewing_mobs)
			M.client.screen -= O

/obj/map_point
	icon = 'Icons/HUD/MapPoints.dmi'
	layer = 3
	pixel_x = -8
	pixel_y = -8

	var/map_x
	var/map_y

	New(x,y)
		map_x = x
		map_y = y
		UpdatePosition()

/obj/map_grid
	icon = 'Textures/Borders/Legend-1.png'
	screen_loc = "WorldMap:1,1"
	layer = 2
/obj/map_borders
	icon = 'Textures/Borders/Borders-1.png'
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
	var/nation/nation
	New(x,y)
		. = ..(x,y)
		text_overlay = image(loc=src)
		text_overlay.maptext_width = 128
		text_overlay.maptext_height = 16
		text_overlay.maptext = "<small><font color=black>[name]</small></font>"
		text_overlay.pixel_y = -10
		text_overlay.pixel_x = -(length(name)*2)
		overlays += text_overlay

	Click(location,control,params)
		if(findtext(params,"right"))
			world << "<u>[name]</u>"
			world << "Nation: [nation]"
			var/dist = sqrt(DISTSQ(map_x-game.map.ship.map_x, map_y-game.map.ship.map_y))
			var/time = dist / (game.map.ship.speed*10)
			world << "Distance: [dist]u"
			world << "Travel Time: [parse_time(time)] / [parse_time(time*(MAP_TIMESCALE/STANDARD_TIMESCALE))] standard"
		else
			game.selected = src
			game.departure_time = world.time
			var/dist = sqrt(DISTSQ(map_x-game.map.ship.map_x, map_y-game.map.ship.map_y))
			var/time = dist / (game.map.ship.speed*10)
			game.accumulated_time += time
			world << "ETA: [parse_time(time)]"
			//game.map.ship.SetPosition(map_x,map_y)

/obj/map_point/port/test/New()
	var/cityname = pick(citynames)
	citynames -= cityname
	name = dd_replacetext(pick(cityfixes),"X",cityname)
	. = ..()

var/list/cityfixes = list("X City", "Xton", "Xpolis", "Fort X", "Xville", "X Square", "X Junction", "Xley", "Xford", "Xshire")
var/list/citynames = list("Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot","Golf", "Hotel", "India", "Juliett",
						  "Kilo", "Lima", "Mike", "November", "Oscar", "Papa", "Quebec", "Romeo", "Sierra", "Tango",
						  "Uniform", "Victor", "Whiskey", "Xray", "Yankee", "Zulu")