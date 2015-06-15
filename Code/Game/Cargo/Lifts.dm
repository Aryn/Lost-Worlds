hook/game_start/proc/SetupLifts()
	for(var/structure/lift/anchor/anchor)
		anchor.SetupLift()
	return TRUE

/tile/lift
	name = "Lift"
	icon = 'Icons/Tiles/Lift.dmi'
	layer = 2.1
	var/lift/lift

/lift
	var/list/tiles = list()
	var/structure/anchor
	var/level = 0
	var/anchor_x
	var/anchor_y
	var/moving = FALSE

	New(tile/lift/start, structure/anchor)
		start.lift = src
		src.anchor = anchor
		anchor_x = anchor.x
		anchor_y = anchor.y
		var/list/open = list(start)

		while(open.len)
			for(var/tile/lift/central in open)
				for(var/d = 1, d < 16, d = d << 1)
					var/tile/lift/edge = locate() in get_step(central,d)
					if(edge && !edge.lift)
						edge.lift = src
						open.Add(edge)
				tiles.Add(central)
				central.color = "#00FF00"
				open.Remove(central)
				for(var/structure/lift/structure in central.loc)
					structure.Connect(src)


	proc/Move(x,y,z)
		for(var/tile/tile in tiles)
			var/target = locate((tile.x - anchor_x) + x,(tile.y - anchor_y) + y, z)

			world << "Moving Structures:"
			for(var/structure/structure in tile.loc)
				world << "[structure]: \..."
				if(structure.is_anchored && !istype(structure,/structure/lift))
					world << "\red Anchored."
					continue
				else
					world << "\green Moved."
					structure.fall_immune = TRUE
					structure.ForceMove(target)
					structure.fall_immune = FALSE

			world << "Moving Characters:"
			for(var/character/C in tile.loc)

				world << "[C]"
				C.fall_immune = TRUE
				C.ForceMove(target)
				C.fall_immune = FALSE

			world << "Moving tile."
			tile.ForceMove(target)


		anchor_x = x
		anchor_y = y

	proc/Start()
		if(!level)
			Move(anchor.x, anchor.y, anchor.z)
		else
			Move(anchor.x, anchor.y, anchor.z+1)

/lift/cargo
	Start()
		moving = TRUE
		var/tile/first = tiles[1]
		first.Sound('Sounds/Structure/Lift1.ogg')
		var/structure/marker/landing_site/air = locate("Airborne")
		if(!level)
			Move(air.x, air.y, air.z)
			sleep(10)
			Move(anchor.x, anchor.y, anchor.z)
			first.Sound('Sounds/Structure/Lift2.ogg')
		else
			var/structure/marker/landing_site/landing
			if(game.map.ship.at_port)
				Move(air.x, air.y, air.z)
				sleep(10)
				landing = locate(game.map.ship.at_port.point.nation.name)
				if(landing)
					Move(landing.x, landing.y, landing.z)
					first.Sound('Sounds/Structure/Lift2.ogg')
				else
					level = 0
			else
				landing = air
				if(landing)
					Move(landing.x, landing.y, landing.z)
					sleep(10)
					first.Sound('Sounds/Structure/Lift2.ogg')
				else
					level = 0
		moving = FALSE


structure/lift/proc/Connect(lift/lift)

structure/lift/anchor
	icon = 'Icons/Tiles/Lift.dmi'
	icon_state = "anchor"
	var/lift/lift

	proc/SetupLift()
		var/tile/lift/lift_tile = locate() in get_step(src,dir)
		if(lift_tile)
			lift = new(lift_tile,src)

structure/lift/anchor/cargo
	SetupLift()
		var/tile/lift/lift_tile = locate() in get_step(src,dir)
		if(lift_tile)
			lift = new/lift/cargo(lift_tile,src)

structure/lift/controls
	icon = 'Icons/Ship/Equipment/LiftConsole.dmi'
	density = TRUE
	is_anchored = TRUE
	var/lift/lift

	Connect(lift/lift)
		src.lift = lift

	Operated(character/user)
		if(lift)
			if(lift.moving) return
			if(!lift.level)
				lift.level++
				lift.Start()
			else
				lift.level--
				lift.Start()


		else user << "\red No Lift"


tile/lift_equipment
	icon = 'Icons/Tiles/Support.dmi'
	icon_state = "lifteq"
	layer = 1.9