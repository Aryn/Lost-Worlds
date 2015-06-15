structure/steam/powered/unary/gauge
	name = "Gauge"
	icon = 'Icons/Ship/Equipment/Steam/Gauge.dmi'
	icon_state = "0"
	connect_dir = 0

	commands = list(
		new/command("Reset", ALL, "Resets the gauge.")
	)

	Description()
		return "A gauge indicating the pressure of a pipe.<br>The gauge points to [icon_state]."

	proc/Reset()
		icon_state = "0"

	power_update()
		world << "Update!"
		if(net != null)
			icon_state = num2text( min( round(max(net.differential(), 0) / 5), 4) )
		else
			icon_state = "0"