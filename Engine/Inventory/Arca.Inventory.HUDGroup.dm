/*
Display groups are groups of HUD icons that only appear when a particular
condition is met, such as clicking on an expander icon or opening a container.
*/

display_group
	var/list/contents = list()          //The HUD icons that will be displayed on opening.
	var/obj/display/group_opener/opener //An optional button that opens the group.

//Adds a HUD element to the group.
display_group/proc/Add(atom/hud)
	contents.Add(hud)

//Creates a button that opens the group when clicked.
display_group/proc/CreateOpenButton(screen_loc, icon_state)
	opener = new(screen_loc, src)
	opener.icon_state = icon_state

//Creates a button that closes the group when clicked, and adds it to the group.
display_group/proc/CreateCloseButton(screen_loc, icon_state)
	var/obj/display/group_closer/closer = new(screen_loc, src)
	closer.icon_state = icon_state
	Add(closer)

//Opens the group for a particular player. Does not check if the group is open.
display_group/proc/Open(character/user)
	if(opener) user.RemoveHUD(opener)

	for(var/thing in contents)
		if(istype(thing,/obj/display/equipment))
			var/obj/display/equipment/equip = thing
			var/inv_slot/slot = user.slots[equip.slot_name]
			slot.DisplayItem()
		user.AddHUD(thing)

	user.UpdateHUD()

//Closes the group for a particular player. Does not check if the group is closed.
display_group/proc/Close(character/user)
	for(var/thing in contents)
		if(istype(thing,/obj/display/equipment))
			var/obj/display/equipment/equip = thing
			var/inv_slot/slot = user.slots[equip.slot_name]
			slot.HideItem()
		user.RemoveHUD(thing)

	if(opener) user.AddHUD(opener)

	user.UpdateHUD()