/item/var/cargo_value = 0

/data/stock
	var/number
	var/list/destinations

/data/stock/New(n, dest)
	number = n
	if(dest) destinations = list(dest)

/data/port //Used by the game when a port is selected as part of the route.
	var/obj/map_point/port/point
	var/visited = FALSE
	var/value = 800 //Minimum total value of the cargo at this port.
	var/flags = 0

	var/list/cargo_dropoff = list()

	New(obj/map_point/port/point, flags)
		src.point = point
		src.flags = flags

	proc/LoadCargo()
		var/value_left = value
		game.selected = point
		var/list/destinations = game.route.Copy() - point
		var/common_dest = rand(1,3)

		QuickSort(destinations, /proc/Closest)
		while(value_left > 0 && destinations.len)
			var/data/cargo_box/box = pick(game.all_cargo)
			value_left -= box.value

			var/obj/map_point/port/destination = destinations[min(pick(1,2,3,common_dest,common_dest),destinations.len)]
			test_carried_cargo.Add(box)
			destination.route_data.cargo_dropoff.Add(box)

			var/boxname = dd_text2list("[box]","/")
			boxname = boxname[length(boxname)]

			var/data/stock/stock = stock_list[boxname]
			if(stock)
				stock.number++
				stock.destinations |= destination.name
			else
				stock_list[boxname] = new/data/stock(1,destination.name)

		world << "\red Stock:"
		for(var/stock_name in stock_list)
			world << "[stock_name]: \..."
			var/data/stock/stock = stock_list[stock_name]
			world << "[stock.number] to [dd_list2text(stock.destinations, ", ")]"
		world << "Carrying [test_carried_cargo.len] boxes."
		game.selected = null

	proc/UnloadCargo()
		var/list/dropped_off = list()
		for(var/i = 1, i <= test_carried_cargo.len, i++)
			var/data/cargo_box/box = test_carried_cargo[i]
			if(box in cargo_dropoff)
				var/boxname = dd_text2list("[box]","/")
				boxname = boxname[length(boxname)]

				var/data/stock/stock = stock_list[boxname]
				if(stock)
					stock.number--
					stock.destinations.Remove(point.name)
				dropped_off[boxname]++
				game.points += box.value
				test_carried_cargo.Cut(i,i+1)
				cargo_dropoff.Remove(box)
				i--
		world << "<u>Dropped Off</u>"
		for(var/box in dropped_off)
			world << "[dropped_off[box]] boxes of [box]"



var/list/test_carried_cargo = list()
var/list/stock_list = list()


/data/cargo_box
	var/boxtype = /structure/box //Determines box type.
	var/list/items               //Expected items in the box.
	var/value                    //Value of items in the box.

/data/cargo_box/proc/Assemble(turf/T) //Makes the box and puts items inside.
	var/structure/box = new boxtype(T)
	var/computed_value = 0
	for(var/item_type in items)
		var/n = items[item_type]
		if(!n) n = 1
		for(var/i = 1, i <= n, i++)
			var/item/I = new item_type(box)
			computed_value += I.cargo_value
	if(computed_value != value)
		log_warning("[src] Value: Computed [computed_value], expected [value].")