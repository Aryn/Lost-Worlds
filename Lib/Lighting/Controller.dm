/*

Overview:
	Unlike the previous lighting controller, this is mostly here to hold global lighting procs and vars.
	It does not process every tick, because not even DAL did something so stupid.

Global Vars:
	initial_lights - This holds all lights formed before the lighting controller started up. It becomes null on initialization.

Class Vars:
	starlight - The light value of space.

	icon_updates - The list of turfs which need an update to their overlays.

	light_border - Space turfs which are adjacent to non-space turfs.

Class Procs:
	Initialize()
		Starts the lighting system, creating all light points and turf overlays.

	StarLight(n)
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

	var/starlight = LIGHT_STATES
	var/list/icon_updates = list()

	var/list/light_border = list()

	var/started = 0

	//var/icon/border = icon('Icons/Test.dmi', "border")

/datum/controller/lighting/New()
	lighting_controller = src

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
					var/area/A = T.loc
					if(!A.is_outside)
						T.light_overlay = new(T)
					else
						T.is_outside = true
					T.ResetBorder()
					//T.ResetValue()
				if(!all_lightpoints_made) new/lightpoint(x+0.5,y+0.5,z)



				//world << "[x],[y],[z]"

	all_lightpoints_made = 1
	started = 1

	for(var/turf/T in light_border)
		T.CheckForOpaqueObjects()
		if(!T.has_opaque) T.SetLight(starlight,5)

	for(var/turf/T)
		if(T.light_overlay)
			T.ResetValue()
			T.light_overlay.icon_state = "[MAX_VALUE(T.lightSE)][MAX_VALUE(T.lightSW)][MAX_VALUE(T.lightNW)][MAX_VALUE(T.lightNE)]"

	world << "<b><font color=red>Lighting initialization took [(world.timeofday-start_time)/world.fps] seconds.</font></b>"
	world << "<font color=red>Updated [turfs_updated] turfs.</font>"

/datum/controller/lighting/proc/ChangeAmbient(n)
	starlight = n
	var/c = LIGHTCLAMP(starlight)
	for(var/area/outside/O)
		O.icon_state = "[c][c][c][c]"
	for(var/turf/T in light_border)
		if(!T.has_opaque) T.SetLight(starlight,4)
		T.ResetValue()
		T.light_overlay.icon_state = "[MAX_VALUE(T.lightSE)][MAX_VALUE(T.lightSW)][MAX_VALUE(T.lightNW)][MAX_VALUE(T.lightNE)]"


	//for(var/turf/T)
	//	if(T.light_overlay)
	//		T.ResetValue()
	//		T.UpdateLight()

/*datum/controller/lighting/proc/MarkIconUpdate(turf/T)
	if(!T.needs_light_update)
		icon_updates.Add(T)
		T.needs_light_update = 1*/

/*datum/controller/lighting/proc/FlushIconUpdates()
	for(var/turf/T in icon_updates)
		T.UpdateLight()
		T.needs_light_update = 0
	icon_updates = list()*/

//var/border = image('Icons/Debug/Marker.dmi', layer=FLY_LAYER+1)
//var/border2 = image('Icons/Debug/Marker.dmi', icon_state = "job", layer=FLY_LAYER+1)

/datum/controller/lighting/proc/AddBorder(turf/T)
	if(!T.is_border)
		light_border.Add(T)
		T.is_border = 1
		//T.overlays.Add(border)

/datum/controller/lighting/proc/RemoveBorder(turf/T)
	if(T.is_border)
		light_border.Remove(T)
		T.is_border = 0
