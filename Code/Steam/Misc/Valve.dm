structure/steam/powered/valve
	name = "Valve"
	icon = 'Icons/Ship/Equipment/Steam/Pipe.dmi'
	icon_state = "valve-open"
	connect_dir = 0

	var/is_open = 1
	var/structure/steam/pipe/pipe

	commands = list(
	new/command("Toggle", ALL, "Toggle the valve.")
	)

	Description()
		return "A hand-operated valve. The valve is currently [is_open ? "open" : "closed"]."

	OperatedBy(mob/M)
		Toggle()

	proc/Toggle()
		var/structure/steam/pipe/pipe = locate() in loc
		if(is_open)
			close(pipe)
		else
			open(pipe)

	proc/close()
		pipe.sealed = 15
		pipe.net.rebuild = TRUE
		icon_state = "valve-closed"
		is_open = 0

	proc/open()
		pipe.sealed = 0
		pipe.net.rebuild = TRUE
		icon_state = "valve-open"
		is_open = 1


	connect(structure/steam/pipe/pipe, dir)
		if(dir != 0 || pipe == src.pipe) return 0
		src.pipe = pipe
		if(!is_open) close()
		return 1

	disconnect()
		src.pipe = null

	closed
		icon_state = "valve-closed"
		is_open = 0