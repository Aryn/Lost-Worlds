/hook/game_start/proc/StartLights()
	lighting_controller = new/datum/controller/lighting/arcaprima
	lighting_controller.Initialize()
	return 1

/datum/controller/lighting/arcaprima/var/list/light_border = list()

/datum/controller/lighting/arcaprima/CheckOutside(turf/T)
	return istype(T.loc, /area/outside) || istype(T.loc, /area/surface)

/datum/controller/lighting/arcaprima/InitializeAmbient()
	var/n = LIGHTCLAMP(ambient)
	for(var/area/outside/O)
		O.icon_state = "[n][n][n][n]"
		O.icon = lighting_controller.GetLightIcon(n,n,n,n)

	for(var/turf/T in light_border)
		T.CheckForOpaqueObjects()
		if(!T.has_opaque) T.SetLight(ambient,5)

/datum/controller/lighting/arcaprima/ChangeAmbient(n)
	ambient = n
	var/c = LIGHTCLAMP(ambient)
	for(var/area/outside/O)
		O.icon_state = "[c][c][c][c]"
		O.icon = lighting_controller.GetLightIcon(n,n,n,n)

	for(var/turf/T in light_border)
		if(!T.has_opaque) T.SetLight(ambient,4)
		T.ResetValue()
		if(T.light_overlay)
			T.light_overlay.set_state(MAX_VALUE(T.lightSE),MAX_VALUE(T.lightSW),MAX_VALUE(T.lightNW),MAX_VALUE(T.lightNE))

/datum/controller/lighting/arcaprima/FlashAmbient(t)
	var/c = LIGHTCLAMP(ambient)
	var/max = LIGHT_STATES
	for(var/area/outside/O)
		O.icon_state = "[max][max][max][max]"
		O.icon = lighting_controller.GetLightIcon(max,max,max,max)
	spawn(t)
		for(var/area/outside/O)
			O.icon_state = "[c][c][c][c]"
			O.icon = lighting_controller.GetLightIcon(c,c,c,c)

/datum/controller/lighting/arcaprima/CheckBorder(turf/C)
	var/area/my_area = C.loc
	if(my_area.is_outside) return

	for(var/d = 1, d < 16, d*=2)
		var/turf/T = get_step(C,d)
		if(!T) continue
		var/area/A = T.loc
		if(A.is_outside)
			if(!C.is_border)
				light_border.Add(C)
				C.is_border = TRUE
			return

	if(C.is_border)
		light_border.Remove(C)
		C.is_border = FALSE

/datum/controller/lighting/arcaprima/GetLightIcon(a,b,c,d)
	return 'Icons/Lighting/SimpleDark.dmi'