proc/log_warning(msg)
	world << "<font color=#FFAA00>LOG: [msg]</font>"
	world.log << "WARN: [msg]"

proc/log_critical(msg)
	world << "<font color=#FF0000>LOG: [msg]</font>"
	world.log << "CRITICAL: [msg]"