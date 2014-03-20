area/var/is_outside = false

//Because so many objects jump the gun.
//proc/lighting_ready()
//	return lighting_controller && lighting_controller.started

turf_light_data
	var/light_overlay
	var/lightNW
	var/lightSW
	var/lightNE
	var/lightSE
	var/lit_by

turf_light_data/proc/copy_from(turf/T)
	light_overlay = T.light_overlay
	lightNW = T.lightNW
	lightSW = T.lightSW
	lightNE = T.lightNE
	lightSE = T.lightSE
	lit_by = T.lit_by

turf_light_data/proc/copy_to(turf/T)
	T.light_overlay = light_overlay
	T.lightNW = lightNW
	T.lightSW = lightSW
	T.lightNE = lightNE
	T.lightSE = lightSE
	T.lit_by = lit_by
	//T.ResetValue()