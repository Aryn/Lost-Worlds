obj/display/layer = HUD_LAYER

obj/display/icon = 'Icons/HUD/Equip.dmi'

obj/display/New(screen_loc)
	src.screen_loc = screen_loc

obj/display/equipment
	var/slot_name

	New(screen_loc, slot_name, icon_state)
		. = ..()
		src.name = slot_name
		src.slot_name = slot_name
		src.icon_state = icon_state

	Click()
		var/character/user = usr
		if(istype(user))
			user.OperateSlot(slot_name)

obj/display/drop
	icon_state = "drop"

	var/character/user

	Click()
		var/character/user = usr
		if(istype(user))
			user.DropItem()

obj/display/swap
	icon_state = "swap"
	var/character/user

	Click()
		var/character/user = usr
		if(istype(user))
			user.SwapActiveSlot()

obj/display/group_opener
	icon_state = "expand"
	var/display_group/group

	New(screen_loc, display_group/group)
		. = ..()
		src.group = group

	Click()
		group.Open(usr)

obj/display/group_closer
	icon_state = "close"
	var/display_group/group

	New(screen_loc, display_group/group)
		. = ..()
		src.group = group

	Click()
		group.Close(usr)

/character/proc/AddHUD(atom/hud)
	if(istype(hud,/list)) CRASH("RefSortedList is bugged and cannot accept lists of items for some reason.")
	if(!hud_objects) hud_objects = new()
	hud_objects.Add(hud)
	//world << "Added [hud] to HUD objects reflist."

/character/proc/RemoveHUD(atom/hud)
	if(istype(hud,/list)) CRASH("RefSortedList is bugged and cannot accept lists of items for some reason.")
	if(hud_objects) hud_objects.Remove(hud)
	//world << "Removed [hud] from HUD objects reflist."

/character/proc/UpdateHUD()
	if(!client)
		//world << "No client to update."
		return
	client.screen = hud_objects.contents
	//world << "HUD updated."