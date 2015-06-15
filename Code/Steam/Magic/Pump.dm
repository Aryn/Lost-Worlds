structure/steam/powered/binary/magic_pump
	name = "Magic Pump"
	icon = 'Icons/Ship/Equipment/Steam/Test.dmi'
	icon_state = "pump_on"

	var/max_rate = 0
	var/delta_rate = 0
	var/checked = 0

	Description()
		return "A pump that operates at any flow rate, without the need for energy input.<br>The pump is transferring [delta_rate] units."

	commands = list(
	new/command("Check", ALL, "Check the thing."),
	new/command("Set_Rate", ALL, "Set the rate of flow.")
	)

	proc/Check()
		usr << "Network A: \..."
		if(!net_A)
			usr << "None"
		else
			usr << "[net_A.invalid ? "\red" : "\green"][net_A.pipes.len] pipes, [net_A.machines.len] machines."
			usr << "Contribution: [delta_A] units"
		usr << ""
		usr << "Network B: \..."
		if(!net_B)
			usr << "None"
		else
			usr << "[net_B.invalid ? "\red" : "\green"][net_B.pipes.len] pipes, [net_B.machines.len] machines."
			usr << "Contribution: [delta_B] units"

		checked = 1

	proc/Set_Rate()
		var/rate = input(usr, "Set the flow rate.") as num
		max_rate = rate
		power_update()

structure/steam/powered/binary/magic_pump/power_update()

	var/unit_diff = net_B.differential(delta_rate)
	var/new_rate

	if(unit_diff >= max_rate)
		new_rate = max_rate
	else if(unit_diff > 0)
		new_rate = unit_diff
	else
		new_rate = 0

	//if(checked) world << "UD: [unit_diff] Rate: [new_rate] Old: [delta_rate]"

	if(new_rate != delta_rate)
		setdelta_B(-new_rate)
		setdelta_A(new_rate)
		delta_rate = new_rate

	if(delta_A > 0) icon_state = "pump_on"
	else icon_state = "pump_off"