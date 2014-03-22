/command
	var/name = ""
	var/context = ALL
	var/desc = ""
	var/needs_skill = FALSE

/command/New(name, context, desc, needs_skill = FALSE)
	src.name = name
	src.context = context
	src.desc = desc
	src.needs_skill = needs_skill

atom/movable/var/list/commands
atom/movable/var/command_icon

var/list/standard_commands = list(
new/command("Examine", ALL, "Just what is this thing anyway?")
)

atom/movable/proc/Examine()
	usr << "<b>[src]</b>"
	usr << "<small>[desc]</small>"

client/var/tmp/keep_selectors = FALSE
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

obj/display/command
	layer = HUD_LAYER+2
	var/atom/movable/thing
	var/command/command
	New(screen_loc,atom/movable/S,command/command)
		. = ..()
		thing = S
		src.command = command
		name = command.name
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
	icon = STANDARD_COMMAND_ICON

client/proc/DisplayCommands(atom/movable/S, screen_loc)
	var/data/screenloc/sloc = parse_screenloc(screen_loc)

	var/remaining_screen = (17 - sloc.x)*32
	var/nextx = 1
	var/nexty = 0

	var/character/C = mob
	var/context = C.GetContext()

	for(var/command/command in S.commands)
		if(!(command.context & context)) continue
		var/obj/display/command/c = new("[sloc.x]:[sloc.pixel_x+nextx*24],[sloc.y]:[sloc.pixel_y+nexty*24]",S,command)
		selectors.Add(c)
		nextx++
		if(nextx*24+48 > remaining_screen)
			nextx = 0
			nexty++

	for(var/command/command in standard_commands)
		if(!(command.context & context)) continue
		var/obj/display/command/standard/c = new("[sloc.x]:[sloc.pixel_x+nextx*24],[sloc.y]:[sloc.pixel_y+nexty*24]",S,command)

		selectors.Add(c)
		nextx++
		if(nextx*24+48 > remaining_screen)
			nextx = 0
			nexty++

	screen += selectors