/command
	var/name = ""
	var/context = NORMAL
	var/desc = ""
	var/needs_skill = false

/command/New(name, context, desc, needs_skill = false)
	src.name = name
	src.context = context
	src.desc = desc
	src.needs_skill = needs_skill

atom/movable/var/list/commands
atom/movable/var/command_icon

var/list/standard_commands = list(
new/command("Examine", NORMAL|BATTLE, "Just what is this thing anyway?")
)

atom/movable/proc/Examine()
	usr << "<b>[src]</b>"
	usr << "<small>[desc]</small>"

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

obj/display/command
	layer = HUD_LAYER+2
	var/atom/movable/thing
	var/command
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
			var/character/C = usr
			if(C && C.combatant && !C.combatant.acting)
				C.combatant.Select(thing, command)
			else
				call(thing,command.name)()
			var/client/client = usr.client
			if(client.selectors.len)
				client.screen -= client.selectors
				client.selectors.Cut()

obj/display/command/standard/New(screen_loc,atom/movable/S,command_name)
	. = ..()
	icon = 'Icons/Commands/Standard.dmi'

client/proc/DisplayCommands(atom/movable/S, screen_loc)
	var/data/screenloc/sloc = parse_screenloc(screen_loc)

	var/remaining_screen = (17 - sloc.x)*32
	var/nextx = 1
	var/nexty = 0

	for(var/command_name in S.commands)
		var/obj/display/command/c = new("[sloc.x]:[sloc.pixel_x+nextx*24],[sloc.y]:[sloc.pixel_y+nexty*24]",S,command_name,
		S.commands[command_name])

		selectors.Add(c)
		nextx++
		if(nextx*24+48 > remaining_screen)
			nextx = 0
			nexty++

	for(var/command_name in standard_commands)
		var/obj/display/command/standard/c = new("[sloc.x]:[sloc.pixel_x+nextx*24],[sloc.y]:[sloc.pixel_y+nexty*24]",S,command_name,
		standard_commands[command_name])

		selectors.Add(c)
		nextx++
		if(nextx*24+48 > remaining_screen)
			nextx = 0
			nexty++

	screen += selectors