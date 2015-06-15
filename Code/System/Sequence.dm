process/var/tool
process/var/usage_period
process/var/msg = "/user uses /tool on /target..."
process/var/cmd
process/var/target_type

process/New(target_type,cmd,tool,usage_period,msg)
	ASSERT(ispath(target_type))
	ASSERT(ispath(tool))
	ASSERT(isnum(usage_period))
	src.target_type = target_type
	src.msg = msg
	src.tool = tool
	src.usage_period = usage_period
	src.cmd = cmd

process/proc/Try(atom/target, character/C, item/I)
	if(!istype(target,target_type)) return 0
	if(!istype(I,tool)) return 0

	view(C) << dd_replacetext(dd_replacetext(dd_replacetext(msg, "/user", C.name), "/tool", "[I]"), "/target", "[target]")
	spawn(usage_period)
		if(C.last_moved > world.time - usage_period) return 1
		call(target, cmd)(C,I)
		return 1

