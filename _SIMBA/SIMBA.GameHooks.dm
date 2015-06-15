/proc/CallHook(hook)
	var/hook_path = text2path("/hook/[hook]")
	if(!hook_path)
		CRASH("Invalid hook '/hook/[hook]' called.")
		return 0

	var/caller = new hook_path
	var/status = 1
	for(var/P in typesof("[hook_path]/proc"))
		if(!call(caller, P)())
			CRASH("Hook '[P]' failed or runtimed.")
			status = 0

	return status