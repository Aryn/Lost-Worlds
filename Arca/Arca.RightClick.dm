obj/display/selector
	icon = STANDARD_COMMAND_ICON
	//icon_state = "base"
	var/atom/atom
	var/matrix/img_matrix = new
	var/image/img_of_atom
	New(screen_loc,atom/A)
		img_matrix.Scale(SELECT_SCALE*ITEM_SCALE,SELECT_SCALE*ITEM_SCALE)
		. = ..()
		atom = A
		img_of_atom = image(A,layer=HUD_LAYER+2,pixel_x = -4,pixel_y = -4)
		img_of_atom.transform = img_matrix
		overlays += img_of_atom

	Click(location,control,params)
		var/list/plist = params2list(params)
		if(plist["right"])
			if(istype(atom,/atom/movable)) usr.client.DisplayCommands(atom,screen_loc)
		else
			usr.client.Click(atom, location, control, params)

atom/var/can_select = 0

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
		if(!A.can_select || A.invisibility > mob.see_invisible) continue
		var/obj/display/selector/s = new("[sloc.x]:[16+nextx*24],[sloc.y]:[nexty*24]",A)
		selectors.Add(s)
		nexty++
		if(nexty*24+48 > remaining_screen)
			nexty = 0
			nextx++
	screen += selectors