display_group
	var/character/user
	var/is_open = false
	var/list/contents = list()
	var/obj/display/group_opener/opener

display_group/proc/Add(atom/hud)
	contents.Add(hud)

display_group/proc/CreateOpenButton(screen_loc, icon_state)
	opener = new(screen_loc, src)
	opener.icon_state = icon_state

display_group/proc/CreateCloseButton(screen_loc, icon_state)
	var/obj/display/group_closer/closer = new(screen_loc, src)
	closer.icon_state = icon_state
	Add(closer)

display_group/proc/Open(character/user)
	if(opener) user.RemoveHUD(opener)

	for(var/thing in contents)
		if(istype(thing,/obj/display/equipment))
			var/obj/display/equipment/equip = thing
			var/inv_slot/slot = user.slots[equip.slot_name]
			slot.DisplayItem()
		user.AddHUD(thing)

	user.UpdateHUD()

display_group/proc/Close(character/user)
	for(var/thing in contents)
		if(istype(thing,/obj/display/equipment))
			var/obj/display/equipment/equip = thing
			var/inv_slot/slot = user.slots[equip.slot_name]
			slot.HideItem()
		user.RemoveHUD(thing)

	if(opener) user.AddHUD(opener)

	user.UpdateHUD()