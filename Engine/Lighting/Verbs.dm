
mob/verb/ChangeAmbient(n as num)
	lighting_controller.ChangeAmbient(n)
	src << "Changed to [n]."

var/border = image('Icons/Debug/Marker.dmi', icon_state = "job", layer=3)

tile/Click()
	. = ..()
	var/turf/T = loc

	T.Click()

turf/Click()
	var/turf/T = src
	if(T.is_outside) T.maptext = "<b>Out</b>"
	if(T.is_border) T.overlays += border
	usr << "Light Overlay: [T.light_overlay]"
	if(T.light_overlay) usr << "([T.light_overlay.icon_state])"
	usr << "Lit Value: [T.lit_value]"
	usr << "Max Brightness: [T.max_brightness]"
	usr << "Light (Cached): [MAX_VALUE(T.lightSE)][MAX_VALUE(T.lightSW)][MAX_VALUE(T.lightNW)][MAX_VALUE(T.lightNE)]"
	usr << "Light (Proper): [T.lightSE.max_value()][T.lightSW.max_value()][T.lightNW.max_value()][T.lightNE.max_value()]"

	usr << "Lit By: "
	for(var/light/light in T.lit_by)
		usr << " - [light.atom] \[[T.lit_by[light]]\][(T.lit_by[light] == T.max_brightness ? "(MAX)" : "")]"