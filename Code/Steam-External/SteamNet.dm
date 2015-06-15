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
			if(net.status & INVALID) continue
			if(net.status & NEED_UPDATE)
				net.update()
			if(net.status & NEED_REBUILD)
				net.rebuild()
			net.status &= INVALID //Clear update flags.
		updates.Cut(1,old_nets+1)

	proc/Mark(steam_net/net, status)
		if(net.status == NORMAL) updates.Add(net)
		net.status |= status

/steam_net
	var/list/nodes = list() //The set of all pipes and machines in this network.
	var/list/leaks
	var/status = NORMAL

	var/delta_in = 0
	var/delta_out = 0

	New(structure/steam/init)
		if(init) Add(init)

	proc/Differential(exclude = 0)
		return delta_in - (delta_out - exclude)

	proc/Add(structure/steam/node/equipment)
		if(isturf(equipment)) return addLeak(equipment)

		if(equipment.net == src) CRASH("Added equipment to net it is already contained in.")
		if(IS_VALID(equipment.net)) CRASH("Added equipment to net which already has a valid net. Use Merge() instead.")

		nodes.Add(equipment)
		equipment.net = src

		ChangePower(0, equipment.energy_delta)

	proc/Remove(structure/steam/node/equipment)
		if(isturf(equipment)) return removeLeak(equipment)

		if(equipment.net != src) CRASH("Removed equipment from net it is not contained in.")

		nodes.Remove(equipment)
		equipment.net = null

		ChangePower(equipment.energy_delta, 0)

	proc/ChangePower(old_power, new_power)
		if(old_power > 0) delta_in -= old_power
		else delta_out -= -old_power

		if(new_power > 0) delta_in += new_power
		else delta_out += -new_power

		steam_controller.Mark(src, NEED_UPDATE)

	proc/Merge(steam_net/other)
		if(status & INVALID) CRASH("Cannot merge invalid net.")
		if(other.status & INVALID) CRASH("Cannot merge into invalid net.")

		status |= INVALID
		for(var/structure/steam/node/node in nodes)
			node.NetChanged(other)
			other.Add(node)

	proc/Split()
		steam_controller.Mark(src, NEED_REBUILD)

	proc/addLeak(turf/T)
		if(!leaks) leaks = list()
		leaks.Add(T)

	proc/removeLeak(turf/T, from_list = TRUE)
		leaks.Remove(T)
		if(leaks.len == 0) leaks = null

	proc/rebuild()
		status |= INVALID
		for(var/turf/T in leaks)
			removeLeak(T, FALSE)
		for(var/structure/steam/node/node in nodes)
			node.FindNet()

	proc/update()
		for(var/structure/steam/node/node in nodes)
			node.NetUpdate()