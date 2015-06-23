area/surface/loading_area/Arrajin
area/surface/loading_area/Devteros
area/surface/loading_area/Hirugard
area/surface/unloading_area
area/cargo_bay

hook/game_start/proc/SetupCargo()
	cargo = new/cargo_controller/direct_loading
	for(var/structure/marker/initial/cargo_box/marker)
		marker.Initialize()
	return TRUE

cargo_controller/direct_loading
	var/list/cargo_bay = list()

	New()
		var/area/area = locate(/area/cargo_bay) in world
		for(var/turf/loc in area)
			cargo_bay.Add(loc)

	Load(data/cargo_box/box, data/port/dest)
		looking_for_empty_tiles:
			for(var/n = 1, n <= cargo_bay.len*2, n++)
				var/turf/loc = pick(cargo_bay)
				for(var/atom/atom in loc)
					if(atom.density) continue looking_for_empty_tiles

				box.Assemble(loc, dest.point.name)
				break

	Unload()
		CRASH("Cannot unload with direct loading cargo controller. Switch to another type.")

cargo_controller/test
	var/list/loading_areas = list()
	var/list/unloading_area = list()

	New()
		world << "\red Switched cargo controllers."

		for(var/area/surface/loading_area/area in world)
			world << "Loading Area: [area.name]"
			var/list/loading_area = loading_areas[area.name]
			if(!loading_area)
				loading_area = list()
				loading_areas[area.name] = loading_area

			for(var/turf/loc in area)
				loading_area.Add(loc)

		for(var/area/surface/unloading_area/area in world)
			for(var/turf/loc in area)
				unloading_area.Add(loc)


	Load(data/cargo_box/box, data/port/dest)
		var/list/loading_area = loading_areas[game.selected.nation.name]
		looking_for_empty_tiles:
			for(var/n = 1, n <= loading_area.len*2, n++)
				var/turf/loc = pick(loading_area)
				for(var/atom/atom in loc)
					if(atom.density) continue looking_for_empty_tiles

				box.Assemble(loc, dest.point.name)
				break

	Unload(data/cargo_box/box, data/port/dest)
		var/structure/lockable/box/best_match
		var/best_ratio = 0.5
		for(var/turf/loc in unloading_area)
			for(var/structure/lockable/box/obj in loc)
				var/match_ratio = box.Check(obj, dest)
				if(match_ratio > 0.95 && match_ratio < 1.05)
					world << "\green Total Match For [box]: [obj.x], [obj.y], [obj.z]"
					obj.Erase()
					return box.value
				else if(match_ratio > best_ratio)
					best_match = obj
					best_ratio = match_ratio

		if(best_match)
			best_match.Erase()
			if(best_ratio > 1) best_ratio = 1/best_ratio
			world << "<font color=#FFFF00>Partial Match For [box] at [round(best_ratio*100)]%: [best_match.x], [best_match.y], [best_match.z]</font>"
			return best_ratio * box.value
		world << "\red No Match For: [box]"
		return 0

structure/marker/initial/cargo_box
	name = "Cargo Box"
	var/data/cargo_box/cargo_type = "/data/cargo_box/valuables"

	Initialize()
		var/cargo_type_p = text2path(cargo_type)
		if(!ispath(cargo_type_p))
			log_critical("No such path: [cargo_type]")
		else
			cargo_type = new cargo_type_p()
			cargo_type.Assemble(loc)

structure/marker/landing_site