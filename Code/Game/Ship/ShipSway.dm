#define SHIP_SWAY_INTENSITY 5 * (weather.severity * game.map.ship.Instability() / 100)

var/sway_displacement = 0
var/sway_angle = 0

proc/ShipSway()
	if(!game.map || !game.map.ship) return
	sway_displacement += rand() * SHIP_SWAY_INTENSITY - SHIP_SWAY_INTENSITY / 2
	sway_angle += rand() * SHIP_SWAY_INTENSITY * 10 - SHIP_SWAY_INTENSITY / 0.2
	while(sway_angle > 360) sway_angle -= 360
	var
		pixel_x = round(sway_displacement * sin(sway_angle))
		pixel_y = round(sway_displacement * cos(sway_angle))

	for(var/client/C)
		if(C.mob)
			if(!isturf(C.mob.loc) || istype(C.mob.loc:loc, /area/surface))
				C.pixel_x = 0
				C.pixel_y = 0
			else
				C.pixel_x = pixel_x
				C.pixel_y = pixel_y