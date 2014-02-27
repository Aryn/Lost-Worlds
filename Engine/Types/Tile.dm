/*
Substitute for /turf that's easier on the CPU to change and has less undocumented bugs^H^H^H^Hfeatures.
Examples: Wall, floor, lattice. Exception: sky/space, which is a real turf.

Each turf has an exposed_tile, which is the uppermost tile in the turf. If you need to quickly check the topmost tile,
or whether a turf has any tiles on it, use that. Think of it as a peek operation on the tile stack.
*/

/tile
	parent_type = /obj
	name = "Tile"
	layer = 2

	New(loc)
		if(isturf(loc)) CheckExposed(loc)

	Erase()
		if(isturf(loc))
			var/turf/turf = loc
			if(turf.exposed_tile == src)
				turf.exposed_tile = null
				for(var/tile/tile in turf)
					tile.CheckExposed(turf)

	proc/CheckExposed(turf/turf)
		if(!turf.exposed_tile || layer >= turf.exposed_tile.layer)
			turf.exposed_tile = src

/turf/var/tile/exposed_tile