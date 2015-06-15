var/game/game = new

client/var/in_game = FALSE

/game
	var/started = FALSE
	var/list/players = new  //Players in this round, including ghosts.

	var/ports_in_route = 4
	var/departure_time
	var/accumulated_time = 0

	var/in_transit = FALSE
	var/obj/map_point/port/selected
	var/list/route = list()
	var/world_map/map = new

	var/list/all_cargo = list()
	var/points = 0

/game/proc/Initialize()
	for(var/cargo_type in typesof(/data/cargo_box) - /data/cargo_box)
		//log_warning("Cargo Type Added: [cargo_type]")
		var/data/cargo_box/cargo = new cargo_type
		all_cargo.Add(cargo)

	map.Initialize()

	for(var/structure/marker/initial/marker)
		marker.Initialize()
		marker.Erase()

	dead_matrix = new
	dead_matrix.Turn(90)
	dead_matrix.Translate(0,-10)

	//SelectRoute()

	CallHook("game_start")

/game/proc/NumberOfPorts()
	return map.ports.len


/game/proc/Start(route_type/route_type) //num_ports, home_at_end = FALSE)
	//Initialize ports
	ports_in_route = route_type.num_ports

	//Zero everything
	if(started)
		accumulated_time = 0
		started = FALSE
		route.Cut()
		for(var/obj/port in map.ports)
			port.icon_state = "port"

	world << "\green Selecting Route..."
	var/list/available_ports = map.ports.Copy()

	//Pick starting port.
	var/obj/map_point/port/start = pick(available_ports)
	selected = start
	if(route_type.is_circular)
		start.icon_state = "home"
	else
		start.icon_state = "start"
	available_ports.Remove(start)

	//Add starting point to the route, marking it home if route is circular.
	var/data/port/home_data = new /data/port(start, START|(route_type.is_circular ? HOME : 0))
	route.Add(start)
	start.route_data = home_data

	var/total_time = 0 //For debug purposes.
	var/subtracted_value = 0 //Tracks total profit value of all ports.

	for(var/i = 1, i < ports_in_route, i++)
		//Sort ports in order of distance from the current one.
		var/choice = route_type.NextPort(available_ports)

		//Select new port, kicking previous port into old_port.
		var/obj/map_point/port/old_port = selected
		selected = available_ports[choice]

		//Mark it visually on the map.
		selected.icon_state = "route"

		//Remove port from available selections and add it to route.
		available_ports.Remove(selected)
		route.Add(selected)

		//Make its route data, including cargo.
		selected.route_data = new/data/port(selected)

		//Ensure an even profit distribution over ports. TODO: The math is a bit sketchy, might need improvement.
		selected.route_data.value -= subtracted_value
		subtracted_value += (start.route_data.value/ports_in_route) //For example, why is starting port value used here?

		//Tracking total route time based on ship speed and distance.
		total_time += round(sqrt(DISTSQ(selected.map_x-old_port.map_x,selected.map_y-old_port.map_y)) / (map.ship.speed*10))

	if(!route_type.is_circular)
		selected.icon_state = "home"
		home_data = selected.route_data
		home_data.flags = HOME
		route.Remove(start)
	else
		var/added_time = round(sqrt(DISTSQ(selected.map_x-start.map_x,selected.map_y-start.map_y)) / (map.ship.speed*10))
		total_time += added_time
		//world << "Return Time: [parse_time(added_time)]"
	selected = start
	map.ship.SetPosition(start.map_x,start.map_y)
	selected = null

	world << "Route ETC: [parse_time(total_time)]"
	world << "([parse_time(STD_CONVERSION(total_time))] Standard)"
	start.route_data.LoadCargo()
	started = TRUE

	WeatherReport()

	game.map.ship.at_port = start.route_data

game/proc/Arrived()
	map.ship.at_port = selected.route_data
	world << "\green Arrived at [selected]."
	var/total_seconds = (world.time - departure_time)/10
	world << "Travel Time: [parse_time(total_seconds)]"
	world << "([parse_time(STD_CONVERSION(total_seconds))] Standard)"
	var/obj/map_point/port = selected
	var/data/port/port_data = selected.route_data
	if(port_data)
		route.Remove(port)
		//port_data.UnloadCargo()
		if(port_data.flags & HOME)
			if(route.len > 1)
				world << "\red MISSION FAILURE"
				world << "Points: [points]"
			else
				world << "\green MISSION COMPLETE"
				world << "Points: [points]"
		else if(!port_data.visited)
			port_data.LoadCargo()
			port.icon_state = "visited"
			world << "\green [route.len] destinations ahead."

	selected = null

game/proc/Departed(data/port/port)
	world << "\green Departed from [port.point]."
	var/obj/map_point/point = port.point
	if(port)
		if((port.flags & START) && route.len > 1)
			cargo = new/cargo_controller/test
		else
			route.Remove(point)
			if(!port.unloaded_cargo)
				port.UnloadCargo()

/game/proc/TickMap()
	map.Storms()
	if(selected && game.started)
		if(!in_transit)
			engine_sound.Play()
		in_transit = TRUE
		map.ship.FlyTo(selected.map_x,selected.map_y)
	else
		if(in_transit)
			engine_sound.Stop()
		in_transit = FALSE

/game/proc/TickCharacters()
	for(var/character/C) C.Life()

/game/proc/PlaceCharacters()
	started = TRUE
	for(var/client/C in players)
		if(C.mob.type == /mob/login)
			MakeCharacter(C.mob)


/game/proc/MakeCharacter(mob/login/login)
	winshow(login,"charselect",0)

	var/character/humanoid/human/P = new(GetTurf(locate(/structure/marker)))
	login.selected.WriteToPlayer(P)
	//P.SetupEquipmentSlots()
	//P.SetupDamage()

	if(started)
		var/item_slot/fill = P.ItemSlot("shirt")
		fill.ForceEquip(new/item/clothing/shirt/assistant(P))
		fill = P.ItemSlot("trousers")
		fill.ForceEquip(new/item/clothing/trousers/assistant(P))
		fill = P.ItemSlot("coat")
		fill.ForceEquip(new/item/clothing/coat/brown(P))
	else
		CRASH("Job-based equipment needs implementation.")


	P.client = login.client