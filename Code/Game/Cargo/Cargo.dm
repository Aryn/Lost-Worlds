#define NO_MATCH 0
#define FULL_MATCH -1

/item/var/cargo_value = 0
var/cargo_controller/cargo
var/list/carried_boxes = list()

/cargo_controller
	proc/Load(data/cargo_box/box, data/port/dest)
	proc/Unload(data/cargo_box/box, data/port/current)

/data/port //Used by the game when a port is selected as part of the route.
	var/obj/map_point/port/point
	var/visited = FALSE
	var/unloaded_cargo = FALSE
	var/value = 300 //Minimum total value of the cargo at this port.
	var/flags = 0

	var/list/cargo_dropoff = list()

	New(obj/map_point/port/point, flags)
		src.point = point
		src.flags = flags
		src.value += rand(-value/2,value/2)

	proc/LoadCargo()
		var/value_left = value
		var/box_count = 0

		//Get closest destinations for cargo.
		game.selected = point                             //Set so Closest is centered on the city.
		var/list/destinations = game.route.Copy() - point //Possible destinations.
		var/common_dest = rand(1,3)                       //Select a common destination.
		QuickSort(destinations, /proc/Closest)

		//Keep making new cargo until no more export value is left.
		while(value_left > 0 && destinations.len)

			var/data/cargo_box/box = pick(game.all_cargo) //Pick a box type.
			value_left -= box.value                       //Reduce value by this box's value.

			//Select a destination to send cargo to.
			var/obj/map_point/port/dest = destinations[min(pick(1,2,3,common_dest,common_dest),destinations.len)]
			dest.route_data.cargo_dropoff.Add(box)

			//Add the box to cargo bay.
			cargo.Load(box, dest.route_data)
			box_count++

			//Add it to stock.
			var/list/boxes
			if(!(dest.route_data in carried_boxes))
				boxes = list()
				carried_boxes[dest.route_data] = boxes
			else
				boxes = carried_boxes[dest.route_data]
			boxes.Add(box)

		world << "Loaded [box_count] boxes."
		game.selected = null

	proc/UnloadCargo()
		var/list/dropped_off = list()

		var/list/boxes = carried_boxes[src]
		for(var/data/cargo_box/box in boxes)
			game.points += cargo.Unload(box, point.route_data)
			dropped_off.Add(box)

		carried_boxes.Remove(src)

		world << "<u>Dropped Off</u>"
		for(var/box in dropped_off)
			world << "[dropped_off[box]] boxes of [box]"

		unloaded_cargo = TRUE


/data/cargo_box
	var/boxtype = /structure/box //Determines box type.
	var/list/items               //Expected items in the box.
	var/value                    //Value of items in the box.

/data/cargo_box/proc/Assemble(turf/T, label) //Makes the box and puts items inside.
	var/structure/box/box = new boxtype(T)
	var/computed_value = 0
	for(var/item_type in items)
		var/n = items[item_type]
		if(!n) n = 1
		//world << "- [item_type] x[n]"
		for(var/i = 1, i <= n, i++)
			var/item/I = new item_type(box)
			computed_value += I.cargo_value
	if(computed_value != value)
		log_warning("[src] Value: Computed [computed_value], expected [value].")

	box.destination_tag = label
	box.desc = "\[Destination: [label]\]"

/data/cargo_box/proc/Check(structure/box/B, data/port/dest)
	if(B.destination_tag != dest.point.name) return 0
	var/list/remaining_items = items.Copy()
	var/matching_number = 0
	var/required_number = 0

	for(var/item_type in remaining_items)
		var/item_count = remaining_items[item_type]
		if(!item_count) item_count = 1
		required_number += item_count

	for(var/item/item in B)
		if(item.type in items)
			//world << "<small>[item.type]</small>"
			remaining_items[item.type]--
			matching_number++
			if(remaining_items[item.type] <= 0)
				remaining_items.Remove(item.type)
				//world << "<small><font color=#00FF00>Matched all [item.type]</font></small>"

		check_inner(item, remaining_items)

	//world << "Found [matching_number] of [required_number] matching items."
	/*world << "Unmatched Items:"
	for(var/type in remaining_items)
		world << " - [type] x[remaining_items[type]]"*/
	return matching_number / required_number

/data/cargo_box/proc/check_inner(item/container, list/remaining_items)
	for(var/item/item in container)
		if(item.type in items) . += 1
		else . += check_inner(item)