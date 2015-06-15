obj/map_point/ship
	icon_state = "ship-landed"
	layer = 3
	var/data/port/at_port
	var/matrix/rotation = new
	var/angle = 0
	var/speed = 32/MAP_TIMESCALE
	var/throttle_up = FALSE

	var/altitude = 0
	var/phase = 0
	var/character/humanoid/pilot

	proc/Instability()
		var/base = 1
		if(at_port) return 0.2
		if(phase == 0) base = 2
		else if(phase == 2) base = 2.5
		else base = 1
		if(throttle_up) base *= 2
		if(pilot) base *= 0.75
		return base

	proc/SetThrottleLevers(n)
		for(var/structure/controls/throttle/throttle)
			throttle.SetLever(n)

	proc/FlyTo(x,y)

		if(at_port)
			game.Departed(at_port)
			world << "\green <b>Ship Announcement: We have lifted off from [at_port.point] and are in flight towards [game.selected].</b>"
			world << "\green <b>The ship should reach cruising altitude in approximately 10 minutes.</b>"
			ChangeSkyState()
			SetThrottleLevers(1 + (throttle_up ? 1 : 0))
			at_port = null

		if(phase == 0)

			icon_state = "ship-adjust"
			altitude += speed * MAP_TICK_SPEED
			if(altitude >= 64)
				icon_state = "ship-flying"
				phase = 1
				ChangeSkyState("move")
				world << "\green <b>Ship Announcement: The ship is now at cruising altitude. Enjoy the remainder of your flight to [game.selected].</b>"
				SetThrottleLevers(2 + (throttle_up ? 1 : 0))

		if(phase == 2)
			if(pilot)
				icon_state = "ship-adjust"
				altitude -= speed * MAP_TICK_SPEED
				if(altitude <= 0)
					altitude = 0
					icon_state = "ship-landed"
					phase = 0
					game.Arrived()
					ChangeSkyState("hover")
					SetThrottleLevers(0)
					return
			else
				if(altitude >= 64)
					icon_state = "ship-flying"
				else
					altitude += speed * MAP_TICK_SPEED*0.5

		else
			var/dist_squared = DISTSQ(x-map_x,y-map_y)
			if(dist_squared < SQ(4)) //Get within four pixels and you're there
				phase = 2
				world << "\green <b>Ship Announcement: The ship is in landing range of [game.selected].</b>"
				world << "\green <b>The ship should be at port in approximately 10 minutes. Navigator is requested at the bridge for final descent.</b>"
				SetThrottleLevers(1 + (throttle_up ? 1 : 0))
				ChangeSkyState()
				return

			var/angle_to_target = arctan2(x-map_x,y-map_y)
			//world << "Angle to target: [round(angle_to_target,0.1)] degrees."
			angle = ((y - map_y > 0 ? -angle_to_target : angle_to_target) + 360 + 90)
			dir = turn(NORTH,round(-angle,45))

			map_x += (phase == 0 ? 0.5 : 1) * speed * sin(angle) * MAP_TICK_SPEED
			map_y += (phase == 0 ? 0.5 : 1) * speed * cos(angle) * MAP_TICK_SPEED
			UpdatePosition()

structure/controls/density = 1

structure/controls/wheel
	icon = 'Icons/Ship/Equipment/Helm.dmi'
	icon_state = "controls"
	New()
		. = ..()
		overlays += image('Icons/Ship/Equipment/Helm.dmi', icon_state = "light", layer=LIGHT_LAYER+1)

	Operated(character/humanoid/H)
		view(src) << "\green [H] takes the helm."
		game.map.ship.pilot = H
		if(!H.MoveTimer())
			view(src) << "\green [H] leaves the helm."
			if(game.map.ship.phase == 2) H << "\red A pilot is required to be at the helm for landing."
			game.map.ship.pilot = null

structure/controls/throttle
	icon = 'Icons/Ship/Equipment/Helm.dmi'
	icon_state = "throttle"
	var/image/throttle_lever
	New()
		. = ..()
		overlays += image('Icons/Ship/Equipment/Helm.dmi', icon_state = "light3", layer=LIGHT_LAYER+1)
		throttle_lever = image('Icons/Ship/Equipment/Helm.dmi', icon_state = "off")
		overlays += throttle_lever

	proc/SetLever(n)
		overlays -= throttle_lever
		switch(n)
			if(0) throttle_lever.icon_state = "off"
			if(1) throttle_lever.icon_state = "low"
			if(2) throttle_lever.icon_state = "med"
			if(3) throttle_lever.icon_state = "high"
		overlays += throttle_lever

	Operated(character/humanoid/H)
		var/obj/map_point/ship/ship = game.map.ship
		if(!ship.at_port)
			if(!ship.throttle_up)
				H << "You set the throttle to LUDICROUS SPEED."
				ship.throttle_up = TRUE
				ship.SetThrottleLevers(2 + (ship.phase == 1 ? 1 : 0))
				ship.speed = 64 / MAP_TIMESCALE
			else
				H << "You set the throttle to NORMAL SPEED."
				ship.throttle_up = FALSE
				ship.SetThrottleLevers(1 + (ship.phase == 1 ? 1 : 0))
				ship.speed = 32 / MAP_TIMESCALE

structure/controls/aux
	icon = 'Icons/Ship/Equipment/Helm.dmi'
	icon_state = "controls2"

	New()
		. = ..()
		overlays += image('Icons/Ship/Equipment/Helm.dmi', icon_state = "light2", layer=LIGHT_LAYER+1)

	Operated(character/humanoid/H)
		game.map.ShowTo(H, TRUE)