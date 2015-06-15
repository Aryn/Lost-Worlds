structure/steam/powered/unary/magic_generator
	name = "Magic Generator"
	desc = "Generates steam power from nothing."
	icon = 'Icons/Ship/Equipment/Steam/Test.dmi'
	icon_state = "gen"
	delta = 10

structure/steam/powered/unary/magic_generator/power_update()
	if(net)
		icon_state = "running"
	else
		icon_state = "gen"

structure/steam/powered/unary/magic_gauge
	name = "Magic Gauge"
	desc = "There's actually nothing very magical about it. It lights up when there's steam."
	icon = 'Icons/Ship/Equipment/Steam/Test.dmi'
	icon_state = "gauge-0"
	delta = -2

structure/steam/powered/unary/magic_gauge/power_update()
	if(net && net.differential() >= 0)
		icon_state = "gauge-10"
		if(!light || !light.intensity) SetLight(2,1)
	else
		icon_state = "gauge-0"
		if(light && light.intensity) SetLight(0,0)