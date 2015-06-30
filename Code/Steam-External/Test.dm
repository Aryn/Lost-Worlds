/structure/steam/node/test/generator
	icon = 'Icons/Ship/Equipment/Steam/Generator.dmi'
	icon_state = "outlet"

	energy_delta = 20

	SteamSetup()
		pipe_dirs = dir

/structure/steam/boiler_tank
	icon = 'Icons/Ship/Equipment/Steam/Generator.dmi'
	icon_state = "tank"

/structure/cosmetic
	tank
		icon = 'Icons/Ship/Engine/Tank64.dmi'
		icon_state = "left 1,0"

		coolant/color = "#00AAAA"
		fuel/color = "#AAAA00"

/structure/steam/engine
	core/icon = 'Icons/Ship/Equipment/Engine/Core.dmi'
	turbine
		icon = 'Icons/Ship/Equipment/Engine/Turbine.dmi'
		icon_state = "spinning"
/structure/steam/node/tank
	icon = 'Icons/Ship/Engine/Tank64.dmi'
	icon_state = "left 0,0"
	pipe_dirs = SOUTH

	SteamSetup()
		. = ..()

		if(color)
			var/image/img = image('Icons/Ship/Engine/Tank-Window.dmi')
			img.color = color
			img.layer = layer + 0.1
			if(icon_state == "right 1,0")
				img.pixel_x = -32
			overlays += img
			color = null

	coolant
		color = "#00AAAA"
		NetChanged(steam_net/net)
			if(src.net) src.net.ChangeFluid("Coolant", 5, 0)
			if(net) net.ChangeFluid("Coolant", 0, 5)
	fuel
		color = "#AAAA00"
		NetChanged(steam_net/net)
			if(src.net) src.net.ChangeFluid("Fuel", 5, 0)
			if(net) net.ChangeFluid("Fuel", 0, 5)