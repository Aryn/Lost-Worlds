

var/game/game = new

client/var/in_game = false

/game
	var/started = true
	var/map_ticks = false
	var/char_ticks = false
	var/RefSortedList/players = new  //Players in this round, including ghosts.

	var/ports_in_route = 4
	var/departure_time
	var/accumulated_time = 0

	var/in_transit = false
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

	lighting_controller = new

	for(var/structure/marker/erasing/marker)
		marker.Initialize()
		marker.Erase()

	lighting_controller.Initialize()

	for(var/structure/table/T)
		T.Join()

	dead_matrix = new
	dead_matrix.Turn(90)
	dead_matrix.Translate(0,-10)

	SelectRoute()

	spawn TickCharacters()


/game/proc/SelectRoute(home_at_end = false)
	accumulated_time = 0
	started = false
	route.Cut()
	for(var/obj/port in map.ports)
		port.icon_state = "port"

	world << "\green Selecting Route:"
	var/list/ports = map.ports.Copy()

	var/obj/map_point/port/start = pick(ports)
	selected = start
	if(home_at_end)
		start.icon_state = "start"
	else
		start.icon_state = "home"
	//world << "Starting Port: [selected]"
	ports.Remove(start)
	var/data/port/home_data = new /data/port(start, START|(home_at_end ? 0 : HOME))
	route.Add(start)
	start.route_data = home_data

	var/total_time = 0
	sleep(10)

	var/subtracted_value = 0

	for(var/i = 1, i < ports_in_route, i++)
		QuickSort(ports, /proc/Closest)

		var/choice = rand(1,min(4,ports.len))
		var/obj/map_point/port/old_port = selected
		selected = ports[choice]
		selected.icon_state = "route"
		world << "Selected: [selected] (Port [choice])"
		ports.Remove(selected)
		route.Add(selected)
		selected.route_data = new/data/port(selected)
		selected.route_data.value -= subtracted_value

		var/added_time = round(sqrt(DISTSQ(selected.map_x-old_port.map_x,selected.map_y-old_port.map_y)) / (map.ship.speed*10))
		total_time += added_time
		//world << "Time added: [parse_time(added_time)]"

		subtracted_value += (start.route_data.value/ports_in_route)

	if(home_at_end)
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
	started = true
	world << "Weather Report:"
	NextCity:
		for(var/obj/map_point/port/P in route)
			for(var/obj/map_point/storm/storm in map.storms.contents)
				if(DISTSQ(storm.map_x - P.map_x, storm.map_y - P.map_y) < SQ(32))
					world << " - [storm.storm_type] storms near [P]"
					break NextCity


	if(!map_ticks) spawn TickMap()

game/proc/Arrived()
	world << "\green Arrived at [selected]."
	var/total_seconds = (world.time - departure_time)/10
	world << "Travel Time: [parse_time(total_seconds)]"
	world << "([parse_time(STD_CONVERSION(total_seconds))] Standard)"
	var/obj/map_point/port = selected
	var/data/port/port_data = selected.route_data
	if(port_data)
		route.Remove(port)
		port_data.UnloadCargo()
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

/game/proc/TickMap()
	map_ticks = true
	while(map_ticks)
		sleep(MAP_TICK_SPEED)
		map.Storms()
		if(selected && game.started)
			if(!in_transit)
				engine_sound.Play()
			in_transit = true
			map.ship.FlyTo(selected.map_x,selected.map_y)
		else
			if(in_transit)
				engine_sound.Stop()
			in_transit = false

/game/proc/TickCharacters()
	char_ticks = true
	while(char_ticks)
		sleep(LIFE_TICK_SPEED)
		for(var/character/C) C.Life()

/proc/Closest(obj/map_point/port/A, obj/map_point/port/B)
	ASSERT(A)
	ASSERT(B)
	ASSERT(game)
	ASSERT(game.selected)
	var/distsq_a = DISTSQ(A.map_x - game.selected.map_x, A.map_y - game.selected.map_y)
	var/distsq_b = DISTSQ(B.map_x - game.selected.map_x, B.map_y - game.selected.map_y)

	return distsq_a - distsq_b

/game/proc/PlaceCharacters()
	started = true
	for(var/client/C in players)
		if(C.mob.type == /mob/login)
			MakeCharacter(C.mob)


/game/proc/MakeCharacter(mob/login/login)
	winshow(login,"charselect",0)

	var/character/humanoid/human/P = new(get_turf(locate(/structure/marker)))
	login.selected.WriteToPlayer(P)
	P.SetupEquipmentSlots()
	P.SetupDamage()

	if(started)
		var/inv_slot/fill = P.slots["Shirt"]
		fill.Set(new/item/clothing/shirt/assistant(P))
		fill = P.slots["Trousers"]
		fill.Set(new/item/clothing/trousers/assistant(P))
	else
		CRASH("Job-based equipment needs implementation.")


	P.client = login.client