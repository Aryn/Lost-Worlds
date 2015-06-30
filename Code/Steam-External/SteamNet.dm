var/steam_controller/steam_controller = new

hook/game_start/proc/StartSteam()
	for(var/structure/steam/equipment)
		equipment.SteamSetup()
	for(var/structure/steam/node/node)
		node.FindNet()
	return TRUE

/structure/steam/proc/SteamSetup()

/steam_controller
	var/list/updates = list()

	proc/CanConnect(structure/steam/node/A, structure/steam/node/B)
		return A.CanConnect(B, get_dir(A,B)) && B.CanConnect(A, get_dir(B,A))

	proc/Merge(steam_net/A, steam_net/B)
		if(A.nodes.len < B.nodes.len)
			A.Merge(B)
		else
			B.Merge(A)

	proc/Tick()
		var/old_nets = updates.len //New nets are added to the end of the list, so this spares any that were created by rebuild().
		for(var/i = 1, i <= old_nets, i++)
			var/steam_net/net = updates[i]
			if(net.status & PIPE_INVALID) continue
			if(net.status & PIPE_NEED_UPDATE)
				net.update()
			if(net.status & PIPE_NEED_REBUILD)
				net.rebuild()
			net.status &= PIPE_INVALID //Clear update flags.
		updates.Cut(1,old_nets+1)

	proc/Mark(steam_net/net, status)
		if(net.status == PIPE_NORMAL) updates.Add(net)
		net.status |= status

/steam_fluid
	var/name
	var/delta_in
	var/delta_out

	proc/Differential(exclude = 0)
		return delta_in - (delta_out - exclude)

	proc/ChangeDelta(net, old_value, new_value)
		if(old_value > 0) delta_in -= old_value
		else delta_out -= -old_value

		if(new_value > 0) delta_in += new_value
		else delta_out += -new_value

		steam_controller.Mark(net, PIPE_NEED_UPDATE)

	New(name)
		src.name = name

/steam_net
	var/list/nodes = list() //The set of all pipes and machines in this network.
	var/list/updating_nodes = list()
	var/list/leaks
	var/status = PIPE_NORMAL

	var/list/fluids = list()
	var/steam_fluid/steam = new("Steam")

	//var/delta_in = 0
	//var/delta_out = 0

	New(structure/steam/init)
		if(init) Add(init)
		fluids["Steam"] = steam

	proc/ChangeFluid(name, old_value, new_value)
		var/steam_fluid/fluid = fluids[name]
		if(!fluid)
			fluid = new(name)
			fluids[name] = fluid
		fluid.ChangeDelta(src,old_value,new_value)

	proc/Add(structure/steam/node/equipment)
		if(isturf(equipment)) return addLeak(equipment)

		if(equipment.net == src) CRASH("Added equipment to net it is already contained in.")
		if(IS_VALID(equipment.net)) CRASH("Added equipment to net which already has a valid net. Use Merge() instead.")

		nodes.Add(equipment)
		if(istype(equipment,/structure/steam/node/updating)) updating_nodes.Add(equipment)
		equipment.NetChanged(src)
		equipment.net = src

		steam.ChangeDelta(src, 0, equipment.energy_delta)

	proc/Remove(structure/steam/node/equipment)
		if(isturf(equipment)) return removeLeak(equipment)

		if(equipment.net != src) CRASH("Removed equipment from net it is not contained in.")

		nodes.Remove(equipment)
		if(istype(equipment,/structure/steam/node/updating)) updating_nodes.Remove(equipment)
		equipment.NetChanged(null)
		equipment.net = null

		steam.ChangeDelta(src, equipment.energy_delta, 0)

	proc/Merge(steam_net/other)
		if(status & PIPE_INVALID) CRASH("Cannot merge PIPE_INVALID net.")
		if(other.status & PIPE_INVALID) CRASH("Cannot merge into PIPE_INVALID net.")

		status |= PIPE_INVALID
		for(var/structure/steam/node/node in nodes)
			node.NetChanged(other)
			other.Add(node)

	proc/Split()
		steam_controller.Mark(src, PIPE_NEED_REBUILD)

	proc/addLeak(turf/T)
		if(!leaks) leaks = list()
		leaks.Add(T)

	proc/removeLeak(turf/T, from_list = TRUE)
		leaks.Remove(T)
		if(leaks.len == 0) leaks = null

	proc/rebuild()
		status |= PIPE_INVALID
		for(var/turf/T in leaks)
			removeLeak(T, FALSE)
		for(var/structure/steam/node/node in nodes)
			node.FindNet()

	proc/update()
		if(status & PIPE_INVALID) return
		for(var/structure/steam/node/updating/node in nodes)
			node.NetUpdate()