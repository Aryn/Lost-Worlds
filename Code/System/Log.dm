proc/log_warning(msg)
	if(world.time > 10) world << "<font color=#FFAA00>LOG: [msg]</font>"
	else spawn(10) world << "<font color=#FFAA00>LOG: [msg]</font>"
	world.log << "WARN: [msg]"

proc/log_critical(msg)
	if(world.time > 10) world << "<font color=#FF0000>LOG: [msg]</font>"
	else spawn(10) world << "<font color=#FF0000>LOG: [msg]</font>"
	world.log << "CRITICAL: [msg]"