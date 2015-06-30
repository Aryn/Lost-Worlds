structure/steam/node/pipe
	name = "Pipe"
	desc = "A pipe designed to carry all manner of things, but mostly steam."
	icon = 'Icons/Ship/Equipment/Steam/Pipe.dmi'
	layer = 2.25

	commands = list(
	new/command("Check",ALL,"Check the thing")
	)

	SteamSetup()
		pipe_dirs = text2num(icon_state)
		if(color)
			var/image/img = image('Icons/Ship/Equipment/Steam/Pipe-Band.dmi')
			img.color = color
			overlays += img
			color = null
			icon = 'Icons/Ship/Equipment/Steam/Pipe.dmi'

	proc/Check()
		usr << "Pipe Dirs: [pipe_dirs]"
		usr << "Network: \..."
		if(!net)
			usr << "None"
			return
		else
			usr << "[(net.status & PIPE_INVALID) ? "\red" : "\green"][net.nodes.len] nodes, [net.leaks ? net.leaks.len : 0] leaks."
			for(var/fluid_name in net.fluids)
				var/steam_fluid/fluid = net.fluids[fluid_name]
				usr << "[fluid_name] Differential: [fluid.Differential()] units"

	coolant
		icon = 'Icons/Ship/Equipment/Steam/Pipe-Map.dmi'
		color = "#00AAAA"
	fuel
		icon = 'Icons/Ship/Equipment/Steam/Pipe-Map.dmi'
		color = "#AAAA00"
	fire
		icon = 'Icons/Ship/Equipment/Steam/Pipe-Map.dmi'
		color = "#AA0000"

	left_aligned
		icon = 'Icons/Ship/Equipment/Steam/Pipe-E.dmi'
		alignment = -1

structure/steam/node/aligner
	icon = 'Icons/Ship/Equipment/Steam/Aligner.dmi'
	icon_state = "left"
	alignment = -1
	SteamSetup()
		pipe_dirs = dir | turn(dir,180)

	Aligned(structure/steam/node/node)
		return !node.alignment || node.alignment == alignment

structure/steam/valve
	var/is_open = 1
	var/structure/steam/node/pipe

	SteamSetup()
		pipe = locate() in loc
		if(!is_open) close()

	proc/close()
		if(pipe)
			var/keep_bit
			for(var/b = 1, b < 64, b = b << 1)
				if(pipe.pipe_dirs & b)
					keep_bit = b
					break
			pipe.sealed_dirs = 63 & ~keep_bit
			pipe.net.Split()
		is_open = 0

	proc/open()
		if(pipe)
			pipe.sealed_dirs = 0
			pipe.net.Split()
		is_open = 1

structure/steam/valve/manual
	name = "Valve"
	icon = 'Icons/Ship/Equipment/Steam/Valve.dmi'
	icon_state = "valve-open"

	commands = list(
	new/command("Toggle", ALL, "Toggle the valve.")
	)

	Description()
		return "A hand-operated valve. The valve is currently [is_open ? "open" : "closed"]."

	Operated(mob/M)
		Toggle()

	proc/Toggle()
		Sound('Sounds/Chemicals/Valve.ogg')
		if(is_open)
			close()
			icon_state = "valve-closed"
		else
			open()
			icon_state = "valve-open"

	closed
		icon_state = "valve-closed"
		is_open = 0