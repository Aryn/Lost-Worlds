/hook/parent_type = /atom

/proc/DoHook(hook_type)
	var/hook/hook = new hook_type
	for(var/v in hook.verbs)
		call(hook,v)()