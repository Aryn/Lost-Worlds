/command
	var/name = ""
	var/context = ALL
	var/desc = ""
	var/must_be_adjacent = TRUE
	var/custom_icon

	proc/Requirements(character/user, atom/commanded)
		if(must_be_adjacent) return get_dist(user,commanded) <= 1
		else return TRUE

/command/New(name, context, desc, must_be_adjacent = TRUE)
	if(name)
		src.name = name
		src.context = context
		src.desc = desc
		src.must_be_adjacent = must_be_adjacent


atom/movable/var/list/commands
atom/movable/var/command_icon = DEFAULT_COMMAND_ICON

var/list/universal_commands = list(
new/command("Examine", ALL, "Just what is this thing anyway?", FALSE)
)

atom/movable/proc/Examine()
	usr << "<b>[src]</b>"
	usr << "<small>[Description()]</small>"

atom/movable/proc/Description()
	return desc

client/var/tmp/keep_selectors = FALSE
client/var/tmp/list/selectors = list()

client/Click(atom/A,location,control,params)
	var/list/plist = params2list(params)
	if(isturf(location))
		if(selectors.len)
			screen -= selectors
			selectors.Cut()
		if(plist["right"])
			world << "@[location]"
			DisplaySelectors(location,plist["screen-loc"])
			return
	. = ..()

obj/display/layer = UI_LAYER + 2
obj/display/New(screen_loc)
	src.screen_loc = screen_loc

obj/display/command
	var/atom/movable/thing
	var/command/command
	New(screen_loc,atom/movable/S,command/command)
		. = ..()
		thing = S
		src.command = command
		name = command.name
		if(command.custom_icon)
			icon = command.custom_icon
		else
			icon = S.command_icon
		icon_state = command.name

	Click(location, control, params)
		var/list/plist = params2list(params)
		if(plist["right"])
			usr.client << "<b>[command.name]</b><br><small>[command.desc]</small>"
		else
			//var/character/C = usr
			call(thing,command.name)()
			var/client/client = usr.client
			if(client.selectors.len)
				client.screen -= client.selectors
				client.selectors.Cut()

obj/display/command/standard/New(screen_loc,atom/movable/S,command_name)
	. = ..()
	icon = UNIVERSAL_COMMAND_ICON

client/proc/DisplayCommands(atom/movable/S, screen_loc)
	var/data/screenloc/sloc = parse_screenloc(screen_loc)

	var/remaining_screen = (17 - sloc.x)*32
	var/nextx = 1
	var/nexty = 0

	var/character/C = mob
	var/context = C.GetCommandContext()

	for(var/command/command in S.commands)
		world << "\red [command.name]!"
		if(command.context && !(command.context & context)) continue
		if(!command.Requirements(C, S)) continue
		world << "\green [command.name]!"

		var/obj/display/command/c = new("[sloc.x]:[sloc.pixel_x+nextx*24],[sloc.y]:[sloc.pixel_y+nexty*24]",S,command)
		selectors.Add(c)
		nextx++
		if(nextx*24+48 > remaining_screen)
			nextx = 0
			nexty++

	for(var/command/command in universal_commands)
		if(command.context && !(command.context & context)) continue
		if(!command.Requirements(C, S)) continue
		var/obj/display/command/standard/c = new("[sloc.x]:[sloc.pixel_x+nextx*24],[sloc.y]:[sloc.pixel_y+nexty*24]",S,command)

		selectors.Add(c)
		nextx++
		if(nextx*24+48 > remaining_screen)
			nextx = 0
			nexty++

	screen += selectors

obj/display/selector
	icon = UNIVERSAL_COMMAND_ICON
	//icon_state = "base"
	var/atom/atom
	var/matrix/img_matrix = new
	var/image/img_of_atom
	New(screen_loc,atom/A)
		img_matrix.Scale(SELECT_SCALE*ITEM_SCALE,SELECT_SCALE*ITEM_SCALE)
		. = ..()
		atom = A
		img_of_atom = image(A,layer=UI_LAYER+2,pixel_x = -4,pixel_y = -4)
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

	world << "Selectors:"
	var/remaining_screen = (17 - sloc.y)*32
	var/nextx = 0
	var/nexty = 0
	for(var/atom/A in T)
		world << "[A]: \..."
		if(!A.can_select || A.invisibility > mob.see_invisible)
			world << "Denied"
			continue
		var/obj/display/selector/s = new("[sloc.x]:[16+nextx*24],[sloc.y]:[nexty*24]",A)
		selectors.Add(s)
		world << "Added - [nexty],[nextx]"
		nexty++
		if(nexty*24+48 > remaining_screen)
			nexty = 0
			nextx++

	screen += selectors

/data/screenloc
	var/x = 0
	var/pixel_x = 0
	var/y = 0
	var/pixel_y = 0

var/data/screenloc/_screenloc = new

proc/parse_screenloc(screenloc)
	var/colon = findtext(screenloc,":")
	_screenloc.x = text2num(copytext(screenloc,1,colon))
	var/comma = findtext(screenloc,",",colon)
	_screenloc.pixel_x = text2num(copytext(screenloc,colon+1,comma))
	colon = findtext(screenloc,":",comma)
	_screenloc.y = text2num(copytext(screenloc,comma+1,colon))
	_screenloc.pixel_y = text2num(copytext(screenloc,colon+1))
	return _screenloc

proc/parse_time(total_seconds)
	var/seconds = round(total_seconds%60)
	var/minutes = round(total_seconds/60) % 60
	var/hours = round(total_seconds/3600)
	return "[hours>9 ? "" : "0"][hours]:[minutes>9 ? "" : "0"][minutes]:[seconds>9 ? "" : "0"][seconds]"
