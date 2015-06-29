/structure/steam/node
	var/pipe_dirs = 0 //Direction flags indicating which direction this can connect.
	var/sealed_dirs = 0 //Direction flags indicating which pipe directions allow no flow, but do not leak.
	var/energy_delta = 0 //The amount of energy added to or drained from the system at rest.
	var/leak_dirs = 0

	var/steam_net/net

	proc/FindNet()
		var/leaks = pipe_dirs

		for(var/from_src = 1, from_src <= 32, from_src = from_src << 1)
			if(!(pipe_dirs & from_src)) continue //Not counted as leak, leaks is initialised only to pipe_dirs.

			var/turf/adjacent = get_step(src,from_src)
			if(!adjacent) continue

			var/to_src = turn(from_src,180)

			for(var/structure/steam/node/other in adjacent)
				if(!steam_controller.CanConnect(src,other)) continue //leak!

				leaks &= ~from_src
				if(other.leak_dirs & to_src)
					ASSERT(other.net) //We're assuming that if the other pipe has a leak, it has a net to manage the leak.
					other.net.Remove(loc)
					other.leak_dirs &= ~to_src

				if(sealed_dirs & from_src || other.sealed_dirs & to_src) continue //One of the pipes is sealed. Stop after removing potential leaks.
				if(!IS_VALID(other.net) || other.net == net) continue //The other pipe will get a net later.

				//The other pipe has a valid net.
				if(!IS_VALID(net))
					other.net.Add(src)
				else
					steam_controller.Merge(net,other.net)

		if(!IS_VALID(net))
			new/steam_net(src)

	proc/CanConnect(structure/steam/node/other, direction)
		if(pipe_dirs & direction == 0) return FALSE
		return TRUE

	proc/NetChanged(steam_net/net)

/structure/steam/node/updating/proc/NetUpdate()