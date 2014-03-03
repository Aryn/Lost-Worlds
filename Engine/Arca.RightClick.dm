obj/display/selector
	icon = 'Icons/HUD/Select.dmi'
	//icon_state = "base"
	var/atom/atom
	var/matrix/img_matrix = new
	var/image/img_of_atom
	New(screen_loc,atom/A)
		var/matrix/M = new
		M.Scale(0.75,0.75)
		transform = M
		img_matrix.Scale(14/16,14/16)
		. = ..()
		atom = A
		img_of_atom = image(A,layer=HUD_LAYER+2,pixel_x = 0,pixel_y = 0)
		img_of_atom.transform = img_matrix
		overlays += img_of_atom

	Click(location,control,params)
		var/list/plist = params2list(params)
		if(plist["right"])
			if(istype(atom,/structure)) usr.client.DisplayCommands(atom,screen_loc)
			else usr << "\red This object has no commands."
		else
			usr.client.Click(atom, location, control, params)

obj/display/command
	var/structure/structure
	var/command
	New(screen_loc,structure/S,command_name)
		. = ..()
		structure = S
		command = command_name
		icon = S.command_icon
		icon_state = command_name

	Click()
		call(structure,command)()
		var/client/client = usr.client
		if(client.selectors.len)
			client.screen -= client.selectors
			client.selectors.Cut()



atom/var/can_select = 0
structure/var/list/commands
structure/var/command_icon

client/var/tmp/keep_selectors = false
client/var/tmp/list/selectors = list()

client/Click(atom/A,control,location,params)
	var/list/plist = params2list(params)
	if(istype(A) && isturf(A.loc))
		if(selectors.len)
			screen -= selectors
			selectors.Cut()
		if(plist["right"])
			DisplaySelectors(get_turf(A),plist["screen-loc"])
			return
	. = ..()

client/Move()
	. = ..()
	if(. && selectors.len)
		screen -= selectors
		selectors.Cut()

client/proc/DisplaySelectors(turf/T,screen_loc)
	var/data/screenloc/sloc = parse_screenloc(screen_loc)

	var/remaining_screen = (17 - sloc.y)*32
	var/nextx = 0
	var/nexty = 0
	for(var/atom/A in T)
		if(!A.can_select) continue
		var/obj/display/selector/s = new("[sloc.x]:[16+nextx*24],[sloc.y]:[nexty*24]",A)
		selectors.Add(s)
		nexty++
		if(nexty*24+48 > remaining_screen)
			nexty = 0
			nextx++
	screen += selectors

client/proc/DisplayCommands(structure/S, screen_loc)
	if(S.commands)
		var/data/screenloc/sloc = parse_screenloc(screen_loc)

		var/remaining_screen = (17 - sloc.x)*32
		var/nextx = 1
		var/nexty = 0
		for(var/command_name in S.commands)
			var/obj/display/command/c = new("[sloc.x]:[sloc.pixel_x+4+nextx*24],[sloc.y]:[sloc.pixel_y+4+nexty*24]",S,command_name)
			selectors.Add(c)
			nextx++
			if(nextx*24+48 > remaining_screen)
				nextx = 0
				nexty++
		screen += selectors