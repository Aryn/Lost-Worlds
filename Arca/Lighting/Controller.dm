/*

Overview:
	Unlike the previous lighting controller, this is mostly here to hold global lighting procs and vars.
	It does not process every tick, because not even DAL did something so stupid.

Global Vars:
	initial_lights - This holds all lights formed before the lighting controller started up. It becomes null on initialization.

Class Vars:
	ambient - The light value of space.

	icon_updates - The list of turfs which need an update to their overlays.

	light_border - Space turfs which are adjacent to non-space turfs.

Class Procs:
	Initialize()
		Starts the lighting system, creating all light points and turf overlays.

	ambient(n)
		Sets the light produced by space. If a solar eclipse suddenly happens, it'll probably lag.

	MarkIconUpdate(turf/T)
		Called when a turf needs an update to its light icon. Ensures that it only gets calculated once per turf.

	FlushIconUpdates()
		Called when a light is done marking icon updates. Updates every marked turf.

	AddBorder(turf/T) & RemoveBorder(turf/T)
		Called by turf/CheckForOpaqueObjects() to modify the light_border list.


*/


var/datum/controller/lighting/lighting_controller

var/all_lightpoints_made = 0

/datum/controller/lighting

	var/ambient = LIGHT_STATES
	var/list/icon_updates = list()
	var/started = 0

/datum/controller/lighting/proc/Initialize()

	set background = 1

	var/start_time = world.timeofday
	world << "<b><font color=red>Processing lights...</font></b>"

	sleep(1)

	var/turfs_updated = 0
	var/total_turfs = world.maxx*world.maxy*world.maxz

	for(var/z = 1, z <= world.maxz, z++)
		for(var/y = 0, y <= world.maxy, y++)
			for(var/x = 0, x <= world.maxx, x++)
				if(x > 0 && y > 0)

					turfs_updated++
					if((turfs_updated % (total_turfs>>2)) == 0)
						sleep(1)
						world << "<font color=red>Progress: [round((turfs_updated/total_turfs)*100, 0.01)]% ([turfs_updated]/[total_turfs])"

					var/turf/T = locate(x,y,z)
					if(CheckOutside(T))
						T.is_outside = TRUE
					else
						T.light_overlay = new(T)
					CheckBorder(T)

				if(!all_lightpoints_made) new/lightpoint(x+0.5,y+0.5,z)

	all_lightpoints_made = 1
	started = 1

	InitializeAmbient()

	for(var/turf/T)
		if(T.light_overlay)
			T.ResetValue()
			T.light_overlay.icon_state = "[MAX_VALUE(T.lightSE)][MAX_VALUE(T.lightSW)][MAX_VALUE(T.lightNW)][MAX_VALUE(T.lightNE)]"

	world << "<b><font color=red>Lighting initialization took [(world.timeofday-start_time)/world.fps] seconds.</font></b>"
	world << "<font color=red>Updated [turfs_updated] turfs.</font>"

/datum/controller/lighting/proc/CheckOutside(turf/T)

/datum/controller/lighting/proc/ChangeAmbient(n)

/datum/controller/lighting/proc/InitializeAmbient()

/datum/controller/lighting/proc/FlashAmbient(t)

/datum/controller/lighting/proc/CheckBorder(turf/T)

/datum/controller/lighting/proc/GetLightIcon(a,b,c,d)
