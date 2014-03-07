/*
The /obj/display atoms are only displayed on the screen, so they take a screen_loc
rather than a loc as a constructor argument. Usually, only one per function per game is
needed rather than assigning them to individual players.
*/

obj/display/layer = HUD_LAYER
obj/display/icon = 'Icons/HUD/Equip.dmi'

obj/display/New(screen_loc)
	src.screen_loc = screen_loc

//Associated with the name of a slot. This is used for things like hands, pockets, etc.
//Items will appear over this element for any slot associated with it.
obj/display/equipment
	var/slot_name  //The name of the slot it applies to.

	//Constructor takes slot name and this element's icon state in addition to screen loc.
	New(screen_loc, slot_name, icon_state)
		. = ..()
		src.name = slot_name
		src.slot_name = slot_name
		src.icon_state = icon_state

	Click()
		var/character/user = usr
		if(istype(user))
			user.OperateSlot(slot_name)

//A button that drops the active slot's item when clicked.
obj/display/drop
	icon_state = "drop"

	var/character/user

	Click()
		var/character/user = usr
		if(istype(user))
			user.DropItem()

//A button that swaps the active slot with another one. Implementation varies with user.
obj/display/swap
	icon_state = "swap"
	var/character/user

	Click()
		var/character/user = usr
		if(istype(user))
			user.SwapActiveSlot()

//Opens an associated display group. Created by display_group/CreateOpenButton().
obj/display/group_opener
	icon_state = "expand"
	var/display_group/group

	New(screen_loc, display_group/group)
		. = ..()
		src.group = group

	Click()
		group.Open(usr)

//Closes an associated display group. Created by display_group/CreateCloseButton()
obj/display/group_closer
	icon_state = "close"
	var/display_group/group

	New(screen_loc, display_group/group)
		. = ..()
		src.group = group

	Click()
		group.Close(usr)

//Adds an atom to the HUD.
/character/proc/AddHUD(atom/hud)
	if(istype(hud,/list)) CRASH("RefSortedList is bugged and cannot accept lists of items for some reason.")
	if(!hud_objects) hud_objects = new()
	hud_objects.Add(hud)
	//world << "Added [hud] to HUD objects reflist."

//Removes an atom from the HUD.
/character/proc/RemoveHUD(atom/hud)
	if(istype(hud,/list)) CRASH("RefSortedList is bugged and cannot accept lists of items for some reason.")
	if(hud_objects) hud_objects.Remove(hud)
	//world << "Removed [hud] from HUD objects reflist."

//Updates the HUD after its list has been changed. Does not need to be done for modifications to objects.
/character/proc/UpdateHUD()
	if(!client)
		//world << "No client to update."
		return
	if(hud_objects) client.screen = hud_objects.contents
	//world << "HUD updated."