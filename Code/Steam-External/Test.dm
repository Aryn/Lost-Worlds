/structure/steam/node/test/generator
	icon = 'Icons/Ship/Equipment/Steam/Generator.dmi'
	icon_state = "outlet"

	energy_delta = 20

	SteamSetup()
		pipe_dirs = dir

/structure/steam/boiler_tank
	icon = 'Icons/Ship/Equipment/Steam/Generator.dmi'
	icon_state = "tank"

/structure/cosmetic/engine
	core/icon = 'Icons/Ship/Equipment/Engine/Core.dmi'
	turbine
		icon = 'Icons/Ship/Equipment/Engine/Turbine.dmi'
		icon_state = "spinning"