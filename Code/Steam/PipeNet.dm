var/pipe_controller/pipecontroller = new

hook/game_start/proc/SetupPipeNets()
	world << "Setting up pipes..."
	for(var/structure/steam/pipe/P)
		P.FindNet()
	world << "Done."

	spawn pipecontroller.Loop()
	return 1

/pipe_controller

	var/list/nets = list()
	var/use_colors = FALSE

	proc/Loop()
		world << "Started Pipe Controller"
		while(1)
			sleep(5)
			Tick()

	proc/Tick()
		//var/rebuilds = 0
		//var/removals = 0
		for(var/i = 1, i <= nets.len, i++)
			//world << "Net [i]: \..."
			var/pipenet/net = nets[i]
			if(net.invalid)
				//removals++
				//world << "Invalid"
				nets.Cut(i,i+1)
			else if(net.rebuild)
				//rebuilds++
				//world << "Rebuilding"
				net.Rebuild()
			else
				//world << "Nominal"
				net.Update()
		//world << "Nets Rebuilt: [rebuilds], Nets Removed: [removals]"


	proc/Merge(pipenet/A, pipenet/B)
		if(A.pipes.len > B.pipes.len)
			B.MergeTo(A)
		else
			A.MergeTo(B)

/pipenet
	var/list/pipes = list()
	var/list/machines = list()
	var/list/breaks = list()

	var/invalid = FALSE

	//Do not rely on the raw value of these variables to operate machinery.
	//Use differential(), because cyclic pump setups can easily inflate these arbitrarily.
	var/_delta_in = 0
	var/_delta_out = 0

	var/machine_updates = 0
	var/rebuild = 0

	New()
		pipecontroller.nets.Add(src)
		. = ..()

	proc/differential(exclude)
		return _delta_in - (_delta_out - exclude)

	proc/AddPipe(structure/steam/pipe/P)
		pipes.Add(P)
		P.net = src

	proc/RemovePipe(structure/steam/pipe/P)
		pipes.Remove(P)
		P.net = null

	proc/AddBreak(turf/T)
		breaks.Add(T)
		PullPower(5)
		#ifdef DBG_COLORS
		if(T.exposed_tile) T.exposed_tile.color = "#FF5555"
		else T.color = "#FF5555"
		#endif

	proc/RemoveBreak(turf/T)
		breaks.Remove(T)
		PullPower(-5)
		#ifdef DBG_COLORS
		if(T.exposed_tile) T.exposed_tile.color = "#FFFFFF"
		else T.color = "#FFFFFF"
		#endif

	proc/MergeTo(pipenet/other)
		for(var/structure/steam/pipe/P in pipes)
			P.net = other
			other.pipes.Add(P)
			#ifdef DBG_COLORS
			P.color = "#55FFFF"
			#endif
		invalid = TRUE
		for(var/structure/steam/powered/P in machines)
			P.swap(src,other)

	proc/PushPower(n)
		_delta_in += n
		machine_updates = 1

	proc/PullPower(n)
		_delta_out += n
		machine_updates = 1

	proc/Update()
		if(machine_updates)
			for(var/structure/steam/powered/M in machines)
				M.power_update()
			machine_updates = 0

	proc/Rebuild()
		invalid = TRUE
		rebuild = FALSE
		for(var/turf/T in breaks)
			#ifdef DBG_COLORS
			if(T.exposed_tile) T.exposed_tile.color = "#FFFFFF"
			else T.color = "#FFFFFF"
			#endif
		breaks.Cut()
		for(var/structure/steam/powered/M in machines)
			M.disconnect(src)
		for(var/structure/steam/pipe/P in pipes)
			#ifdef DBG_COLORS
			P.color = "#FFFFFF"
			#endif
			P.FindNet()